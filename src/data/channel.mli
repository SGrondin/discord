open! Core_kernel
open! Basics

module Type : sig
  type t =
    | GUILD_TEXT
    | DM
    | GUILD_VOICE
    | GROUP_DM
    | GUILD_CATEGORY
    | GUILD_NEWS
    | GUILD_STORE
    | Unknown        of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  id: Snowflake.t;
  type_: Type.t;
  guild_id: Snowflake.t option;
  position: int option;
  permission_overwrites: Overwrite.t list option;
  name: string option;
  topic: string option;
  nsfw: bool option;
  last_message_id: Snowflake.t option;
  bitrate: int option;
  user_limit: int option;
  rate_limit_per_user: Duration.Seconds.t option;
  recipients: User.t list option;
  icon: Image_hash.t option;
  owner_id: Snowflake.t option;
  application_id: Snowflake.t option;
  parent_id: Snowflake.t option;
  last_pin_timestamp: Timestamp.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
