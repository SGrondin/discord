open! Core_kernel
open! Basics

module Flag : sig
  type t =
    | Discord_employee
    | Partnered_server_owner
    | Hypesquad_events
    | Bug_hunter_level_1
    | Deprecated_flag_4
    | Deprecated_flag_5
    | House_bravery
    | House_brilliance
    | House_balance
    | Early_supporter
    | Team_user
    | Deprecated_flag_11
    | System
    | Deprecated_flag_13
    | Bug_hunter_level_2
    | Deprecated_flag_15
    | Verified_bot
    | Early_verified_bot_developer

  include Shared.S_Bitfield with type t := t
end

module Flags : Bitfield.S with type elt := Flag.t

module Premium : sig
  type t =
    | None_
    | Nitro_classic
    | Nitro
    | Unknown       of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type member = {
  guild_id: Snowflake.t option;
  user: t option;
  nick: string option;
  roles: Snowflake.t list;
  joined_at: Timestamp.t;
  premium_since: Timestamp.t option;
  deaf: bool option;
  mute: bool option;
}

and t = {
  id: Snowflake.t;
  username: string;
  discriminator: string;
  avatar: Image_hash.t option;
  bot: bool option;
  system: bool option;
  mfa_enabled: bool option;
  locale: string option;
  verified: bool option;
  email: string option;
  flags: Flags.t option;
  premium_type: Premium.t option;
  public_flags: Flags.t option;
  member: member option;
}
[@@deriving sexp, compare, equal, yojson]

module Util : sig
  val is_bot : member option -> bool

  val member_id : member -> Snowflake.t option

  val member_name : member -> string option
end
