open! Core_kernel
open! Basics

module Self = struct
  type t = {
    v: int;
    user: Data.User.t;
    guilds: Data.Unavailable_guild.t list;
    session_id: string;
    shard: Data.Sharding.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
