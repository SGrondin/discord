open! Core_kernel
open! Basics

type t = { id: Snowflake.t } [@@unboxed] [@@deriving fields]

include Shared.S_Object with type t := t
