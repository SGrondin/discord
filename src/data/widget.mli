open! Core_kernel
open! Basics

type t = {
  enabled: bool;
  channel_id: Snowflake.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
