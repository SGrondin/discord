open! Core_kernel
open! Basics

type t = {
  id: Snowflake.t option;
  name: string option;
  roles: Snowflake.t list option;
  user: User.t option;
  require_colons: bool option;
  managed: bool option;
  animated: bool option;
  available: bool option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
