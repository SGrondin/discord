open! Core_kernel
open! Basics

type t = {
  id: string;
  name: string;
  vip: bool;
  optimal: bool;
  deprecated: bool;
  custom: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t
