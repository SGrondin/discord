open! Core_kernel
open! Basics

module Self = struct
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
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

(* The example in the docs is not usable *)
