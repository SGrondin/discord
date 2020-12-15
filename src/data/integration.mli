open! Core_kernel
open! Basics

module Account : sig
  type t = {
    id: string;
    name: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Expire_behavior : sig
  type t =
    | Remove_role
    | Kick
    | Unknown     of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Application : sig
  type t = {
    id: Snowflake.t;
    name: string;
    icon: Image_hash.t option;
    description: string;
    summary: string;
    bot: User.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

type t = {
  id: Snowflake.t;
  name: string;
  type_: string;
  enabled: bool;
  syncing: bool option;
  role_id: Snowflake.t option;
  enable_emoticons: bool option;
  expire_behavior: Expire_behavior.t option;
  expire_grace_period: Duration.Days.t option;
  user: User.t option;
  account: Account.t;
  synced_at: Timestamp.t option;
  subscriber_count: int option;
  revoked: bool option;
  application: Application.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
