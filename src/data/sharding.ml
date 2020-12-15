open! Core_kernel
open! Basics

module Self = struct
  type t = {
    shard_id: int;
    num_shards: int;
  }
  [@@deriving sexp, compare, equal, fields]

  let to_yojson { shard_id; num_shards } = `List [ `Int shard_id; `Int num_shards ]

  let of_yojson = function
  | `List [ `Int shard_id; `Int num_shards ] -> Ok { shard_id; num_shards }
  | json -> Shared.invalid json "sharding"
end

include Self
