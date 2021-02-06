open! Core_kernel

module Self = struct
  module Perm = struct
    type t =
      | CREATE_INSTANT_INVITE
      | KICK_MEMBERS
      | BAN_MEMBERS
      | ADMINISTRATOR
      | MANAGE_CHANNELS
      | MANAGE_GUILD
      | ADD_REACTIONS
      | VIEW_AUDIT_LOG
      | PRIORITY_SPEAKER
      | STREAM
      | VIEW_CHANNEL
      | SEND_MESSAGES
      | SEND_TTS_MESSAGES
      | MANAGE_MESSAGES
      | EMBED_LINKS
      | ATTACH_FILES
      | READ_MESSAGE_HISTORY
      | MENTION_EVERYONE
      | USE_EXTERNAL_EMOJIS
      | VIEW_GUILD_INSIGHTS
      | CONNECT
      | SPEAK
      | MUTE_MEMBERS
      | DEAFEN_MEMBERS
      | MOVE_MEMBERS
      | USE_VAD
      | CHANGE_NICKNAME
      | MANAGE_NICKNAMES
      | MANAGE_ROLES
      | MANAGE_WEBHOOKS
      | MANAGE_EMOJIS
    [@@deriving sexp, compare, equal, enum]

    let here = [%here]
  end

  include Bitfield.Make (Perm)
end

include Self

let%expect_test "Permissions of yojson" =
  let test j = [%to_yojson: t] j |> sprintf !"%{Yojson.Safe}" |> print_endline in
  test (Set.of_list [ SEND_MESSAGES; ADD_REACTIONS ]);
  [%expect {| 2112 |}]

let%expect_test "Permissions checking" =
  let test j p =
    let ps = Yojson.Safe.from_string j |> of_yojson |> Result.ok_or_failwith in
    Set.mem ps p |> printf "%b"
  in
  test {|"2112"|} SEND_MESSAGES;
  [%expect {| true |}];
  test {|"2112"|} ADD_REACTIONS;
  [%expect {| true |}];
  test {|"2112"|} VIEW_AUDIT_LOG;
  [%expect {| false |}]

let%expect_test "Permissions to list" =
  let test z = of_yojson z |> Result.ok_or_failwith |> sprintf !"%{sexp: t}" |> print_endline in
  test (`Intlit "2112");
  [%expect {| (ADD_REACTIONS SEND_MESSAGES) |}]
