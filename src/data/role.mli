open! Core_kernel
open! Basics

type t = {
  id: Snowflake.t;
  name: string;
  color: int;
  hoist: bool;
  position: int;
  permissions: Permissions.t;
  managed: bool;
  mentionable: bool;
}
[@@deriving fields]

include Shared.S_Object with type t := t
