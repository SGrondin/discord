open! Core_kernel

type counter = {
  count: int;
  ack: int;
}
[@@deriving sexp]

exception Discontinuity_error of counter

type heartbeat = {
  mutable until: bool;
  mutable seq: int option;
  mutable ack: int;
  mutable count: int;
  mutable heartbeat_error: Exn.t option; [@sexp.opaque]
}
[@@deriving sexp_of]

type heartbeat_loop = {
  interval: int;
  respond: Data.Payload.t -> unit Lwt.t;
}

let rec loop heartbeat ({ respond; interval } as heartbeat_loop) =
  let%lwt () = Lwt_unix.sleep (interval // 1000) in
  if heartbeat.until || Option.is_some heartbeat.heartbeat_error
  then Lwt.return_unit
  else begin
    let%lwt () =
      Lwt.catch
        (fun () ->
          if heartbeat.ack < heartbeat.count
          then begin
            heartbeat.heartbeat_error <-
              Some (Discontinuity_error { count = heartbeat.count; ack = heartbeat.ack });
            Lwt.return_unit
          end
          else begin
            heartbeat.count <- heartbeat.count + 1;
            respond @@ Commands.Heartbeat.to_payload heartbeat.seq
          end)
        (fun exn ->
          heartbeat.heartbeat_error <- Some exn;
          Lwt.return_unit)
    in
    (loop [@tailcall]) heartbeat heartbeat_loop
  end

let start_heartbeat heartbeat_loop ~seq =
  let heartbeat = { until = false; seq; ack = 0; count = 0; heartbeat_error = None } in
  Lwt.async (fun () -> loop heartbeat heartbeat_loop);
  heartbeat

let stop_heartbeat heartbeat = heartbeat.until <- true

type t =
  | Starting    of int option
  | After_hello of heartbeat
  | Connected   of {
      heartbeat: heartbeat;
      session_id: string;
    }
[@@deriving sexp_of]

let create () = Starting None

let received_hello heartbeat_loop = function
| Starting seq -> After_hello (start_heartbeat heartbeat_loop ~seq)
| After_hello heartbeat ->
  stop_heartbeat heartbeat;
  After_hello (start_heartbeat heartbeat_loop ~seq:heartbeat.seq)
| Connected { heartbeat; session_id } ->
  stop_heartbeat heartbeat;
  Connected { heartbeat = start_heartbeat heartbeat_loop ~seq:heartbeat.seq; session_id }

let received_ready ~session_id = function
| After_hello heartbeat -> Connected { heartbeat; session_id }
| (Starting _ as x)
 |(Connected _ as x) ->
  failwithf "Invalid internal state transition to_connected: %s. Please report this bug."
    (sexp_of_t x |> Sexp.to_string)
    ()

let received_seq seq = function
| Starting _ -> ()
| After_hello heartbeat
 |Connected { heartbeat; _ } ->
  Option.iter seq ~f:(fun _s -> heartbeat.seq <- seq)

let received_ack = function
| Starting _ -> ()
| After_hello heartbeat
 |Connected { heartbeat; _ } ->
  heartbeat.ack <- heartbeat.ack + 1

let raise_if_heartbeat_error = function
| Starting _
 |After_hello { heartbeat_error = None; _ }
 |Connected { heartbeat = { heartbeat_error = None; _ }; _ } ->
  ()
| After_hello { heartbeat_error = Some exn; _ }
 |Connected { heartbeat = { heartbeat_error = Some exn; _ }; _ } ->
  raise exn

let terminate = function
| Starting _ -> ()
| After_hello heartbeat
 |Connected { heartbeat; _ } ->
  stop_heartbeat heartbeat

let seq = function
| Starting seq
 |After_hello { seq; _ }
 |Connected { heartbeat = { seq; _ }; _ } ->
  seq

let session_id = function
| Starting _
 |After_hello _ ->
  None
| Connected { session_id; _ } -> Some session_id
