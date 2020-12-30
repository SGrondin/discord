open! Core_kernel
open Data.Payload

type t =
  | Hello                         of Data.Events.Hello.t
  | Ready                         of Data.Events.Ready.t
  | Resumed
  | Reconnect
  | Invalid_session               of Data.Events.Invalid_session.t
  | Channel_create                of Data.Channel.t
  | Channel_update                of Data.Channel.t
  | Channel_delete                of Data.Channel.t
  | Channel_pins_update           of Data.Events.Channel_pins_update.t
  | Guild_create                  of Data.Guild.t
  | Guild_update                  of Data.Guild.t
  | Guild_delete                  of Data.Unavailable_guild.t
  | Guild_ban_add                 of Data.Events.Guild_ban.t
  | Guild_ban_remove              of Data.Events.Guild_ban.t
  | Guild_emojis_update           of Data.Events.Guild_emojis_update.t
  | Guild_integrations_update     of Data.Events.Guild_integrations_update.t
  | Guild_member_add              of Data.User.member
  | Guild_member_remove           of Data.Events.Guild_member_remove.t
  | Guild_member_update           of Data.User.member
  | Guild_role_create             of Data.Events.Guild_role.t
  | Guild_role_update             of Data.Events.Guild_role.t
  | Guild_role_delete             of Data.Events.Guild_role_delete.t
  | Invite_create                 of Data.Events.Invite_create.t
  | Invite_delete                 of Data.Events.Invite_delete.t
  | Message_create                of Data.Message.t
  | Message_update                of Data.Message.t
  | Message_delete                of Data.Events.Message_delete.t
  | Message_delete_bulk           of Data.Events.Message_delete_bulk.t
  | Message_reaction_add          of Data.Events.Message_reaction_add.t
  | Message_reaction_remove       of Data.Events.Message_reaction_remove.t
  | Message_reaction_remove_all   of Data.Events.Message_reaction_remove_all.t
  | Message_reaction_remove_emoji of Data.Events.Message_reaction_remove_emoji.t
  | Presence_update               of Data.Presence_update.t
  | Typing_start                  of Data.Events.Typing_start.t
  | User_update                   of Data.User.t
  | Voice_state_update            of Data.Voice_state.t
  | Voice_server_update           of Data.Events.Voice_server_update.t
  | Webhook_update                of Data.Events.Webhook_update.t
  | Other
[@@deriving sexp, variants]

let load d p f = d |> p |> Result.ok_or_failwith |> f

let parse = function
| { op = Hello; d; _ } -> load d Data.Events.Hello.of_yojson hello
| { op = Dispatch; t = Some "READY"; s = _; d } -> load d Data.Events.Ready.of_yojson ready
| { op = Dispatch; t = Some "RESUMED"; s = _; d = _ } -> Resumed
| { op = Reconnect; _ } -> Reconnect
| { op = Invalid_session; d; _ } -> load d Data.Events.Invalid_session.of_yojson invalid_session
| { op = Dispatch; t = Some "CHANNEL_CREATE"; s = _; d } -> load d Data.Channel.of_yojson channel_create
| { op = Dispatch; t = Some "CHANNEL_UPDATE"; s = _; d } -> load d Data.Channel.of_yojson channel_update
| { op = Dispatch; t = Some "CHANNEL_DELETE"; s = _; d } -> load d Data.Channel.of_yojson channel_delete
| { op = Dispatch; t = Some "CHANNEL_PINS_UPDATE"; s = _; d } ->
  load d Data.Events.Channel_pins_update.of_yojson channel_pins_update
| { op = Dispatch; t = Some "GUILD_CREATE"; s = _; d } -> load d Data.Guild.of_yojson guild_create
| { op = Dispatch; t = Some "GUILD_UPDATE"; s = _; d } -> load d Data.Guild.of_yojson guild_update
| { op = Dispatch; t = Some "GUILD_DELETE"; s = _; d } ->
  load d Data.Unavailable_guild.of_yojson guild_delete
| { op = Dispatch; t = Some "GUILD_BAN_ADD"; s = _; d } ->
  load d Data.Events.Guild_ban.of_yojson guild_ban_add
| { op = Dispatch; t = Some "GUILD_BAN_REMOVE"; s = _; d } ->
  load d Data.Events.Guild_ban.of_yojson guild_ban_remove
| { op = Dispatch; t = Some "GUILD_EMOJIS_UPDATE"; s = _; d } ->
  load d Data.Events.Guild_emojis_update.of_yojson guild_emojis_update
| { op = Dispatch; t = Some "GUILD_INTEGRATIONS_UPDATE"; s = _; d } ->
  load d Data.Events.Guild_integrations_update.of_yojson guild_integrations_update
| { op = Dispatch; t = Some "GUILD_MEMBER_ADD"; s = _; d } ->
  load d Data.User.member_of_yojson guild_member_add
| { op = Dispatch; t = Some "GUILD_MEMBER_UPDATE"; s = _; d } ->
  load d Data.User.member_of_yojson guild_member_update
| { op = Dispatch; t = Some "GUILD_MEMBER_REMOVE"; s = _; d } ->
  load d Data.Events.Guild_member_remove.of_yojson guild_member_remove
| { op = Dispatch; t = Some "GUILD_ROLE_CREATE"; s = _; d } ->
  load d Data.Events.Guild_role.of_yojson guild_role_create
| { op = Dispatch; t = Some "GUILD_ROLE_UPDATE"; s = _; d } ->
  load d Data.Events.Guild_role.of_yojson guild_role_update
| { op = Dispatch; t = Some "GUILD_ROLE_DELETE"; s = _; d } ->
  load d Data.Events.Guild_role_delete.of_yojson guild_role_delete
| { op = Dispatch; t = Some "INVITE_CREATE"; s = _; d } ->
  load d Data.Events.Invite_create.of_yojson invite_create
| { op = Dispatch; t = Some "INVITE_DELETE"; s = _; d } ->
  load d Data.Events.Invite_delete.of_yojson invite_delete
| { op = Dispatch; t = Some "MESSAGE_CREATE"; s = _; d } -> load d Data.Message.of_yojson message_create
| { op = Dispatch; t = Some "MESSAGE_UPDATE"; s = _; d } -> load d Data.Message.of_yojson message_update
| { op = Dispatch; t = Some "MESSAGE_DELETE"; s = _; d } ->
  load d Data.Events.Message_delete.of_yojson message_delete
| { op = Dispatch; t = Some "MESSAGE_DELETE_BULK"; s = _; d } ->
  load d Data.Events.Message_delete_bulk.of_yojson message_delete_bulk
| { op = Dispatch; t = Some "MESSAGE_REACTION_ADD"; s = _; d } ->
  load d Data.Events.Message_reaction_add.of_yojson message_reaction_add
| { op = Dispatch; t = Some "MESSAGE_REACTION_REMOVE"; s = _; d } ->
  load d Data.Events.Message_reaction_remove.of_yojson message_reaction_remove
| { op = Dispatch; t = Some "MESSAGE_REACTION_REMOVE_ALL"; s = _; d } ->
  load d Data.Events.Message_reaction_remove_all.of_yojson message_reaction_remove_all
| { op = Dispatch; t = Some "MESSAGE_REACTION_REMOVE_EMOJI"; s = _; d } ->
  load d Data.Events.Message_reaction_remove_emoji.of_yojson message_reaction_remove_emoji
| { op = Dispatch; t = Some "PRESENCE_UPDATE"; s = _; d } ->
  load d Data.Presence_update.of_yojson presence_update
| { op = Dispatch; t = Some "TYPING_START"; s = _; d } ->
  load d Data.Events.Typing_start.of_yojson typing_start
| { op = Dispatch; t = Some "USER_UPDATE"; s = _; d } -> load d Data.User.of_yojson user_update
| { op = Dispatch; t = Some "VOICE_STATE_UPDATE"; s = _; d } ->
  load d Data.Voice_state.of_yojson voice_state_update
| { op = Dispatch; t = Some "VOICE_SERVER_UPDATE"; s = _; d } ->
  load d Data.Events.Voice_server_update.of_yojson voice_server_update
| { op = Dispatch; t = Some "WEBHOOK_UPDATE"; s = _; d } ->
  load d Data.Events.Webhook_update.of_yojson webhook_update
| _ -> Other
