open! Core_kernel
open! Basics

type t = {
  count: int;
  me: bool;
  emoji: Emoji.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
