open! Core_kernel
open! Basics

type t = {
  code: string;
  name: string;
  description: string option;
  usage_count: int;
  creator_id: Snowflake.t;
  creator: User.t;
  created_at: Timestamp.t;
  updated_at: Timestamp.t;
  source_guild_id: Snowflake.t;
  serialized_source_guild: Guild.t;
  is_dirty: bool option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
