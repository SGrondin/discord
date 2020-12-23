open! Core_kernel

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
[@@deriving sexp]

val parse : Data.Payload.t -> t
