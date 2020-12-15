open! Core_kernel

type parsed =
  | Hello              of Events.Hello.t
  | Invalid_session    of Events.Invalid_session.t
  | Reconnect
  | Ready              of Events.Ready.t
  | Resumed
  | Voice_state_update of Data.Voice_state.t
  | Guild_create       of Data.Guild.t
  | Message_create     of Data.Message.t
  | Other
[@@deriving sexp]

type t = {
  raw: Data.Payload.t;
  parsed: parsed;
}
[@@deriving sexp]

val parse : Data.Payload.t -> t
