open! Core_kernel
open! Basics

module Partial_integration = struct
  type t = {
    id: Snowflake.t;
    name: string;
    type_: string; [@key "type"]
    account: Integration.Account.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Partial_role = struct
  type t = {
    id: Snowflake.t;
    name: string;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Event = struct
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
  [@@deriving sexp, compare, equal, variants]

  let to_yojson = function
  | GUILD_UPDATE -> `Int 1
  | CHANNEL_CREATE -> `Int 10
  | CHANNEL_UPDATE -> `Int 11
  | CHANNEL_DELETE -> `Int 12
  | CHANNEL_OVERWRITE_CREATE -> `Int 13
  | CHANNEL_OVERWRITE_UPDATE -> `Int 14
  | CHANNEL_OVERWRITE_DELETE -> `Int 15
  | MEMBER_KICK -> `Int 20
  | MEMBER_PRUNE -> `Int 21
  | MEMBER_BAN_ADD -> `Int 22
  | MEMBER_BAN_REMOVE -> `Int 23
  | MEMBER_UPDATE -> `Int 24
  | MEMBER_ROLE_UPDATE -> `Int 25
  | MEMBER_MOVE -> `Int 26
  | MEMBER_DISCONNECT -> `Int 27
  | BOT_ADD -> `Int 28
  | ROLE_CREATE -> `Int 30
  | ROLE_UPDATE -> `Int 31
  | ROLE_DELETE -> `Int 32
  | INVITE_CREATE -> `Int 40
  | INVITE_UPDATE -> `Int 41
  | INVITE_DELETE -> `Int 42
  | WEBHOOK_CREATE -> `Int 50
  | WEBHOOK_UPDATE -> `Int 51
  | WEBHOOK_DELETE -> `Int 52
  | EMOJI_CREATE -> `Int 60
  | EMOJI_UPDATE -> `Int 61
  | EMOJI_DELETE -> `Int 62
  | MESSAGE_DELETE -> `Int 72
  | MESSAGE_BULK_DELETE -> `Int 73
  | MESSAGE_PIN -> `Int 74
  | MESSAGE_UNPIN -> `Int 75
  | INTEGRATION_CREATE -> `Int 80
  | INTEGRATION_UPDATE -> `Int 81
  | INTEGRATION_DELETE -> `Int 82
  | Unknown x -> `Int x

  let of_yojson = function
  | `Int 1 -> Ok GUILD_UPDATE
  | `Int 10 -> Ok CHANNEL_CREATE
  | `Int 11 -> Ok CHANNEL_UPDATE
  | `Int 12 -> Ok CHANNEL_DELETE
  | `Int 13 -> Ok CHANNEL_OVERWRITE_CREATE
  | `Int 14 -> Ok CHANNEL_OVERWRITE_UPDATE
  | `Int 15 -> Ok CHANNEL_OVERWRITE_DELETE
  | `Int 20 -> Ok MEMBER_KICK
  | `Int 21 -> Ok MEMBER_PRUNE
  | `Int 22 -> Ok MEMBER_BAN_ADD
  | `Int 23 -> Ok MEMBER_BAN_REMOVE
  | `Int 24 -> Ok MEMBER_UPDATE
  | `Int 25 -> Ok MEMBER_ROLE_UPDATE
  | `Int 26 -> Ok MEMBER_MOVE
  | `Int 27 -> Ok MEMBER_DISCONNECT
  | `Int 28 -> Ok BOT_ADD
  | `Int 30 -> Ok ROLE_CREATE
  | `Int 31 -> Ok ROLE_UPDATE
  | `Int 32 -> Ok ROLE_DELETE
  | `Int 40 -> Ok INVITE_CREATE
  | `Int 41 -> Ok INVITE_UPDATE
  | `Int 42 -> Ok INVITE_DELETE
  | `Int 50 -> Ok WEBHOOK_CREATE
  | `Int 51 -> Ok WEBHOOK_UPDATE
  | `Int 52 -> Ok WEBHOOK_DELETE
  | `Int 60 -> Ok EMOJI_CREATE
  | `Int 61 -> Ok EMOJI_UPDATE
  | `Int 62 -> Ok EMOJI_DELETE
  | `Int 72 -> Ok MESSAGE_DELETE
  | `Int 73 -> Ok MESSAGE_BULK_DELETE
  | `Int 74 -> Ok MESSAGE_PIN
  | `Int 75 -> Ok MESSAGE_UNPIN
  | `Int 80 -> Ok INTEGRATION_CREATE
  | `Int 81 -> Ok INTEGRATION_UPDATE
  | `Int 82 -> Ok INTEGRATION_DELETE
  | `Int x -> Ok (Unknown x)
  | json -> Shared.invalid json "audit log event"
end

module Change = struct
  module Value = struct
    module Type = struct
      type t =
        | Other   of string
        | Channel of Channel.Type.t
      [@@deriving sexp, compare, equal, variants]

      let to_yojson = function
      | Other x -> `String x
      | Channel x -> Channel.Type.to_yojson x

      let of_yojson = function
      | `Int _ as x -> Channel.Type.of_yojson x |> Result.map ~f:channel
      | `String x -> Ok (Other x)
      | json -> Shared.invalid json "audit log change value type"
    end

    type t =
      | Name                          of string [@name "name"]
      | Icon_hash                     of Image_hash.t [@name "icon_hash"]
      | Splash_hash                   of Image_hash.t [@name "splash_hash"]
      | Owner_id                      of Snowflake.t [@name "owner_id"]
      | Region                        of string [@name "region"]
      | Afk_channel_id                of Snowflake.t [@name "afk_channel_id"]
      | Afk_timeout                   of Duration.Seconds.t [@name "afk_timeout"]
      | Mfa_level                     of Guild.MFA_level.t [@name "mfa_level"]
      | Verification_level            of Guild.Verification_level.t [@name "verification_level"]
      | Explicit_content_filter       of Guild.Explicit_content_filter_level.t
          [@name "explicit_content_filter"]
      | Default_message_notifications of Guild.Default_message_notification_level.t
          [@name "default_message_notifications"]
      | Vanity_url_code               of Url.t [@name "vanity_url_code"]
      | ADD_ROLE                      of Partial_role.t list [@name "$add"]
      | REMOVE_ROLE                   of Partial_role.t list [@name "$remove"]
      | Prune_delete_days             of Duration.Days.t [@name "prune_delete_days"]
      | Widget_enabled                of bool [@name "widget_enabled"]
      | Widget_channel_id             of Snowflake.t [@name "widget_channel_id"]
      | System_channel_id             of Snowflake.t [@name "system_channel_id"]
      | Position                      of int [@name "position"]
      | Topic                         of string [@name "topic"]
      | Bitrate                       of int [@name "bitrate"]
      | Permission_overwrites         of Overwrite.t list [@name "permission_overwrites"]
      | Nsfw                          of bool [@name "nsfw"]
      | Application_id                of Snowflake.t [@name "application_id"]
      | Rate_limit_per_user           of int [@name "rate_limit_per_user"]
      | Permissions                   of Permissions.t [@name "permissions"]
      | Color                         of int [@name "color"]
      | Hoist                         of bool [@name "hoist"]
      | Mentionable                   of bool [@name "mentionable"]
      | Allow                         of Permissions.t [@name "allow"]
      | Deny                          of Permissions.t [@name "deny"]
      | Code                          of string [@name "code"]
      | Channel_id                    of Snowflake.t [@name "channel_id"]
      | Inviter_id                    of Snowflake.t [@name "inviter_id"]
      | Max_uses                      of int [@name "max_uses"]
      | Uses                          of int [@name "uses"]
      | Max_age                       of Duration.Seconds.t [@name "max_age"]
      | Temporary                     of bool [@name "temporary"]
      | Deaf                          of bool [@name "deaf"]
      | Mute                          of bool [@name "mute"]
      | Nick                          of string [@name "nick"]
      | Avatar_hash                   of Image_hash.t [@name "avatar_hash"]
      | Id                            of Snowflake.t [@name "id"]
      | Type                          of Type.t [@name "type"]
      | Enable_emoticons              of bool [@name "enable_emoticons"]
      | Expire_behavior               of Integration.Expire_behavior.t [@name "expire_behavior"]
      | Expire_grace_period           of Duration.Days.t [@name "expire_grace_period"]
      | Unknown                       of (string * Json.t)
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]
  end

  module Unparsed = struct
    type t = {
      old_value: Yojson.Safe.t option; [@default None]
      new_value: Yojson.Safe.t option; [@default None]
      key: string;
    }
    [@@deriving of_yojson { strict = false }]

    let to_yojson { old_value; new_value; key } =
      `Assoc
        [
          "old_value", Option.value ~default:`Null old_value;
          "new_value", Option.value ~default:`Null new_value;
          "key", `String key;
        ]
  end

  type t = {
    old_value: Value.t option; [@default None]
    new_value: Value.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields]

  let of_yojson json =
    let open Result.Let_syntax in
    match%bind Unparsed.of_yojson json with
    | { key; _ } as unparsed ->
      let make v =
        Option.map v ~f:(fun j ->
            match [%of_yojson: Value.t] (`List [ `String key; j ]) with
            | Ok x -> x
            | Error _ -> Unknown (key, j))
      in
      Ok { old_value = make unparsed.old_value; new_value = make unparsed.new_value }

  let to_yojson ({ old_value; new_value } as change) : Yojson.Safe.t =
    let make = function
      | Value.Unknown (key, j) -> `String key, j
      | v -> (
        match Value.to_yojson v with
        | `List [ k; v ] -> k, v
        | _ -> failwithf !"Serialization error for Audit Log Change: %{sexp: t}" change ()
      )
    in
    let ov = Option.map ~f:make old_value in
    let nv = Option.map ~f:make new_value in
    [%to_yojson: Unparsed.t]
      {
        old_value = Option.map ~f:snd ov;
        new_value = Option.map ~f:snd nv;
        key =
          Option.first_some ov nv
          |> Option.bind ~f:(fun (k, _v) -> Yojson.Safe.Util.to_string_option k)
          |> Option.value_exn ~message:"Audit Log Change cannot have both old_value and new_value be None";
      }
end

module Entry = struct
  module Info = struct
    type t = {
      delete_member_days: string option; [@default None]
      members_removed: string option; [@default None]
      channel_id: Snowflake.t option; [@default None]
      message_id: Snowflake.t option; [@default None]
      count: string option; [@default None]
      id: Snowflake.t option; [@default None]
      type_: string option; [@key "type"] [@default None]
      role_name: string option; [@default None]
    }
    [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
  end

  type t = {
    target_id: string option;
    changes: Change.t list option; [@default None]
    user_id: Snowflake.t;
    id: Snowflake.t;
    action_type: Event.t;
    options: Info.t option; [@default None]
    reason: string option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Self = struct
  type t = {
    webhooks: Webhook.t list;
    users: User.t list;
    audit_log_entries: Entry.t list;
    integrations: Integration.t list;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Partial Integration of yojson" =
  let test = Shared.test (module Partial_integration) in
  test
    {|
{
  "id": "33590653072239123",
  "name": "A Name",
  "type": "twitch",
  "account": {
    "name": "twitchusername",
    "id": "1234567"
  }
}
  |};
  [%expect
    {|
      ((id 33590653072239123) (name "A Name") (type_ twitch)
       (account ((id 1234567) (name twitchusername)))) |}]

let%expect_test "Partial Role of yojson" =
  let test = Shared.test (module Partial_role) in
  test {|
{
  "name": "I am a role",
  "id": 584120723283509258
}
  |};
  [%expect {| ((id 584120723283509258) (name "I am a role")) |}]

let%expect_test "Change to yojson" =
  let test c = [%to_yojson: Change.t] c |> Yojson.Safe.pretty_to_string |> print_endline in
  test
    {
      old_value = Some (Change.Value.Verification_level Guild.Verification_level.LOW);
      new_value = Some (Change.Value.Verification_level Guild.Verification_level.HIGH);
    };
  [%expect {|
    { "old_value": 1, "new_value": 3, "key": "verification_level" } |}];
  test
    {
      old_value = Some (Change.Value.Type (Change.Value.Type.Channel Channel.Type.GUILD_VOICE));
      new_value = Some (Change.Value.Type (Change.Value.Type.Other "Something"));
    };
  [%expect {| { "old_value": 2, "new_value": "Something", "key": "type" } |}];
  test { old_value = None; new_value = Some (Change.Value.Name "Hello world") };
  [%expect {| { "old_value": null, "new_value": "Hello world", "key": "name" } |}];
  (match Result.try_with (fun () -> test { old_value = None; new_value = None }) with
  | Error exn -> print_endline (Exn.to_string exn)
  | Ok () -> ());
  [%expect {| "Audit Log Change cannot have both old_value and new_value be None" |}];
  test { old_value = Some (Change.Value.Unknown ("new_key", `Bool true)); new_value = None };
  [%expect {| { "old_value": true, "new_value": null, "key": "new_key" } |}];
  test
    {
      old_value =
        Some
          (Change.Value.ADD_ROLE
             [
               { id = Snowflake.of_string "123"; name = "foo" };
               { id = Snowflake.of_string "456"; name = "bar" };
             ]);
      new_value = None;
    };
  [%expect
    {|
    {
      "old_value": [
        { "id": "123", "name": "foo" },
        { "id": "456", "name": "bar" }
      ],
      "new_value": null,
      "key": "$add"
    } |}]

let%expect_test "Change of yojson" =
  let test = Shared.test (module Change) in
  test {|
{ "old_value":1, "new_value": 3, "key": "verification_level" }
  |};
  [%expect
    {|
         ((old_value ((Verification_level LOW)))
          (new_value ((Verification_level HIGH)))) |}];
  test {|
   { "old_value": 1, "new_value": 3, "key": "VERIFICATION_LEVEL" }
     |};
  [%expect
    {|
       ((old_value ((Unknown (VERIFICATION_LEVEL 1))))
        (new_value ((Unknown (VERIFICATION_LEVEL 3))))) |}];
  {|{ "old_value": 1, "new_value": 3, "key": "VERIFICATION_LEVEL" }|}
  |> Yojson.Safe.from_string
  |> [%of_yojson: Change.t]
  |> Result.ok_or_failwith
  |> [%to_yojson: Change.t]
  |> Yojson.Safe.to_string
  |> print_endline;
  [%expect {| {"old_value":1,"new_value":3,"key":"VERIFICATION_LEVEL"} |}];
  test
    {|
    {
      "key": "$remove",
      "new_value": [
        {
          "name": "Monster",
          "id": "586559029070004236"
        }
      ]
    }
      |};
  [%expect
    {|
    ((old_value ())
     (new_value ((REMOVE_ROLE (((id 586559029070004236) (name Monster))))))) |}]

let%expect_test "Change value type of yojson" =
  let test = Shared.test (module Change.Value.Type) in
  test {|2|};
  [%expect {| (Channel GUILD_VOICE) |}]

let%expect_test "Audit log of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "audit_log_entries": [
    {
      "id": "795305393085612053",
      "user_id": "254065912326520833",
      "target_id": "305693040004300800",
      "action_type": 25,
      "changes": [
        {
          "key": "$remove",
          "new_value": [
            {
              "name": "Monster",
              "id": "586559029070004236"
            }
          ]
        }
      ]
    }
  ],
  "users": [
    {
      "id": "305693040004300800",
      "username": "\ud835\ude73\ud835\ude8a\ud835\ude97\ud835\ude92\ud835\ude8e\ud835\ude95",
      "avatar": "54ac4f6b667f50d41e06add4e2e034a7",
      "discriminator": "1388",
      "public_flags": 0
    }
  ],
  "integrations": [],
  "webhooks": []
}
  |};
  [%expect
    {|
    ((webhooks ())
     (users
      (((id 305693040004300800)
        (username
         "\240\157\153\179\240\157\154\138\240\157\154\151\240\157\154\146\240\157\154\142\240\157\154\149")
        (discriminator 1388) (avatar (54ac4f6b667f50d41e06add4e2e034a7))
        (bot ()) (system ()) (mfa_enabled ()) (locale ()) (verified ())
        (email ()) (flags ()) (premium_type ()) (public_flags (())) (member ()))))
     (audit_log_entries
      (((target_id (305693040004300800))
        (changes
         ((((old_value ())
            (new_value
             ((REMOVE_ROLE (((id 586559029070004236) (name Monster))))))))))
        (user_id 254065912326520833) (id 795305393085612053)
        (action_type MEMBER_ROLE_UPDATE) (options ()) (reason ()))))
     (integrations ())) |}]
