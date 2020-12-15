open! Core_kernel

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
  [@@deriving sexp, compare, equal]
end

module PermMap = Map.Make (Perm)

let map =
  PermMap.of_alist_exn
    [
      CREATE_INSTANT_INVITE, Z.of_string "0x00000001";
      KICK_MEMBERS, Z.of_string "0x00000002";
      BAN_MEMBERS, Z.of_string "0x00000004";
      ADMINISTRATOR, Z.of_string "0x00000008";
      MANAGE_CHANNELS, Z.of_string "0x00000010";
      MANAGE_GUILD, Z.of_string "0x00000020";
      ADD_REACTIONS, Z.of_string "0x00000040";
      VIEW_AUDIT_LOG, Z.of_string "0x00000080";
      PRIORITY_SPEAKER, Z.of_string "0x00000100";
      STREAM, Z.of_string "0x00000200";
      VIEW_CHANNEL, Z.of_string "0x00000400";
      SEND_MESSAGES, Z.of_string "0x00000800";
      SEND_TTS_MESSAGES, Z.of_string "0x00001000";
      MANAGE_MESSAGES, Z.of_string "0x00002000";
      EMBED_LINKS, Z.of_string "0x00004000";
      ATTACH_FILES, Z.of_string "0x00008000";
      READ_MESSAGE_HISTORY, Z.of_string "0x00010000";
      MENTION_EVERYONE, Z.of_string "0x00020000";
      USE_EXTERNAL_EMOJIS, Z.of_string "0x00040000";
      VIEW_GUILD_INSIGHTS, Z.of_string "0x00080000";
      CONNECT, Z.of_string "0x00100000";
      SPEAK, Z.of_string "0x00200000";
      MUTE_MEMBERS, Z.of_string "0x00400000";
      DEAFEN_MEMBERS, Z.of_string "0x00800000";
      MOVE_MEMBERS, Z.of_string "0x01000000";
      USE_VAD, Z.of_string "0x02000000";
      CHANGE_NICKNAME, Z.of_string "0x04000000";
      MANAGE_NICKNAMES, Z.of_string "0x08000000";
      MANAGE_ROLES, Z.of_string "0x10000000";
      MANAGE_WEBHOOKS, Z.of_string "0x20000000";
      MANAGE_EMOJIS, Z.of_string "0x40000000";
    ]

let z_of_perm key = PermMap.find_exn map key

type t = Z.t

let compare = Z.compare

let equal = Z.equal

let check ps p =
  let open Z in
  gt (ps land z_of_perm p) zero

let to_list z =
  PermMap.fold map ~init:[] ~f:(fun ~key:p ~data:_ acc -> if check z p then p :: acc else acc)

let of_list ll =
  let open Z in
  List.fold ll ~init:zero ~f:(fun acc p -> acc lor z_of_perm p)

let to_string = Z.to_string

let of_string = Z.of_string

let sexp_of_t x = Sexp.Atom (to_string x)

let t_of_sexp = function
| Sexp.Atom s -> of_string s
| sexp -> failwithf "Impossible to convert S-Exp '%s' into permissions" (Sexp.to_string sexp) ()

let to_yojson x = `String (to_string x)

let of_yojson = function
| `String s -> Ok (of_string s)
| json -> Shared.invalid json "permissions"

let%expect_test "Permissions of yojson" =
  let test j = of_yojson j |> Result.ok_or_failwith |> [%sexp_of: t] |> Sexp.to_string |> print_endline in
  test (of_list [ SEND_MESSAGES; ADD_REACTIONS ] |> to_yojson);
  [%expect {| 2112 |}]

let%expect_test "Permissions checking" =
  let test j p =
    let ps = Yojson.Safe.from_string j |> of_yojson |> Result.ok_or_failwith in
    check ps p |> printf "%b"
  in
  test {|"2112"|} SEND_MESSAGES;
  [%expect {| true |}];
  test {|"2112"|} ADD_REACTIONS;
  [%expect {| true |}];
  test {|"2112"|} VIEW_AUDIT_LOG;
  [%expect {| false |}]

let%expect_test "Permissions to list" =
  let test z = to_list z |> [%sexp_of: Perm.t list] |> Sexp.to_string |> print_endline in
  test (Z.of_int 2112);
  [%expect {| (SEND_MESSAGES ADD_REACTIONS) |}]
