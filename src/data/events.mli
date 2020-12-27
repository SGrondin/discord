open! Core_kernel
open! Basics

module Channel_pins_update : sig
  type t = {
    guild_id: Snowflake.t option;
    channel_id: Snowflake.t;
    last_pin_timestamp: Timestamp.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Guild_ban : sig
  type t = {
    guild_id: Snowflake.t;
    user: User.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Guild_emojis_update : sig
  type t = {
    guild_id: Snowflake.t;
    emojis: Emoji.t list;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Guild_integrations_update : sig
  type t = { guild_id: Snowflake.t } [@@deriving fields] [@@unboxed]

  include Shared.S_Object with type t := t
end

module Guild_member_remove : sig
  type t = {
    guild_id: Snowflake.t;
    user: User.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Guild_role : sig
  type t = {
    guild_id: Snowflake.t;
    role: Role.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Guild_role_delete : sig
  type t = {
    guild_id: Snowflake.t;
    role_id: Snowflake.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Invite_create : sig
  type t = {
    channel_id: Snowflake.t;
    code: string;
    created_at: Timestamp.t;
    guild_id: Snowflake.t option;
    inviter: User.t option;
    max_age: Duration.Seconds.t;
    max_uses: int;
    target_user: User.t option;
    target_user_type: Invite.Target_user_type.t option;
    temporary: bool;
    uses: int;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Invite_delete : sig
  type t = {
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option;
    code: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_delete : sig
  type t = {
    id: Snowflake.t;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_delete_bulk : sig
  type t = {
    ids: Snowflake.t list;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_reaction_add : sig
  type t = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option;
    member: User.member option;
    emoji: Emoji.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_reaction_remove : sig
  type t = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option;
    emoji: Emoji.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_reaction_remove_all : sig
  type t = {
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Message_reaction_remove_emoji : sig
  type t = {
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option;
    emoji: Emoji.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Typing_start : sig
  type t = {
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option;
    user_id: Snowflake.t;
    timestamp: Duration.Seconds.t;
    member: User.member option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Webhook_update : sig
  type t = {
    guild_id: Snowflake.t;
    channel_id: Snowflake.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end
