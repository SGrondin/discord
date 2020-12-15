open! Core_kernel
open! Basics

module Type : sig
  type t =
    | Deprecated_type_1
    | Incoming
    | Channel_follower
    | Unknown           of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  id: Snowflake.t;
  type_: Type.t;
  guild_id: Snowflake.t option;
  channel_id: Snowflake.t;
  user: User.t option;
  name: string option;
  avatar: string option;
  token: string option;
  application_id: Snowflake.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
