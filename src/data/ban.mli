open! Core_kernel
open! Basics

type t = {
  reason: string option;
  user: User.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
