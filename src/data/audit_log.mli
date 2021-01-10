open! Core_kernel
open! Basics

module Partial_integration : sig
  type t = {
    id: Snowflake.t;
    name: string;
    type_: string;
    account: Integration.Account.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Partial_role : sig
  type t = {
    id: Snowflake.t;
    name: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Event : sig
  type t =
    | GUILD_UPDATE
    | CHANNEL_CREATE
    | CHANNEL_UPDATE
    | CHANNEL_DELETE
    | CHANNEL_OVERWRITE_CREATE
    | CHANNEL_OVERWRITE_UPDATE
    | CHANNEL_OVERWRITE_DELETE
    | MEMBER_KICK
    | MEMBER_PRUNE
    | MEMBER_BAN_ADD
    | MEMBER_BAN_REMOVE
    | MEMBER_UPDATE
    | MEMBER_ROLE_UPDATE
    | MEMBER_MOVE
    | MEMBER_DISCONNECT
    | BOT_ADD
    | ROLE_CREATE
    | ROLE_UPDATE
    | ROLE_DELETE
    | INVITE_CREATE
    | INVITE_UPDATE
    | INVITE_DELETE
    | WEBHOOK_CREATE
    | WEBHOOK_UPDATE
    | WEBHOOK_DELETE
    | EMOJI_CREATE
    | EMOJI_UPDATE
    | EMOJI_DELETE
    | MESSAGE_DELETE
    | MESSAGE_BULK_DELETE
    | MESSAGE_PIN
    | MESSAGE_UNPIN
    | INTEGRATION_CREATE
    | INTEGRATION_UPDATE
    | INTEGRATION_DELETE
    | Unknown                  of int

  include Shared.S_Base with type t := t
end

module Change : sig
  module Value : sig
    module Type : sig
      type t =
        | Other   of string
        | Channel of Channel.Type.t

      include Shared.S_Base with type t := t
    end

    type t =
      | Name                          of string
      | Icon_hash                     of Image_hash.t
      | Splash_hash                   of Image_hash.t
      | Owner_id                      of Snowflake.t
      | Region                        of string
      | Afk_channel_id                of Snowflake.t
      | Afk_timeout                   of Duration.Seconds.t
      | Mfa_level                     of Guild.MFA_level.t
      | Verification_level            of Guild.Verification_level.t
      | Explicit_content_filter       of Guild.Explicit_content_filter_level.t
      | Default_message_notifications of Guild.Default_message_notification_level.t
      | Vanity_url_code               of Url.t
      | ADD_ROLE                      of Partial_role.t list
      | REMOVE_ROLE                   of Partial_role.t list
      | Prune_delete_days             of Duration.Days.t
      | Widget_enabled                of bool
      | Widget_channel_id             of Snowflake.t
      | System_channel_id             of Snowflake.t
      | Position                      of int
      | Topic                         of string
      | Bitrate                       of int
      | Permission_overwrites         of Overwrite.t list
      | Nsfw                          of bool
      | Application_id                of Snowflake.t
      | Rate_limit_per_user           of int
      | Permissions                   of Permissions.t
      | Color                         of int
      | Hoist                         of bool
      | Mentionable                   of bool
      | Allow                         of Permissions.t
      | Deny                          of Permissions.t
      | Code                          of string
      | Channel_id                    of Snowflake.t
      | Inviter_id                    of Snowflake.t
      | Max_uses                      of int
      | Uses                          of int
      | Max_age                       of Duration.Seconds.t
      | Temporary                     of bool
      | Deaf                          of bool
      | Mute                          of bool
      | Nick                          of string
      | Avatar_hash                   of Image_hash.t
      | Id                            of Snowflake.t
      | Type                          of Type.t
      | Enable_emoticons              of bool
      | Expire_behavior               of Integration.Expire_behavior.t
      | Expire_grace_period           of Duration.Days.t
      | Unknown                       of (string * Json.t)

    include Shared.S_Base with type t := t
  end

  type t = {
    old_value: Value.t option;
    new_value: Value.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Entry : sig
  module Info : sig
    type t = {
      delete_member_days: string option;
      members_removed: string option;
      channel_id: Snowflake.t option;
      message_id: Snowflake.t option;
      count: string option;
      id: Snowflake.t option;
      type_: string option;
      role_name: string option;
    }
    [@@deriving fields]

    include Shared.S_Object with type t := t
  end

  type t = {
    target_id: string option;
    changes: Change.t list option;
    user_id: Snowflake.t;
    id: Snowflake.t;
    action_type: Event.t;
    options: Info.t option;
    reason: string option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

type t = {
  webhooks: Webhook.t list;
  users: User.t list;
  audit_log_entries: Entry.t list;
  integrations: Integration.t list;
}
[@@deriving fields]

include Shared.S_Object with type t := t
