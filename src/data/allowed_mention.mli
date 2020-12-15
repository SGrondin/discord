open! Core_kernel
open! Basics

module Type : sig
  type t =
    | Roles
    | Users
    | Everyone
    | Unknown  of string
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  parse: Type.t list;
  roles: Snowflake.t list;
  users: Snowflake.t list;
  replied_user: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t
