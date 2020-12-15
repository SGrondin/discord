open! Core_kernel
open! Basics

module Visibility : sig
  type t =
    | NONE
    | Everyone
    | Unknown  of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  id: string;
  name: string;
  type_: string;
  revoked: bool option;
  integrations: Integration.t list option;
  verified: bool;
  friend_sync: bool;
  show_activity: bool;
  visibility: Visibility.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
