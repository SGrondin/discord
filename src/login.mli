open! Core_kernel

type t = {
  network_timeout: float;
  token: string;
  intents: Commands.Identify.Intents.t;
  activity: Data.Activity.t;
  status: Data.Presence_update.Status.t;
  afk: bool;
}
[@@deriving sexp, compare, equal, yojson]

val create :
  ?network_timeout:float ->
  token:string ->
  intents:Commands.Identify.Intent.t list ->
  ?activity_name:string ->
  ?activity_type:Data.Activity.Type.t ->
  ?status:Data.Presence_update.Status.t ->
  ?afk:bool ->
  unit ->
  t
