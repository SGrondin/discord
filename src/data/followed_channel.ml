open! Core_kernel
open! Basics

module Self = struct
  type t = {
    channel_id: Snowflake.t;
    webhook_id: Snowflake.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
