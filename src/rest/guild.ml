open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body

let ss = Basics.Snowflake.to_string

let add_param name to_string opt uri =
  match opt with
  | None -> uri
  | Some x -> Uri.add_query_param' uri (name, to_string x)

let list_guild_members ~token ~guild_id ?limit ?after () =
  let headers = Call.headers ~token in
  let uri =
    Call.make_uri [ "guilds"; ss guild_id; "members" ]
    |> add_param "limit" Int.to_string limit
    |> add_param "after" ss after
  in
  Call.run ~headers `GET uri (Parse [%of_yojson: Data.User.member list])

let get_guild_audit_logs ~token ~guild_id ?user_id ?action_type ?before ?limit () =
  let headers = Call.headers ~token in
  let uri =
    Call.make_uri [ "guilds"; ss guild_id; "audit-logs" ]
    |> add_param "user_id" ss user_id
    |> add_param "action_type"
         (Fn.compose Yojson.Safe.to_string Data.Audit_log.Event.to_yojson)
         action_type
    |> add_param "before" ss before
    |> add_param "limit" Int.to_string limit
  in
  Call.run ~headers `GET uri (Parse [%of_yojson: Data.Audit_log.t])
