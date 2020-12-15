open! Core_kernel
open! Basics

type t = {
  guild_id: Snowflake.t option;
  channel_id: Snowflake.t option;
  user_id: Snowflake.t;
  member: User.member option;
  session_id: string;
  deaf: bool;
  mute: bool;
  self_deaf: bool;
  self_mute: bool;
  self_stream: bool option;
  self_video: bool;
  suppress: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t
