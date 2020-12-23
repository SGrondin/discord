open! Core_kernel
open Data.Payload

type t =
  | Hello              of Events.Hello.t
  | Ready              of Events.Ready.t
  | Resumed
  | Reconnect
  | Invalid_session    of Events.Invalid_session.t
  | Voice_state_update of Data.Voice_state.t
  | Guild_create       of Data.Guild.t
  | Message_create     of Data.Message.t
  | Presence_update    of Data.Presence_update.t
  | Other
[@@deriving sexp, variants]

let load d p f = d |> p |> Result.ok_or_failwith |> f

let parse = function
| { op = Hello; d; _ } -> load d Events.Hello.of_yojson hello
| { op = Dispatch; t = Some "READY"; s = _; d } -> load d Events.Ready.of_yojson ready
| { op = Dispatch; t = Some "RESUMED"; s = _; d = _ } -> Resumed
| { op = Reconnect; _ } -> Reconnect
| { op = Invalid_session; d; _ } -> load d Events.Invalid_session.of_yojson invalid_session
| { op = Dispatch; t = Some "VOICE_STATE_UPDATE"; s = _; d } ->
  load d Data.Voice_state.of_yojson voice_state_update
| { op = Dispatch; t = Some "GUILD_CREATE"; s = _; d } -> load d Data.Guild.of_yojson guild_create
| { op = Dispatch; t = Some "MESSAGE_CREATE"; s = _; d } -> load d Data.Message.of_yojson message_create
| { op = Dispatch; t = Some "PRESENCE_UPDATE"; s = _; d } ->
  load d Data.Presence_update.of_yojson presence_update
| _ -> Other
