open! Core_kernel
open Router.Open

type close =
  | Reconnecting
  | Final
  | Exception    of Exn.t

let code_of_close = function
| Reconnecting -> 4000
| Final -> 1000
| Exception _ -> 4001

type event =
  | Payload                    of Data.Payload.t
  | Received                   of Event.t
  | Before_connecting          of Rest.Gateway.t
  | Before_reconnecting
  | Error_connection_closed
  | Error_connection_reset
  | Error_connection_timed_out
  | Error_discord_server       of {
      extension: int;
      final: bool;
      content: string;
    }
  | Error_discontinuity        of Internal_state.counter
[@@deriving sexp]

exception
  API_error of {
    data: string;
    message: string;
    exn: Exn.t;
  }
[@@deriving sexp]

type connection = {
  network_timeout: float;
  ic: Lwt_io.input_channel;
  oc: Lwt_io.output_channel;
  send: Websocket.Frame.t -> unit Lwt.t;
}

type 'a action =
  | Forward   of 'a Router.Open.state
  | Reconnect of (float option * 'a Router.Open.state)
  | Exn       of Exn.t

let do_forward state = Lwt.return (Forward state)

let do_reconnect ~wait state = Lwt.return (Reconnect (wait, state))

let do_exn exn = Lwt.return (Exn exn)

let in_background ~on_exn f = Lwt.async (fun () -> Lwt.catch f on_exn)

module type S = sig
  type state

  val create : unit -> state

  val on_exn : exn -> unit Lwt.t

  val on_closing_connection : close -> unit Lwt.t

  val on_event : state -> event -> state Lwt.t
end

module Make (Bot : S) : sig
  val start : Login.t -> unit Lwt.t * (unit -> unit)
end = struct
  let blank_state () = { internal_state = Internal_state.create (); user_state = Bot.create () }

  let trigger_event user_state event =
    Lwt.catch
      (fun () -> Bot.on_event user_state event)
      Lwt.Infix.(
        function
        | Exit -> Exn.reraise Exit (Source_code_position.to_string [%here])
        | exn -> Bot.on_exn exn >|= fun () -> user_state)

  let close_connection { network_timeout; ic; oc; send; _ } close =
    let code = code_of_close close in
    let%lwt () = Bot.on_closing_connection close in
    let%lwt () =
      if Lwt_io.is_closed oc
      then Lwt.return_unit
      else Lwt.catch (fun () -> send @@ Websocket.Frame.close code) (fun _exn -> Lwt.return_unit)
    in
    Lwt_unix.with_timeout network_timeout (fun () ->
        let%lwt () = Lwt_io.close oc in
        Lwt_io.close ic)

  let handle_frame login send ({ internal_state; user_state } as state) frame =
    let open Websocket in
    match frame with
    | Frame.{ opcode = Ping; _ } ->
      let%lwt () = send @@ Frame.create ~opcode:Frame.Opcode.Pong () in
      Router.forward state
    | Frame.{ opcode = Close; extension; final; content } ->
      let%lwt user_state =
        trigger_event user_state (Error_discord_server { extension; final; content })
      in
      Router.reconnect ~wait:None { internal_state; user_state }
    | Frame.{ opcode = Pong; _ } -> Router.forward state
    | Frame.{ opcode = Text; content; _ }
     |Frame.{ opcode = Binary; content; _ } ->
      let raw = Yojson.Safe.from_string content |> Data.Payload.of_yojson |> Result.ok_or_failwith in
      let%lwt user_state = trigger_event user_state (Payload raw) in
      Internal_state.received_seq raw.s internal_state;
      Lwt.try_bind
        (fun () -> Lwt.return (Event.parse raw))
        (fun message ->
          let%lwt user_state = trigger_event user_state (Received message) in
          Router.handle_message login ~send { internal_state; user_state } (raw, message))
        (fun exn ->
          let%lwt () = Bot.on_exn (API_error { data = content; message = Exn.to_string exn; exn }) in
          Router.forward { internal_state; user_state })
    | frame -> failwithf "Unhandled frame: %s" (Frame.show frame) ()

  let rec event_loop login connection recv ({ internal_state; user_state } as state) =
    let%lwt action =
      Lwt.catch
        (fun () ->
          Internal_state.raise_if_heartbeat_error internal_state;
          let%lwt frame = recv () in
          match%lwt handle_frame login connection.send state frame with
          | R_Forward state -> do_forward state
          | R_Reconnect (wait, { internal_state; user_state }) ->
            Internal_state.terminate internal_state;
            let%lwt user_state = trigger_event user_state Before_reconnecting in
            do_reconnect ~wait { internal_state; user_state })
        (fun exn ->
          Internal_state.terminate internal_state;
          let open Core in
          match exn with
          | Lwt_io.Channel_closed _
           |End_of_file ->
            let%lwt user_state = trigger_event user_state Error_connection_closed in
            do_reconnect ~wait:None { internal_state; user_state }
          | Internal_state.Discontinuity_error counter ->
            let%lwt user_state = trigger_event user_state (Error_discontinuity counter) in
            do_reconnect ~wait:None { internal_state = Internal_state.create (); user_state }
          | exn -> (
            (* Cohttp wraps Unix errors into its own abstract IO_error type. This is the only way to unwrap them. *)
            match%lwt Cohttp_lwt_unix.IO.catch (fun () -> raise exn) with
            | Error (Unix.Unix_error (Unix.ECONNRESET, _c, _s)) ->
              let%lwt user_state = trigger_event user_state Error_connection_reset in
              do_reconnect ~wait:None { internal_state; user_state }
            | Error (Unix.Unix_error (Unix.ETIMEDOUT, _c, _s)) ->
              let%lwt user_state = trigger_event user_state Error_connection_timed_out in
              do_reconnect ~wait:None { internal_state; user_state }
            (* Non-IO errors such as errors in our or user code *)
            | exception _ -> do_exn exn
            (* Remaining IO errors *)
            | Error _
            (* Impossible case *)
             |Ok _ ->
              do_exn exn
          ))
    in
    match action with
    | Forward state -> (event_loop [@tailcall]) login connection recv state
    | x -> Lwt.return x

  let connect shutdown (Login.{ network_timeout; token; _ } as login) state =
    let%lwt gateway = Rest.Gateway.bot ~token in
    let uri =
      begin
        match Uri.scheme gateway.url with
        | None
         |Some "wss" ->
          Uri.with_scheme gateway.url (Some "https")
        | Some "ws" -> Uri.with_scheme gateway.url (Some "http")
        | Some x -> failwithf "Invalid scheme in WS connect: %s" x ()
      end
      |> Fn.flip Uri.add_query_params [ "v", [ "8" ]; "encoding", [ "json" ] ]
    in

    let%lwt state =
      let%lwt user_state = trigger_event state.user_state (Before_connecting gateway) in
      Lwt.return { state with user_state }
    in
    let%lwt recv, send, ic, oc =
      let%lwt endp = Resolver_lwt.resolve_uri ~uri Resolver_lwt_unix.system in
      let ctx = Conduit_lwt_unix.default_ctx in
      let%lwt client = Conduit_lwt_unix.endp_to_client ~ctx endp in
      Ws.with_connection ~ctx client uri
    in

    let send_timeout network_timeout send frame =
      Lwt_unix.with_timeout network_timeout (fun () -> send frame)
    in

    let connection = { network_timeout; ic; oc; send = send_timeout network_timeout send } in

    let cancelable_recv recv shutdown () = Lwt.choose [ recv (); shutdown ] in

    let%lwt action = event_loop login connection (cancelable_recv recv shutdown) state in
    Lwt.return (action, connection)

  let rec connection_loop shutdown login previous_state =
    let%lwt state =
      let state = Option.value previous_state ~default:(blank_state ()) in
      match%lwt connect shutdown login state with
      | Forward state, _ -> Lwt.return_some state
      | Reconnect (wait, state), connection ->
        let%lwt () = close_connection connection Reconnecting in
        let%lwt () = Option.value_map wait ~default:Lwt.return_unit ~f:Lwt_unix.sleep in
        Lwt.return_some state
      | Exn Exit, connection ->
        let%lwt () = close_connection connection Final in
        Lwt.return_none
      | Exn exn, connection ->
        let%lwt () = close_connection connection (Exception exn) in
        let%lwt () = Bot.on_exn exn in
        let%lwt () = Lwt_unix.sleep 5.0 in
        (* Reset the user state to avoid an infinite crash loop *)
        Lwt.return_some (blank_state ())
    in
    match state with
    | Some _ as state -> (connection_loop [@tailcall]) shutdown login state
    | None -> Lwt.return_unit

  let start login =
    let p, w = Lwt.wait () in
    let cancel () = Lwt.wakeup_later_exn w Exit in
    connection_loop p login None, cancel
end
