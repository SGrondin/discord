open! Core_kernel

module Open = struct
  type 'a state = {
    internal_state: Internal_state.t;
    user_state: 'a;
  }

  type 'a router_action =
    | R_Forward   of 'a state
    | R_Reconnect of (float option * 'a state)
end

open Open

let forward state = Lwt.return (R_Forward state)

let reconnect ~wait state = Lwt.return (R_Reconnect (wait, state))

type send = Websocket.Frame.t -> unit Lwt.t

let send_response send message =
  let content = Data.Payload.to_yojson message |> Yojson.Safe.to_string in
  Websocket.Frame.create ~opcode:Text ~content () |> send

let latch_identify = Latch.(create ~cooldown:(Time.sec 5L))

let identify Login.{ network_timeout = _; token; activity; status; afk; intents } send =
  let%lwt () = Latch.wait_and_trigger latch_identify in
  {
    token;
    properties = { os = "UNIX"; browser = Rest.Call.name; device = Rest.Call.name };
    compress = None;
    large_threshold = None;
    shard = None;
    presence = Some { since = None; activities = Some [ activity ]; status; afk };
    guild_subscriptions = None;
    intents;
  }
  |> Commands.Identify.to_payload
  |> send_response send

let resume Login.{ token; _ } send internal_state session_id =
  { token; session_id; seq = Internal_state.seq internal_state }
  |> Commands.Resume.to_payload
  |> send_response send

let handle_message login ~send ~cancel:(cancel_p, cancel) ({ internal_state; user_state } as state) =
  function
| _, Message.Hello hello ->
  let%lwt () =
    match Internal_state.session_id internal_state with
    | Some id -> resume login send internal_state id
    | None -> identify login send
  in
  let heartbeat_loop =
    Internal_state.{ interval = hello.heartbeat_interval; respond = send_response send; cancel_p; cancel }
  in
  let internal_state = Internal_state.received_hello heartbeat_loop internal_state in
  forward { internal_state; user_state }
| Data.Payload.{ op = Heartbeat; _ }, _ ->
  let%lwt () =
    Data.Payload.{ op = Opcode.Heartbeat_ACK; t = None; s = None; d = `Null } |> send_response send
  in
  forward state
| { op = Heartbeat_ACK; _ }, _ ->
  Internal_state.received_ack internal_state;
  forward state
| _, Invalid_session { resumable } ->
  if resumable
  then reconnect ~wait:None state
  else begin
    let wait = Some (Random.float_range 1.0 5.0) in
    reconnect ~wait { state with internal_state = Internal_state.create () }
  end
| _, Ready { session_id; _ } ->
  let internal_state = Internal_state.received_ready ~session_id internal_state in
  forward { internal_state; user_state }
| _, Reconnect -> reconnect ~wait:None state
| ({ op = Identify; _ } as x), _
 |({ op = Presence_update; _ } as x), _
 |({ op = Voice_state_update; _ } as x), _
 |({ op = Resume; _ } as x), _
 |({ op = Request_guild_members; _ } as x), _ ->
  failwithf "Unexpected opcode: %s. Please report this bug."
    ([%sexp_of: Data.Payload.t] x |> Sexp.to_string)
    ()
| _ -> forward state
