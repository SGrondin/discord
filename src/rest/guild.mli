open! Core_kernel
open! Basics

val list_guild_members :
  token:string ->
  guild_id:Basics.Snowflake.t ->
  ?limit:int ->
  ?after:Basics.Snowflake.t ->
  unit ->
  Data.User.member list Lwt.t

val get_guild_audit_logs :
  token:string ->
  guild_id:Basics.Snowflake.t ->
  ?user_id:Basics.Snowflake.t ->
  ?action_type:Data.Audit_log.Event.t ->
  ?before:Basics.Snowflake.t ->
  ?limit:int ->
  unit ->
  Data.Audit_log.t Lwt.t

val get_guild_roles : token:string -> guild_id:Basics.Snowflake.t -> Data.Role.t list Lwt.t

val remove_guild_member :
  token:string -> guild_id:Basics.Snowflake.t -> user_id:Basics.Snowflake.t -> unit Lwt.t

val add_guild_member_role :
  token:string ->
  guild_id:Basics.Snowflake.t ->
  user_id:Basics.Snowflake.t ->
  role_id:Basics.Snowflake.t ->
  unit Lwt.t

val remove_guild_member_role :
  token:string ->
  guild_id:Basics.Snowflake.t ->
  user_id:Basics.Snowflake.t ->
  role_id:Basics.Snowflake.t ->
  unit Lwt.t
