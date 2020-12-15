open! Core_kernel
open! Basics

type t = {
  token: string;
  session_id: string;
  seq: int option;
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
