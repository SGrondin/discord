open! Core_kernel
open! Basics

type t = { heartbeat_interval: int } [@@unboxed] [@@deriving fields]

include Shared.S_Object with type t := t
