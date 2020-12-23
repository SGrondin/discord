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
       (approximate_presence_count ())) |}];
  test
    "{\"description\":null,\"lazy\":true,\"discovery_splash\":null,\"explicit_content_filter\":0,\"icon\":\"37b2df6f79f44c0b95f974e6689156b0\",\"system_channel_id\":\"616658324351352846\",\"guild_hashes\":{\"version\":1,\"roles\":{\"omitted\":false,\"hash\":\"1+tE2MhRYT8\"},\"metadata\":{\"omitted\":false,\"hash\":\"asUQBdct8eM\"},\"channels\":{\"omitted\":false,\"hash\":\"H5Z/t2u7dxA\"}},\"members\":[{\"user\":{\"username\":\"LokiSooner\",\"id\":\"142634064451600384\",\"discriminator\":\"5135\",\"avatar\":\"737b91e06e38f326c044e5e96bfd4f6c\"},\"roles\":[],\"nick\":\"Matt\",\"mute\":false,\"joined_at\":\"2019-08-29T15:48:50.005000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"Dhsu\",\"id\":\"197732912110632961\",\"discriminator\":\"1523\",\"avatar\":null},\"roles\":[],\"mute\":false,\"joined_at\":\"2019-08-29T17:44:28.316000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"Sidekick\",\"public_flags\":65536,\"id\":\"209048672195969025\",\"discriminator\":\"6198\",\"bot\":true,\"avatar\":\"93b788e6f93c968f0fe25ec4d8c56aa8\"},\"roles\":[\"690748059885502505\"],\"mute\":false,\"joined_at\":\"2020-03-21T02:17:39.456000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"normanpride\",\"id\":\"221972732596846592\",\"discriminator\":\"9822\",\"avatar\":null},\"roles\":[],\"nick\":\"Thomas\",\"mute\":false,\"joined_at\":\"2019-08-29T15:40:01.543000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"Eloinus\",\"id\":\"364954358473031680\",\"discriminator\":\"6112\",\"avatar\":null},\"roles\":[],\"mute\":false,\"joined_at\":\"2019-08-30T17:49:30.690000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"epiccletus\",\"id\":\"559089584764354667\",\"discriminator\":\"2500\",\"avatar\":null},\"roles\":[],\"mute\":false,\"joined_at\":\"2019-09-01T19:46:34.586000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"xeerohour\",\"id\":\"616721445933809727\",\"discriminator\":\"5015\",\"avatar\":\"4c0152e658e84be5e20bf88c48e45d2a\"},\"roles\":[],\"mute\":false,\"joined_at\":\"2019-08-29T19:51:57.357000+00:00\",\"hoisted_role\":null,\"deaf\":false},{\"user\":{\"username\":\"SparkleJoin\",\"id\":\"791358895678423040\",\"discriminator\":\"0070\",\"bot\":true,\"avatar\":null},\"roles\":[\"791361098606444574\"],\"premium_since\":null,\"pending\":false,\"nick\":null,\"mute\":false,\"joined_at\":\"2020-12-23T17:44:20.459263+00:00\",\"is_pending\":false,\"hoisted_role\":null,\"deaf\":false}],\"premium_tier\":0,\"afk_channel_id\":null,\"max_video_channel_users\":25,\"voice_states\":[],\"system_channel_flags\":0,\"roles\":[{\"position\":0,\"permissions\":\"104324673\",\"name\":\"@everyone\",\"mentionable\":false,\"managed\":false,\"id\":\"616658324351352842\",\"hoist\":false,\"color\":0},{\"tags\":{\"premium_subscriber\":null},\"position\":3,\"permissions\":\"104324673\",\"name\":\"Server \
     Booster\",\"mentionable\":false,\"managed\":true,\"id\":\"649766035054002188\",\"hoist\":false,\"color\":16023551},{\"position\":2,\"permissions\":\"512064\",\"name\":\"hush\",\"mentionable\":false,\"managed\":false,\"id\":\"690748059885502505\",\"hoist\":false,\"color\":0},{\"position\":1,\"permissions\":\"104324673\",\"name\":\"bot \
     test\",\"mentionable\":false,\"managed\":false,\"id\":\"791361098606444574\",\"hoist\":false,\"color\":3066993}],\"emojis\":[{\"roles\":[],\"require_colons\":true,\"name\":\"conga_parrot\",\"managed\":false,\"id\":\"705819616026427413\",\"available\":true,\"animated\":true},{\"roles\":[],\"require_colons\":true,\"name\":\"coffin_dance\",\"managed\":false,\"id\":\"705820475460419664\",\"available\":true,\"animated\":true},{\"roles\":[],\"require_colons\":true,\"name\":\"cryingjordan\",\"managed\":false,\"id\":\"705822497320337521\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"dickbutt\",\"managed\":false,\"id\":\"705822497504755754\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"cubs\",\"managed\":false,\"id\":\"705822497505017887\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"fry\",\"managed\":false,\"id\":\"705822497656012860\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"take_my_money\",\"managed\":false,\"id\":\"705822497706082374\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"thunder\",\"managed\":false,\"id\":\"705822497706213437\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"facepalm\",\"managed\":false,\"id\":\"705822497768996894\",\"available\":true,\"animated\":false},{\"roles\":[],\"require_colons\":true,\"name\":\"success\",\"managed\":false,\"id\":\"705822754926100551\",\"available\":true,\"animated\":false}],\"preferred_locale\":\"en-US\",\"name\":\"Tulsa \
     Guys\",\"joined_at\":\"2020-12-23T17:44:20.459263+00:00\",\"vanity_url_code\":null,\"rules_channel_id\":null,\"unavailable\":false,\"afk_timeout\":300,\"verification_level\":0,\"banner\":null,\"premium_subscription_count\":0,\"application_id\":null,\"features\":[],\"default_message_notifications\":0,\"public_updates_channel_id\":null,\"owner_id\":\"221972732596846592\",\"large\":false,\"channels\":[{\"type\":4,\"position\":0,\"permission_overwrites\":[],\"name\":\"Text \
     Channels\",\"id\":\"616658324351352844\"},{\"type\":0,\"topic\":null,\"rate_limit_per_user\":0,\"position\":0,\"permission_overwrites\":[{\"type\":1,\"id\":\"209048672195969025\",\"deny\":\"3072\",\"allow\":\"0\"},{\"type\":0,\"id\":\"690748059885502505\",\"deny\":\"3072\",\"allow\":\"0\"}],\"parent_id\":\"616658324351352844\",\"name\":\"general\",\"last_pin_timestamp\":\"2019-08-29T23:14:49.147000+00:00\",\"last_message_id\":\"791365371445510145\",\"id\":\"616658324351352846\"},{\"type\":4,\"position\":0,\"permission_overwrites\":[],\"name\":\"Voice \
     Channels\",\"id\":\"616658324351352848\"},{\"user_limit\":0,\"type\":2,\"position\":0,\"permission_overwrites\":[],\"parent_id\":\"616658324351352848\",\"name\":\"General\",\"id\":\"616658324351352850\",\"bitrate\":64000},{\"type\":0,\"topic\":null,\"rate_limit_per_user\":0,\"position\":1,\"permission_overwrites\":[{\"type\":0,\"id\":\"690748059885502505\",\"deny\":\"3072\",\"allow\":\"0\"}],\"parent_id\":\"616658324351352844\",\"name\":\"expanse\",\"last_message_id\":\"780912633338527775\",\"id\":\"624642843318943754\"},{\"type\":0,\"topic\":null,\"rate_limit_per_user\":0,\"position\":2,\"permission_overwrites\":[{\"type\":0,\"id\":\"616658324351352842\",\"deny\":\"0\",\"allow\":\"0\"},{\"type\":0,\"id\":\"690748059885502505\",\"deny\":\"3072\",\"allow\":\"0\"}],\"parent_id\":\"616658324351352844\",\"name\":\"tainted-grail\",\"last_message_id\":\"785630253740457995\",\"id\":\"651883842986180620\"},{\"type\":0,\"topic\":null,\"rate_limit_per_user\":0,\"position\":3,\"permission_overwrites\":[{\"type\":1,\"id\":\"209048672195969025\",\"deny\":\"0\",\"allow\":\"3072\"}],\"parent_id\":\"616658324351352844\",\"name\":\"roll-it\",\"last_pin_timestamp\":\"2020-03-21T02:20:39.984000+00:00\",\"last_message_id\":\"690999462507708477\",\"id\":\"690746389600272434\"},{\"type\":0,\"topic\":null,\"rate_limit_per_user\":0,\"position\":4,\"permission_overwrites\":[{\"type\":0,\"id\":\"616658324351352842\",\"deny\":\"1024\",\"allow\":\"0\"},{\"type\":0,\"id\":\"791361098606444574\",\"deny\":\"0\",\"allow\":\"1024\"}],\"parent_id\":\"616658324351352844\",\"nsfw\":false,\"name\":\"bot-channel\",\"last_message_id\":null,\"id\":\"791361427729809448\"}],\"member_count\":8,\"splash\":null,\"max_members\":100000,\"threads\":[],\"presences\":[{\"user\":{\"id\":\"209048672195969025\"},\"status\":\"online\",\"client_status\":{\"web\":\"online\"},\"activities\":[]},{\"user\":{\"id\":\"221972732596846592\"},\"status\":\"online\",\"client_status\":{\"desktop\":\"online\"},\"activities\":[]},{\"user\":{\"id\":\"364954358473031680\"},\"status\":\"idle\",\"client_status\":{\"desktop\":\"idle\"},\"activities\":[]},{\"user\":{\"id\":\"616721445933809727\"},\"status\":\"online\",\"client_status\":{\"desktop\":\"online\"},\"activities\":[]},{\"user\":{\"id\":\"791358895678423040\"},\"status\":\"online\",\"client_status\":{\"web\":\"online\"},\"activities\":[{\"type\":2,\"name\":\"People \
     Beep \
     Boop\",\"id\":\"ec0b28a579ecb4bd\",\"created_at\":1608747249139}]}],\"id\":\"616658324351352842\",\"region\":\"us-south\",\"mfa_level\":0}";
  [%expect {|
    ((id 616658324351352842) (name "Tulsa Guys")
     (icon (37b2df6f79f44c0b95f974e6689156b0)) (icon_hash ()) (splash ())
     (discovery_splash ()) (owner ()) (owner_id 221972732596846592)
     (permissions ()) (region us-south) (afk_channel_id ()) (afk_timeout 5m)
     (widget_enabled ()) (widget_channel_id ()) (verification_level NONE)
     (default_message_notifications ALL_MESSAGES)
     (explicit_content_filter DISABLED)
     (roles
      (((id 616658324351352842) (name @everyone) (color 0) (hoist false)
        (position 0) (permissions 104324673) (managed false) (mentionable false))
       ((id 649766035054002188) (name "Server Booster") (color 16023551)
        (hoist false) (position 3) (permissions 104324673) (managed true)
        (mentionable false))
       ((id 690748059885502505) (name hush) (color 0) (hoist false) (position 2)
        (permissions 512064) (managed false) (mentionable false))
       ((id 791361098606444574) (name "bot test") (color 3066993) (hoist false)
        (position 1) (permissions 104324673) (managed false) (mentionable false))))
     (emojis
      (((id (705819616026427413)) (name (conga_parrot)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (true))
        (available (true)))
       ((id (705820475460419664)) (name (coffin_dance)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (true))
        (available (true)))
       ((id (705822497320337521)) (name (cryingjordan)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497504755754)) (name (dickbutt)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497505017887)) (name (cubs)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497656012860)) (name (fry)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497706082374)) (name (take_my_money)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497706213437)) (name (thunder)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822497768996894)) (name (facepalm)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))
       ((id (705822754926100551)) (name (success)) (roles (())) (user ())
        (require_colons (true)) (managed (false)) (animated (false))
        (available (true)))))
     (features ()) (mfa_level NONE) (application_id ())
     (system_channel_id (616658324351352846)) (system_channel_flags ())
     (rules_channel_id ()) (joined_at ("2020-12-23 17:44:20.459263Z"))
     (large (false)) (unavailable (false)) (member_count (8)) (voice_states (()))
     (members
      ((((user
          (((id 142634064451600384) (username LokiSooner) (discriminator 5135)
            (avatar (737b91e06e38f326c044e5e96bfd4f6c)) (bot ()) (system ())
            (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
            (premium_type ()) (public_flags ()) (member ()))))
         (nick (Matt)) (roles ()) (joined_at "2019-08-29 15:48:50.005000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 197732912110632961) (username Dhsu) (discriminator 1523)
            (avatar ()) (bot ()) (system ()) (mfa_enabled ()) (locale ())
            (verified ()) (email ()) (flags ()) (premium_type ())
            (public_flags ()) (member ()))))
         (nick ()) (roles ()) (joined_at "2019-08-29 17:44:28.316000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 209048672195969025) (username Sidekick) (discriminator 6198)
            (avatar (93b788e6f93c968f0fe25ec4d8c56aa8)) (bot (true)) (system ())
            (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
            (premium_type ()) (public_flags ((Verified_bot))) (member ()))))
         (nick ()) (roles (690748059885502505))
         (joined_at "2020-03-21 02:17:39.456000Z") (premium_since ())
         (deaf false) (mute false))
        ((user
          (((id 221972732596846592) (username normanpride) (discriminator 9822)
            (avatar ()) (bot ()) (system ()) (mfa_enabled ()) (locale ())
            (verified ()) (email ()) (flags ()) (premium_type ())
            (public_flags ()) (member ()))))
         (nick (Thomas)) (roles ()) (joined_at "2019-08-29 15:40:01.543000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 364954358473031680) (username Eloinus) (discriminator 6112)
            (avatar ()) (bot ()) (system ()) (mfa_enabled ()) (locale ())
            (verified ()) (email ()) (flags ()) (premium_type ())
            (public_flags ()) (member ()))))
         (nick ()) (roles ()) (joined_at "2019-08-30 17:49:30.690000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 559089584764354667) (username epiccletus) (discriminator 2500)
            (avatar ()) (bot ()) (system ()) (mfa_enabled ()) (locale ())
            (verified ()) (email ()) (flags ()) (premium_type ())
            (public_flags ()) (member ()))))
         (nick ()) (roles ()) (joined_at "2019-09-01 19:46:34.586000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 616721445933809727) (username xeerohour) (discriminator 5015)
            (avatar (4c0152e658e84be5e20bf88c48e45d2a)) (bot ()) (system ())
            (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
            (premium_type ()) (public_flags ()) (member ()))))
         (nick ()) (roles ()) (joined_at "2019-08-29 19:51:57.357000Z")
         (premium_since ()) (deaf false) (mute false))
        ((user
          (((id 791358895678423040) (username SparkleJoin) (discriminator 0070)
            (avatar ()) (bot (true)) (system ()) (mfa_enabled ()) (locale ())
            (verified ()) (email ()) (flags ()) (premium_type ())
            (public_flags ()) (member ()))))
         (nick ()) (roles (791361098606444574))
         (joined_at "2020-12-23 17:44:20.459263Z") (premium_since ())
         (deaf false) (mute false)))))
     (channels
      ((((id 616658324351352844) (type_ GUILD_CATEGORY) (guild_id ())
         (position (0)) (permission_overwrites (())) (name ("Text Channels"))
         (topic ()) (nsfw ()) (last_message_id ()) (bitrate ()) (user_limit ())
         (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id ()) (last_pin_timestamp ()))
        ((id 616658324351352846) (type_ GUILD_TEXT) (guild_id ()) (position (0))
         (permission_overwrites
          ((((id 209048672195969025) (type_ Member) (allow 0) (deny 3072))
            ((id 690748059885502505) (type_ Role) (allow 0) (deny 3072)))))
         (name (general)) (topic ()) (nsfw ())
         (last_message_id (791365371445510145)) (bitrate ()) (user_limit ())
         (rate_limit_per_user (0s)) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id (616658324351352844))
         (last_pin_timestamp ("2019-08-29 23:14:49.147000Z")))
        ((id 616658324351352848) (type_ GUILD_CATEGORY) (guild_id ())
         (position (0)) (permission_overwrites (())) (name ("Voice Channels"))
         (topic ()) (nsfw ()) (last_message_id ()) (bitrate ()) (user_limit ())
         (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id ()) (last_pin_timestamp ()))
        ((id 616658324351352850) (type_ GUILD_VOICE) (guild_id ()) (position (0))
         (permission_overwrites (())) (name (General)) (topic ()) (nsfw ())
         (last_message_id ()) (bitrate (64000)) (user_limit (0))
         (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id (616658324351352848))
         (last_pin_timestamp ()))
        ((id 624642843318943754) (type_ GUILD_TEXT) (guild_id ()) (position (1))
         (permission_overwrites
          ((((id 690748059885502505) (type_ Role) (allow 0) (deny 3072)))))
         (name (expanse)) (topic ()) (nsfw ())
         (last_message_id (780912633338527775)) (bitrate ()) (user_limit ())
         (rate_limit_per_user (0s)) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id (616658324351352844))
         (last_pin_timestamp ()))
        ((id 651883842986180620) (type_ GUILD_TEXT) (guild_id ()) (position (2))
         (permission_overwrites
          ((((id 616658324351352842) (type_ Role) (allow 0) (deny 0))
            ((id 690748059885502505) (type_ Role) (allow 0) (deny 3072)))))
         (name (tainted-grail)) (topic ()) (nsfw ())
         (last_message_id (785630253740457995)) (bitrate ()) (user_limit ())
         (rate_limit_per_user (0s)) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id (616658324351352844))
         (last_pin_timestamp ()))
        ((id 690746389600272434) (type_ GUILD_TEXT) (guild_id ()) (position (3))
         (permission_overwrites
          ((((id 209048672195969025) (type_ Member) (allow 3072) (deny 0)))))
         (name (roll-it)) (topic ()) (nsfw ())
         (last_message_id (690999462507708477)) (bitrate ()) (user_limit ())
         (rate_limit_per_user (0s)) (recipients ()) (icon ()) (owner_id ())
         (application_id ()) (parent_id (616658324351352844))
         (last_pin_timestamp ("2020-03-21 02:20:39.984000Z")))
        ((id 791361427729809448) (type_ GUILD_TEXT) (guild_id ()) (position (4))
         (permission_overwrites
          ((((id 616658324351352842) (type_ Role) (allow 0) (deny 1024))
            ((id 791361098606444574) (type_ Role) (allow 1024) (deny 0)))))
         (name (bot-channel)) (topic ()) (nsfw (false)) (last_message_id ())
         (bitrate ()) (user_limit ()) (rate_limit_per_user (0s)) (recipients ())
         (icon ()) (owner_id ()) (application_id ())
         (parent_id (616658324351352844)) (last_pin_timestamp ())))))
     (presences
      ((((user_id 209048672195969025) (guild_id ()) (status Online)
         (activities ())
         (client_status ((desktop ()) (mobile ()) (web (Online)))))
        ((user_id 221972732596846592) (guild_id ()) (status Online)
         (activities ())
         (client_status ((desktop (Online)) (mobile ()) (web ()))))
        ((user_id 364954358473031680) (guild_id ()) (status Idle) (activities ())
         (client_status ((desktop (Idle)) (mobile ()) (web ()))))
        ((user_id 616721445933809727) (guild_id ()) (status Online)
         (activities ())
         (client_status ((desktop (Online)) (mobile ()) (web ()))))
        ((user_id 791358895678423040) (guild_id ()) (status Online)
         (activities
          (((id (ec0b28a579ecb4bd)) (name "People Beep Boop") (type_ Listening)
            (url ()) (created_at 1608747249139) (timestamps ()) (sync_id ())
            (platform ()) (application_id ()) (details ()) (state ()) (emoji ())
            (session_id ()) (party ()) (assets ()) (secrets ()) (instance ())
            (flags ()))))
         (client_status ((desktop ()) (mobile ()) (web (Online))))))))
     (max_presences ()) (max_members (100000)) (vanity_url_code ())
     (description ()) (banner ()) (premium_tier NONE)
     (premium_subscription_count (0)) (preferred_locale en-US)
     (public_updates_channel_id ()) (max_video_channel_users (25))
     (approximate_member_count ()) (approximate_presence_count ())) |}]
