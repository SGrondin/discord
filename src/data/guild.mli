open! Core_kernel
open! Basics

module Verification_level : sig
  type t =
    | NONE
    | LOW
    | MEDIUM
    | HIGH
    | VERY_HIGH
    | Unknown   of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Premium_tier : sig
  type t =
    | NONE
    | TIER_1
    | TIER_2
    | TIER_3
    | Unknown of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Default_message_notification_level : sig
  type t =
    | ALL_MESSAGES
    | ONLY_MENTIONS
    | Unknown       of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Explicit_content_filter_level : sig
  type t =
    | DISABLED
    | MEMBERS_WITHOUT_ROLES
    | ALL_MEMBERS
    | Unknown               of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module MFA_level : sig
  type t =
    | NONE
    | Elevated
    | Unknown  of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module System_channel_flag : sig
  type t =
    | SUPPRESS_JOIN_NOTIFICATIONS
    | SUPPRESS_PREMIUM_SUBSCRIPTIONS

  include Shared.S_Bitfield with type t := t
end

module System_channel_flags : Bitfield.S with type Elt.t := System_channel_flag.t

module Feature : sig
  type t =
    | INVITE_SPLASH
    | VIP_REGIONS
    | VANITY_URL
    | VERIFIED
    | PARTNERED
    | COMMUNITY
    | COMMERCE
    | NEWS
    | DISCOVERABLE
    | FEATURABLE
    | ANIMATED_ICON
    | BANNER
    | WELCOME_SCREEN_ENABLED
    | Unknown                of string
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  id: Snowflake.t;
  name: string;
  icon: Image_hash.t option;
  icon_hash: Image_hash.t option;
  splash: Image_hash.t option;
  discovery_splash: Image_hash.t option;
  owner: bool option;
  owner_id: Snowflake.t;
  (* TODO *)
  permissions: Permissions.t option;
  region: string;
  afk_channel_id: Snowflake.t option;
  afk_timeout: Duration.Seconds.t;
  widget_enabled: bool option;
  widget_channel_id: Snowflake.t option;
  verification_level: Verification_level.t;
  default_message_notifications: Default_message_notification_level.t;
  explicit_content_filter: Explicit_content_filter_level.t;
  roles: Role.t list;
  emojis: Emoji.t list;
  features: Feature.t list;
  mfa_level: MFA_level.t;
  application_id: Snowflake.t option;
  system_channel_id: Snowflake.t option;
  system_channel_flags: System_channel_flags.t;
  rules_channel_id: Snowflake.t option;
  joined_at: Timestamp.t option;
  large: bool option;
  unavailable: bool option;
  member_count: int option;
  voice_states: Voice_state.t list option;
  members: User.member list option;
  channels: Channel.t list option;
  presences: Presence_update.t list option;
  max_presences: int option;
  max_members: int option;
  vanity_url_code: Url.t option;
  description: string option;
  banner: Image_hash.t option;
  premium_tier: Premium_tier.t;
  premium_subscription_count: int option;
  preferred_locale: string;
  public_updates_channel_id: Snowflake.t option;
  max_video_channel_users: int option;
  approximate_member_count: int option;
  approximate_presence_count: int option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
