open! Core_kernel
open! Basics

module Channel_pins_update = struct
  type t = {
    guild_id: Snowflake.t option; [@default None]
    channel_id: Snowflake.t;
    last_pin_timestamp: Timestamp.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Guild_ban = struct
  type t = {
    guild_id: Snowflake.t;
    user: User.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Guild_emojis_update = struct
  type t = {
    guild_id: Snowflake.t;
    emojis: Emoji.t list;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Guild_integrations_update = struct
  type t = { guild_id: Snowflake.t }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }] [@@unboxed]
end

module Guild_member_remove = struct
  type t = {
    guild_id: Snowflake.t;
    user: User.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Guild_role = struct
  type t = {
    guild_id: Snowflake.t;
    role: Role.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Guild_role_delete = struct
  type t = {
    guild_id: Snowflake.t;
    role_id: Snowflake.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Invite_create = struct
  type t = {
    channel_id: Snowflake.t;
    code: string;
    created_at: Timestamp.t;
    guild_id: Snowflake.t option; [@default None]
    inviter: User.t option; [@default None]
    max_age: Duration.Seconds.t;
    max_uses: int;
    target_user: User.t option; [@default None]
    target_user_type: Invite.Target_user_type.t option; [@default None]
    temporary: bool;
    uses: int;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Invite_delete = struct
  type t = {
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    code: string;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_delete = struct
  type t = {
    id: Snowflake.t;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_delete_bulk = struct
  type t = {
    ids: Snowflake.t list;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_reaction_add = struct
  type t = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    member: User.member option; [@default None]
    emoji: Emoji.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_reaction_remove = struct
  type t = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    emoji: Emoji.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_reaction_remove_all = struct
  type t = {
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Message_reaction_remove_emoji = struct
  type t = {
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    emoji: Emoji.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Typing_start = struct
  type t = {
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    user_id: Snowflake.t;
    timestamp: Duration.Seconds.t;
    member: User.member option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Webhook_update = struct
  type t = {
    guild_id: Snowflake.t;
    channel_id: Snowflake.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end
