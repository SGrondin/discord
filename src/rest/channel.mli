open! Core_kernel
open! Basics

val get_channel_message :
  token:string -> channel_id:Snowflake.t -> message_id:Snowflake.t -> Data.Message.t Lwt.t

val create_message :
  token:string ->
  channel_id:Snowflake.t ->
  content:string ->
  ?embed:Data.Embed.t ->
  unit ->
  Data.Message.t Lwt.t

val delete_message : token:string -> channel_id:Snowflake.t -> message_id:Snowflake.t -> unit Lwt.t

val bulk_delete_messages :
  token:string -> channel_id:Basics.Snowflake.t -> Basics.Snowflake.t list -> unit Lwt.t

val create_reaction :
  token:string -> channel_id:Snowflake.t -> message_id:Snowflake.t -> emoji:Reference.emoji -> unit Lwt.t

val get_reactions :
  token:string ->
  channel_id:Snowflake.t ->
  message_id:Snowflake.t ->
  emoji:Reference.emoji ->
  Data.User.t list Lwt.t

val delete_all_reactions : token:string -> channel_id:Snowflake.t -> message_id:Snowflake.t -> unit Lwt.t

val delete_all_reactions_for_emoji :
  token:string -> channel_id:Snowflake.t -> message_id:Snowflake.t -> emoji:Reference.emoji -> unit Lwt.t

val trigger_typing_indicator : token:string -> channel_id:Basics.Snowflake.t -> unit Lwt.t
