open! Core_kernel
open! Basics

type t = {
  shard_id: int;
  num_shards: int;
}
[@@deriving fields]

include Shared.S_Object with type t := t
