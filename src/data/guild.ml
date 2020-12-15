open! Core_kernel
open! Basics

module Verification_level = struct
  module Self = struct
    type t =
      | NONE
      | LOW
      | MEDIUM
      | HIGH
      | VERY_HIGH
      | Unknown   of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Premium_tier = struct
  module Self = struct
    type t =
      | NONE
      | TIER_1
      | TIER_2
      | TIER_3
      | Unknown of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Default_message_notification_level = struct
  module Self = struct
    type t =
      | ALL_MESSAGES
      | ONLY_MENTIONS
      | Unknown       of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Explicit_content_filter_level = struct
  module Self = struct
    type t =
      | DISABLED
      | MEMBERS_WITHOUT_ROLES
      | ALL_MEMBERS
      | Unknown               of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module MFA_level = struct
  module Self = struct
    type t =
      | NONE
      | Elevated
      | Unknown  of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module System_channel_flag = struct
  type t =
    | SUPPRESS_JOIN_NOTIFICATIONS
    | SUPPRESS_PREMIUM_SUBSCRIPTIONS
  [@@deriving sexp, compare, equal, enum]

  let here = [%here]
end

module System_channel_flags = Bitfield.Make (System_channel_flag)

module Feature = struct
  module Self = struct
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
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_String (Self)
end

module Self = struct
  type t = {
    id: Snowflake.t;
    name: string;
    icon: Image_hash.t option;
    icon_hash: Image_hash.t option; [@default None]
    splash: Image_hash.t option;
    discovery_splash: Image_hash.t option;
    owner: bool option; [@default None]
    owner_id: Snowflake.t;
    permissions: Permissions.t option; [@default None]
    region: string;
    afk_channel_id: Snowflake.t option;
    afk_timeout: Duration.Seconds.t;
    widget_enabled: bool option; [@default None]
    widget_channel_id: Snowflake.t option; [@default None]
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
    joined_at: Timestamp.t option; [@default None]
    large: bool option; [@default None]
    unavailable: bool option; [@default None]
    member_count: int option; [@default None]
    voice_states: Voice_state.t list option; [@default None]
    members: User.member list option; [@default None]
    channels: Channel.t list option; [@default None]
    presences: Presence_update.t list option; [@default None]
    max_presences: int option; [@default None]
    max_members: int option; [@default None]
    vanity_url_code: Url.t option;
    description: string option;
    banner: Image_hash.t option;
    premium_tier: Premium_tier.t;
    premium_subscription_count: int option; [@default None]
    preferred_locale: string;
    public_updates_channel_id: Snowflake.t option;
    max_video_channel_users: int option; [@default None]
    approximate_member_count: int option; [@default None]
    approximate_presence_count: int option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Guild of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "197038439483310086",
  "name": "Discord Testers",
  "icon": "f64c482b807da4f539cff778d174971c",
  "description": "The official place to report Discord Bugs!",
  "splash": null,
  "discovery_splash": null,
  "features": [
    "ANIMATED_ICON",
    "VERIFIED",
    "NEWS",
    "VANITY_URL",
    "DISCOVERABLE",
    "MORE_EMOJI",
    "INVITE_SPLASH",
    "BANNER",
    "COMMUNITY"
  ],
  "emojis": [],
  "banner": "9b6439a7de04f1d26af92f84ac9e1e4a",
  "owner_id": "73193882359173120",
  "application_id": null,
  "region": "us-west",
  "afk_channel_id": null,
  "afk_timeout": 300,
  "system_channel_id": null,
  "widget_enabled": true,
  "widget_channel_id": null,
  "verification_level": 3,
  "roles": [],
  "default_message_notifications": 1,
  "mfa_level": 1,
  "explicit_content_filter": 2,
  "max_presences": 40000,
  "max_members": 250000,
  "vanity_url_code": "discord-testers",
  "premium_tier": 3,
  "premium_subscription_count": 33,
  "system_channel_flags": 0,
  "preferred_locale": "en-US",
  "rules_channel_id": "441688182833020939",
  "public_updates_channel_id": "281283303326089216"
}
  |};
  [%expect
    {|
      ((id 197038439483310086) (name "Discord Testers")
       (icon (f64c482b807da4f539cff778d174971c)) (icon_hash ()) (splash ())
       (discovery_splash ()) (owner ()) (owner_id 73193882359173120)
       (permissions ()) (region us-west) (afk_channel_id ()) (afk_timeout 5m)
       (widget_enabled (true)) (widget_channel_id ()) (verification_level HIGH)
       (default_message_notifications ONLY_MENTIONS)
       (explicit_content_filter ALL_MEMBERS) (roles ()) (emojis ())
       (features
        (ANIMATED_ICON VERIFIED NEWS VANITY_URL DISCOVERABLE (Unknown MORE_EMOJI)
         INVITE_SPLASH BANNER COMMUNITY))
       (mfa_level Elevated) (application_id ()) (system_channel_id ())
       (system_channel_flags ()) (rules_channel_id (441688182833020939))
       (joined_at ()) (large ()) (unavailable ()) (member_count ())
       (voice_states ()) (members ()) (channels ()) (presences ())
       (max_presences (40000)) (max_members (250000))
       (vanity_url_code (discord-testers))
       (description ("The official place to report Discord Bugs!"))
       (banner (9b6439a7de04f1d26af92f84ac9e1e4a)) (premium_tier TIER_3)
       (premium_subscription_count (33)) (preferred_locale en-US)
       (public_updates_channel_id (281283303326089216))
       (max_video_channel_users ()) (approximate_member_count ())
       (approximate_presence_count ())) |}]
