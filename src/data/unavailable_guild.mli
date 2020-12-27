open! Core_kernel
open! Basics

type t = {
  id: Snowflake.t;
  unavailable: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t
