open! Core_kernel
open! Basics

module Self = struct
  type t = {
    id: string;
    name: string;
    vip: bool;
    optimal: bool;
    deprecated: bool;
    custom: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
