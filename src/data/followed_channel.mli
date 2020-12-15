open! Core_kernel
open! Basics

type t = {
  channel_id: Snowflake.t;
  webhook_id: Snowflake.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
