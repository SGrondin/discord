open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | Role
      | Member
      | Unknown of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    id: Snowflake.t;
    type_: Type.t; [@key "type"]
    allow: Permissions.t;
    deny: Permissions.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
