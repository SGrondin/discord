open! Core_kernel
open! Basics

module Status : sig
  type t =
    | Idle
    | DND
    | Online
    | Offline
    | Invisible
    | Unknown   of string
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Client_status : sig
  type t = {
    desktop: Status.t option;
    mobile: Status.t option;
    web: Status.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module User_id : sig
  type t = { id: Snowflake.t } [@@deriving fields] [@@unboxed]

  include Shared.S_Object with type t := t
end

type t = {
  user: User_id.t;
  guild_id: Snowflake.t option;
  status: Status.t;
  activities: Activity.t list;
  client_status: Client_status.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
