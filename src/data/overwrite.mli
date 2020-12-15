open! Core_kernel
open! Basics

module Type : sig
  type t =
    | Role
    | Member
    | Unknown of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  id: Snowflake.t;
  type_: Type.t; [@key "type"]
  allow: Permissions.t;
  deny: Permissions.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
