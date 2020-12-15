open! Core_kernel
open! Basics

type t = {
  (* TODO *)
  since: Int64.t option;
  activities: Data.Activity.t list option;
  status: Data.Presence_update.Status.t;
  afk: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
