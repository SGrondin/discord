open! Core_kernel
open! Basics

type t = {
  guild_id: Snowflake.t;
  channel_id: Snowflake.t option;
  self_mute: bool;
  self_deaf: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
