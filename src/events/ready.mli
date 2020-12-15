open! Core_kernel
open! Basics

type t = {
  v: int;
  user: Data.User.t;
  guilds: Data.Unavailable_guild.t list;
  session_id: string;
  shard: Data.Sharding.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
