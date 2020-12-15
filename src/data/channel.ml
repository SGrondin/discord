open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | GUILD_TEXT
      | DM
      | GUILD_VOICE
      | GROUP_DM
      | GUILD_CATEGORY
      | GUILD_NEWS
      | GUILD_STORE
      | Unknown        of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    id: Snowflake.t;
    type_: Type.t; [@key "type"]
    guild_id: Snowflake.t option; [@default None]
    position: int option; [@default None]
    permission_overwrites: Overwrite.t list option; [@default None]
    name: string option; [@default None]
    topic: string option; [@default None]
    nsfw: bool option; [@default None]
    last_message_id: Snowflake.t option; [@default None]
    bitrate: int option; [@default None]
    user_limit: int option; [@default None]
    rate_limit_per_user: Duration.Seconds.t option; [@default None]
    recipients: User.t list option; [@default None]
    icon: Image_hash.t option; [@default None]
    owner_id: Snowflake.t option; [@default None]
    application_id: Snowflake.t option; [@default None]
    parent_id: Snowflake.t option; [@default None]
    last_pin_timestamp: Timestamp.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Channel of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "41771983423143937",
  "guild_id": "41771983423143937",
  "name": "general",
  "type": 0,
  "position": 6,
  "permission_overwrites": [],
  "rate_limit_per_user": 2,
  "nsfw": true,
  "topic": "24/7 chat about how to gank Mike #2",
  "last_message_id": "155117677105512449",
  "parent_id": "399942396007890945"
}
  |};
  [%expect
    {|
    ((id 41771983423143937) (type_ GUILD_TEXT) (guild_id (41771983423143937))
     (position (6)) (permission_overwrites (())) (name (general))
     (topic ("24/7 chat about how to gank Mike #2")) (nsfw (true))
     (last_message_id (155117677105512449)) (bitrate ()) (user_limit ())
     (rate_limit_per_user (2s)) (recipients ()) (icon ()) (owner_id ())
     (application_id ()) (parent_id (399942396007890945))
     (last_pin_timestamp ())) |}];
  test
    {|
{
  "id": "41771983423143937",
  "guild_id": "41771983423143937",
  "name": "important-news",
  "type": 5,
  "position": 6,
  "permission_overwrites": [],
  "nsfw": true,
  "topic": "Rumors about Half Life 3",
  "last_message_id": "155117677105512449",
  "parent_id": "399942396007890945"
}
  |};
  [%expect
    {|
    ((id 41771983423143937) (type_ GUILD_NEWS) (guild_id (41771983423143937))
     (position (6)) (permission_overwrites (())) (name (important-news))
     (topic ("Rumors about Half Life 3")) (nsfw (true))
     (last_message_id (155117677105512449)) (bitrate ()) (user_limit ())
     (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
     (application_id ()) (parent_id (399942396007890945))
     (last_pin_timestamp ())) |}];
  test
    {|
{
  "id": "41771983423143937",
  "guild_id": "41771983423143937",
  "name": "important-news",
  "type": 5,
  "position": 6,
  "permission_overwrites": [],
  "nsfw": true,
  "topic": "Rumors about Half Life 3",
  "last_message_id": "155117677105512449",
  "parent_id": "399942396007890945"
}
  |};
  [%expect
    {|
    ((id 41771983423143937) (type_ GUILD_NEWS) (guild_id (41771983423143937))
     (position (6)) (permission_overwrites (())) (name (important-news))
     (topic ("Rumors about Half Life 3")) (nsfw (true))
     (last_message_id (155117677105512449)) (bitrate ()) (user_limit ())
     (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
     (application_id ()) (parent_id (399942396007890945))
     (last_pin_timestamp ())) |}];
  test
    {|
{
  "id": "155101607195836416",
  "guild_id": "41771983423143937",
  "name": "ROCKET CHEESE",
  "type": 2,
  "nsfw": false,
  "position": 5,
  "permission_overwrites": [],
  "bitrate": 64000,
  "user_limit": 0,
  "parent_id": null
}
  |};
  [%expect
    {|
    ((id 155101607195836416) (type_ GUILD_VOICE) (guild_id (41771983423143937))
     (position (5)) (permission_overwrites (())) (name ("ROCKET CHEESE"))
     (topic ()) (nsfw (false)) (last_message_id ()) (bitrate (64000))
     (user_limit (0)) (rate_limit_per_user ()) (recipients ()) (icon ())
     (owner_id ()) (application_id ()) (parent_id ()) (last_pin_timestamp ())) |}];
  test
    {|
{
  "last_message_id": "3343820033257021450",
  "type": 1,
  "id": "319674150115610528",
  "recipients": [
    {
      "username": "test",
      "discriminator": "9999",
      "id": "82198898841029460",
      "avatar": "33ecab261d4681afa4d85a04691c4a01"
    }
  ]
}
  |};
  [%expect
    {|
    ((id 319674150115610528) (type_ DM) (guild_id ()) (position ())
     (permission_overwrites ()) (name ()) (topic ()) (nsfw ())
     (last_message_id (3343820033257021450)) (bitrate ()) (user_limit ())
     (rate_limit_per_user ())
     (recipients
      ((((id 82198898841029460) (username test) (discriminator 9999)
         (avatar (33ecab261d4681afa4d85a04691c4a01)) (bot ()) (system ())
         (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
         (premium_type ()) (public_flags ()) (member ())))))
     (icon ()) (owner_id ()) (application_id ()) (parent_id ())
     (last_pin_timestamp ())) |}];
  test
    {|
{
  "name": "Some test channel",
  "icon": null,
  "recipients": [
    {
      "username": "test",
      "discriminator": "9999",
      "id": "82198898841029460",
      "avatar": "33ecab261d4681afa4d85a04691c4a01"
    },
    {
      "username": "test2",
      "discriminator": "9999",
      "id": "82198810841029460",
      "avatar": "33ecab261d4681afa4d85a10691c4a01"
    }
  ],
  "last_message_id": "3343820033257021450",
  "type": 3,
  "id": "319674150115710528",
  "owner_id": "82198810841029460"
}
  |};
  [%expect
    {|
    ((id 319674150115710528) (type_ GROUP_DM) (guild_id ()) (position ())
     (permission_overwrites ()) (name ("Some test channel")) (topic ()) (nsfw ())
     (last_message_id (3343820033257021450)) (bitrate ()) (user_limit ())
     (rate_limit_per_user ())
     (recipients
      ((((id 82198898841029460) (username test) (discriminator 9999)
         (avatar (33ecab261d4681afa4d85a04691c4a01)) (bot ()) (system ())
         (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
         (premium_type ()) (public_flags ()) (member ()))
        ((id 82198810841029460) (username test2) (discriminator 9999)
         (avatar (33ecab261d4681afa4d85a10691c4a01)) (bot ()) (system ())
         (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
         (premium_type ()) (public_flags ()) (member ())))))
     (icon ()) (owner_id (82198810841029460)) (application_id ()) (parent_id ())
     (last_pin_timestamp ())) |}];
  test
    {|
{
  "permission_overwrites": [],
  "name": "Test",
  "parent_id": null,
  "nsfw": false,
  "position": 0,
  "guild_id": "290926798629997250",
  "type": 4,
  "id": "399942396007890945"
}
  |};
  [%expect
    {|
    ((id 399942396007890945) (type_ GUILD_CATEGORY)
     (guild_id (290926798629997250)) (position (0)) (permission_overwrites (()))
     (name (Test)) (topic ()) (nsfw (false)) (last_message_id ()) (bitrate ())
     (user_limit ()) (rate_limit_per_user ()) (recipients ()) (icon ())
     (owner_id ()) (application_id ()) (parent_id ()) (last_pin_timestamp ())) |}];
  test
    {|
{
  "id": "41771983423143937",
  "guild_id": "41771983423143937",
  "name": "buy dota-2",
  "type": 6,
  "position": 0,
  "permission_overwrites": [],
  "nsfw": false,
  "parent_id": null
}
  |};
  [%expect
    {|
    ((id 41771983423143937) (type_ GUILD_STORE) (guild_id (41771983423143937))
     (position (0)) (permission_overwrites (())) (name ("buy dota-2")) (topic ())
     (nsfw (false)) (last_message_id ()) (bitrate ()) (user_limit ())
     (rate_limit_per_user ()) (recipients ()) (icon ()) (owner_id ())
     (application_id ()) (parent_id ()) (last_pin_timestamp ())) |}]
