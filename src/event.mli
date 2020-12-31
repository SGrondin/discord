open! Core_kernel

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
  | Message_update                of Data.Message.Update.t
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
[@@deriving sexp]

val parse : Data.Payload.t -> t
