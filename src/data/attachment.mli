open! Core_kernel
open! Basics

type t = {
  id: Snowflake.t;
  filename: string;
  size: int;
  url: Url.t;
  proxy_url: Url.t;
  height: int option;
  width: int option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
