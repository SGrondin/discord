open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body

let ss = Basics.Snowflake.to_string

let list_guild_emojis ~token ~guild_id =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "guilds"; ss guild_id; "emojis" ] in
  Call.run ~headers `GET uri (Parse [%of_yojson: Data.Emoji.t list])
