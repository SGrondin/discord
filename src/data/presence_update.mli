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
    desktop: Status.t option; [@default None]
    mobile: Status.t option; [@default None]
    web: Status.t option; [@default None]
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

type t = {
  user: User.t;
  guild_id: Snowflake.t;
  status: Status.t;
  activities: Activity.t list;
  client_status: Client_status.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t
