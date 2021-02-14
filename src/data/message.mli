open! Core_kernel
open! Basics

module Type : sig
  type t =
    | DEFAULT
    | RECIPIENT_ADD
    | RECIPIENT_REMOVE
    | CALL
    | CHANNEL_NAME_CHANGE
    | CHANNEL_ICON_CHANGE
    | CHANNEL_PINNED_MESSAGE
    | GUILD_MEMBER_JOIN
    | USER_PREMIUM_GUILD_SUBSCRIPTION
    | USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_1
    | USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_2
    | USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_3
    | CHANNEL_FOLLOW_ADD
    | Deprecated_type_1
    | GUILD_DISCOVERY_DISQUALIFIED
    | GUILD_DISCOVERY_REQUALIFIED
    | Deprecated_type_2
    | Deprecated_type_3
    | Deprecated_type_4
    | REPLY
    | APPLICATION_COMMAND
    | Unknown                                of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Activity : sig
  module Type : sig
    type t =
      | Deprecated_type_1
      | JOIN
      | SPECTATE
      | LISTEN
      | Deprecated_type_2
      | JOIN_REQUEST
      | Unknown           of int
    [@@deriving variants]

    include Shared.S_Enum with type t := t
  end

  type t = {
    type_: Type.t;
    party_id: string option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Application : sig
  type t = {
    id: Snowflake.t;
    cover_image: Image_hash.t option;
    description: string;
    icon: Image_hash.t option;
    name: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Reference : sig
  type t = {
    message_id: Snowflake.t option;
    channel_id: Snowflake.t option;
    guild_id: Snowflake.t option;
    fail_if_not_exists: bool option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Flag : sig
  type t =
    | CROSSPOSTED
    | IS_CROSSPOST
    | SUPPRESS_EMBEDS
    | SOURCE_MESSAGE_DELETED
    | URGENT

  include Shared.S_Bitfield with type t := t
end

module Flags : Bitfield.S with type Elt.t := Flag.t

module Sticker : sig
  module Format : sig
    type t =
      | Deprecated_type_1
      | PNG
      | APNG
      | LOTTIE
      | Unknown           of int
    [@@deriving variants]

    include Shared.S_Enum with type t := t
  end

  type t = {
    id: Snowflake.t;
    pack_id: Snowflake.t;
    name: string;
    description: string;
    tags: string option;
    asset: Image_hash.t;
    preview_asset: Image_hash.t option;
    format_type: Format.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Channel_mention : sig
  type t = {
    id: Snowflake.t;
    guild_id: Snowflake.t;
    type_: Channel.Type.t;
    name: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

type t = {
  id: Snowflake.t;
  channel_id: Snowflake.t;
  guild_id: Snowflake.t option;
  author: User.t;
  member: User.member option;
  content: string;
  timestamp: Timestamp.t;
  edited_timestamp: Timestamp.t option;
  tts: bool;
  mention_everyone: bool;
  mentions: User.t list;
  mention_roles: Snowflake.t list;
  mention_channels: Channel_mention.t list option;
  attachments: Attachment.t list;
  embeds: Embed.t list;
  reactions: Reaction.t list option;
  nonce: Nonce.t option;
  pinned: bool;
  webhook_id: Snowflake.t option;
  type_: Type.t;
  activity: Activity.t option;
  application: Application.t option;
  message_reference: Reference.t option;
  flags: Flags.t option;
  stickers: Sticker.t list option;
  referenced_message: t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t

module Update : sig
  type message = t

  type t = {
    id: Snowflake.t;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option;
    author: User.t option;
    member: User.member option;
    content: string option;
    timestamp: Timestamp.t option;
    edited_timestamp: Timestamp.t option;
    tts: bool option;
    mention_everyone: bool option;
    mentions: User.t list option;
    mention_roles: Snowflake.t list option;
    mention_channels: Channel_mention.t list option;
    attachments: Attachment.t list option;
    embeds: Embed.t list option;
    reactions: Reaction.t list option;
    nonce: Nonce.t option;
    pinned: bool option;
    webhook_id: Snowflake.t option;
    type_: Type.t option;
    activity: Activity.t option;
    application: Application.t option;
    message_reference: Reference.t option;
    flags: Flags.t option;
    stickers: Sticker.t list option;
    referenced_message: message option;
  }
  [@@deriving fields]

  val of_message : message -> t

  include Shared.S_Object with type t := t
end
