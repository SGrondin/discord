open! Core_kernel
open! Basics

type t = {
  id: Snowflake.t;
  name: string;
  icon: Image_hash.t option;
  splash: Image_hash.t option;
  discovery_splash: Image_hash.t option;
  emojis: Emoji.t list;
  features: Guild.Feature.t list;
  approximate_member_count: int;
  approximate_presence_count: int;
  description: string option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
