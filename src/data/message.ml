open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
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
      | Unknown                                of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Activity = struct
  module Type = struct
    module Self = struct
      type t =
        | Deprecated_type_1
        | JOIN
        | SPECTATE
        | LISTEN
        | Deprecated_type_2
        | JOIN_REQUEST
        | Unknown           of int
      [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

      let here = [%here]
    end

    include Self
    include Enum.Make_Int (Self)
  end

  type t = {
    type_: Type.t; [@key "type"]
    party_id: string option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Application = struct
  type t = {
    id: Snowflake.t;
    cover_image: Image_hash.t option; [@default None]
    description: string;
    icon: Image_hash.t option;
    name: string;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Reference = struct
  type t = {
    message_id: Snowflake.t option; [@default None]
    channel_id: Snowflake.t option; [@default None]
    guild_id: Snowflake.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Flag = struct
  type t =
    | CROSSPOSTED
    | IS_CROSSPOST
    | SUPPRESS_EMBEDS
    | SOURCE_MESSAGE_DELETED
    | URGENT
  [@@deriving sexp, compare, equal, enum]

  let here = [%here]
end

module Flags = Bitfield.Make (Flag)

module Sticker = struct
  module Format = struct
    module Self = struct
      type t =
        | Deprecated_type_1
        | PNG
        | APNG
        | LOTTIE
        | Unknown           of int
      [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

      let here = [%here]
    end

    include Self
    include Enum.Make_Int (Self)
  end

  type t = {
    id: Snowflake.t;
    pack_id: Snowflake.t;
    name: string;
    description: string;
    tags: string option; [@default None]
    asset: Image_hash.t;
    preview_asset: Image_hash.t option;
    format_type: Format.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Channel_mention = struct
  type t = {
    id: Snowflake.t;
    guild_id: Snowflake.t;
    type_: Channel.Type.t; [@key "type"]
    name: string;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Self = struct
  type t = {
    id: Snowflake.t;
    channel_id: Snowflake.t;
    guild_id: Snowflake.t option; [@default None]
    author: User.t;
    member: User.member option; [@default None]
    content: string;
    timestamp: Timestamp.t;
    edited_timestamp: Timestamp.t option;
    tts: bool;
    mention_everyone: bool;
    mentions: User.t list;
    mention_roles: Snowflake.t list;
    mention_channels: Channel_mention.t list option; [@default None]
    attachments: Attachment.t list;
    embeds: Embed.t list;
    reactions: Reaction.t list option; [@default None]
    nonce: Nonce.t option; [@default None]
    pinned: bool;
    webhook_id: Snowflake.t option; [@default None]
    type_: Type.t; [@key "type"]
    activity: Activity.t option; [@default None]
    application: Application.t option; [@default None]
    message_reference: Reference.t option; [@default None]
    flags: Flags.t option; [@default None]
    stickers: Sticker.t list option; [@default None]
    referenced_message: t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Message of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "reactions": [
    {
      "count": 1,
      "me": false,
      "emoji": {
        "id": null,
        "name": "🔥"
      }
    }
  ],
  "attachments": [],
  "tts": false,
  "embeds": [],
  "timestamp": "2017-07-11T17:27:07.299000+00:00",
  "mention_everyone": false,
  "id": "334385199974967042",
  "pinned": false,
  "edited_timestamp": null,
  "author": {
    "username": "Mason",
    "discriminator": "9999",
    "id": "53908099506183680",
    "avatar": "a_bab14f271d565501444b2ca3be944b25"
  },
  "mention_roles": [],
  "content": "Supa Hot",
  "channel_id": "290926798999357250",
  "mentions": [],
  "type": 19
}
  |};
  [%expect
    {|
      ((id 334385199974967042) (channel_id 290926798999357250) (guild_id ())
       (author
        ((id 53908099506183680) (username Mason) (discriminator 9999)
         (avatar (a_bab14f271d565501444b2ca3be944b25)) (bot ()) (system ())
         (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
         (premium_type ()) (public_flags ()) (member ())))
       (member ()) (content "Supa Hot") (timestamp "2017-07-11 17:27:07.299000Z")
       (edited_timestamp ()) (tts false) (mention_everyone false) (mentions ())
       (mention_roles ()) (mention_channels ()) (attachments ()) (embeds ())
       (reactions
        ((((count 1) (me false)
           (emoji
            ((id ()) (name ("\240\159\148\165")) (roles ()) (user ())
             (require_colons ()) (managed ()) (animated ()) (available ())))))))
       (nonce ()) (pinned false) (webhook_id ()) (type_ REPLY) (activity ())
       (application ()) (message_reference ()) (flags ()) (stickers ())
       (referenced_message ())) |}];
  test
    {|
{
  "reactions": [
    {
      "count": 1,
      "me": false,
      "emoji": {
        "id": null,
        "name": "🔥"
      }
    }
  ],
  "attachments": [],
  "tts": false,
  "embeds": [],
  "timestamp": "2017-07-11T17:27:07.299000+00:00",
  "mention_everyone": false,
  "id": "334385199974967042",
  "pinned": false,
  "edited_timestamp": null,
  "author": {
    "username": "Mason",
    "discriminator": "9999",
    "id": "53908099506183680",
    "avatar": "a_bab14f271d565501444b2ca3be944b25"
  },
  "mention_roles": [],
  "mention_channels": [
    {
      "id": "278325129692446722",
      "guild_id": "278325129692446720",
      "name": "big-news",
      "type": 5
    }
  ],
  "content": "Big news! In this <#278325129692446722> channel!",
  "channel_id": "290926798999357250",
  "mentions": [],
  "type": 0,
  "flags": 2,
  "message_reference": {
    "channel_id": "278325129692446722",
    "guild_id": "278325129692446720",
    "message_id": "306588351130107906"
  }
}
  |};
  [%expect
    {|
      ((id 334385199974967042) (channel_id 290926798999357250) (guild_id ())
       (author
        ((id 53908099506183680) (username Mason) (discriminator 9999)
         (avatar (a_bab14f271d565501444b2ca3be944b25)) (bot ()) (system ())
         (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
         (premium_type ()) (public_flags ()) (member ())))
       (member ()) (content "Big news! In this <#278325129692446722> channel!")
       (timestamp "2017-07-11 17:27:07.299000Z") (edited_timestamp ()) (tts false)
       (mention_everyone false) (mentions ()) (mention_roles ())
       (mention_channels
        ((((id 278325129692446722) (guild_id 278325129692446720) (type_ GUILD_NEWS)
           (name big-news)))))
       (attachments ()) (embeds ())
       (reactions
        ((((count 1) (me false)
           (emoji
            ((id ()) (name ("\240\159\148\165")) (roles ()) (user ())
             (require_colons ()) (managed ()) (animated ()) (available ())))))))
       (nonce ()) (pinned false) (webhook_id ()) (type_ DEFAULT) (activity ())
       (application ())
       (message_reference
        (((message_id (306588351130107906)) (channel_id (278325129692446722))
          (guild_id (278325129692446720)))))
       (flags ((IS_CROSSPOST))) (stickers ()) (referenced_message ())) |}]