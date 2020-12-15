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
    id: Int64.t;
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
      | ADD_ROLE                      of Partial_role.t list [@name "$add"]
      | REMOVE_ROLE                   of Partial_role.t list [@name "$remove"]
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
      | Unknown                       of Json.t
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let keys =
      List.fold Variants.descriptions ~init:String.Set.empty ~f:(fun acc (k, _v) ->
          String.Set.add acc (String.lowercase k))
  end

  module Unparsed = struct
    type t = {
      old_value: Yojson.Safe.t;
      new_value: Yojson.Safe.t;
      key: string;
    }
    [@@deriving yojson { strict = false }]
  end

  type t = {
    old_value: Value.t option; [@default None]
    new_value: Value.t option; [@default None]
    key: string;
  }
  [@@deriving sexp, compare, equal, fields]

  let of_yojson json =
    let open Result.Let_syntax in
    match%bind Unparsed.of_yojson json with
    | { key; old_value; new_value } when not @@ String.Set.mem Value.keys key ->
      let make = function
        | `Null -> None
        | v -> Some (Value.Unknown v)
      in
      Ok { old_value = make old_value; new_value = make new_value; key }
    | { key = k; old_value; new_value } ->
      let key = String.capitalize k in
      let make k v : Yojson.Safe.t = `List [ `String k; v ] in
      let ov = [%of_yojson: Value.t option] (make key old_value) in
      let nv = [%of_yojson: Value.t option] (make key new_value) in
      let%map old_value = ov
      and new_value = nv in
      Fields.create ~old_value ~new_value ~key

  let to_yojson { old_value; new_value; key } =
    let make v =
      Option.value_map v ~default:`Null ~f:(fun x -> Value.to_yojson x |> Yojson.Safe.Util.index 1)
    in
    [%to_yojson: Unparsed.t]
      {
        old_value = make old_value;
        new_value = make new_value;
        key =
          Option.first_some old_value new_value
          |> Option.value_map ~default:key ~f:(function
               | Unknown _v -> key
               | x -> Value.Variants.to_name x |> String.lowercase);
      }
end

module Entry = struct
  module Options = struct
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
    options: Options.t option; [@default None]
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
      key = "verification_level";
    };
  [%expect {|
    { "old_value": 1, "new_value": 3, "key": "verification_level" } |}];
  test
    {
      old_value = Some (Change.Value.Type (Change.Value.Type.Channel Channel.Type.GUILD_VOICE));
      new_value = Some (Change.Value.Type (Change.Value.Type.Other "Something"));
      key = "type";
    };
  [%expect {| { "old_value": 2, "new_value": "Something", "key": "type" } |}];
  test { old_value = None; new_value = Some (Change.Value.Name "Hello world"); key = "name" };
  [%expect {| { "old_value": null, "new_value": "Hello world", "key": "name" } |}];
  test { old_value = None; new_value = None; key = "type" };
  [%expect {| { "old_value": null, "new_value": null, "key": "type" } |}];
  test { old_value = Some (Change.Value.Unknown (`Bool true)); new_value = None; key = "new_key" };
  [%expect {| { "old_value": true, "new_value": null, "key": "new_key" } |}]

let%expect_test "Change of yojson" =
  let test = Shared.test (module Change) in
  test {|
{ "old_value": 1, "new_value": 3, "key": "verification_level" }
  |};
  [%expect
    {|
      ((old_value ((Verification_level LOW)))
       (new_value ((Verification_level HIGH))) (key Verification_level)) |}];
  test {|
{ "old_value": 1, "new_value": 3, "key": "VERIFICATION_LEVEL" }
  |};
  [%expect {|
    ((old_value ((Unknown 1))) (new_value ((Unknown 3)))
     (key VERIFICATION_LEVEL)) |}];
  {|{ "old_value": 1, "new_value": 3, "key": "VERIFICATION_LEVEL" }|}
  |> Yojson.Safe.from_string
  |> [%of_yojson: Change.t]
  |> Result.ok_or_failwith
  |> [%to_yojson: Change.t]
  |> Yojson.Safe.to_string
  |> print_endline;
  [%expect {| {"old_value":1,"new_value":3,"key":"VERIFICATION_LEVEL"} |}]
