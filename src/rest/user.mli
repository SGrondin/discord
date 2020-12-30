open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body

type avatar =
  | JPG of string
  | GIF of string
  | PNG of string
[@@deriving to_yojson]

module User_payload : sig
  type t = {
    username: string option;
    avatar: avatar option;
  }
  [@@deriving to_yojson]
end

val modify_current_user : token:string -> ?username:string -> ?avatar:avatar -> unit -> Data.User.t Lwt.t
