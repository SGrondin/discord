open! Core_kernel
open! Basics

module Visibility = struct
  module Self = struct
    type t =
      | NONE
      | Everyone
      | Unknown  of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    id: string;
    name: string;
    type_: string; [@key "type"]
    revoked: bool option; [@default None]
    integrations: Integration.t list option; [@default None]
    verified: bool;
    friend_sync: bool;
    show_activity: bool;
    visibility: Visibility.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
