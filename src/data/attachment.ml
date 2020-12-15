open! Core_kernel
open! Basics

module Self = struct
  type t = {
    id: Snowflake.t;
    filename: string;
    size: int;
    url: Url.t;
    proxy_url: Url.t;
    height: int option;
    width: int option;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
