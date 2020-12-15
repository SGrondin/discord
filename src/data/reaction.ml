open! Core_kernel
open! Basics

module Self = struct
  type t = {
    count: int;
    me: bool;
    emoji: Emoji.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
