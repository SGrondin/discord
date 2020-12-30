open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body

type avatar =
  | JPG of string
  | GIF of string
  | PNG of string

let serialize_avatar mime data : Yojson.Safe.t =
  `String (sprintf "data:image/%s;base64,%s" mime (Base64.encode_string data))

let avatar_to_yojson = function
| JPG x -> serialize_avatar "jpeg" x
| GIF x -> serialize_avatar "gif" x
| PNG x -> serialize_avatar "png" x

module User_payload = struct
  type t = {
    username: string option; [@default None]
    avatar: avatar option; [@default None]
  }
  [@@deriving to_yojson]
end

let modify_current_user ~token ?username ?avatar () =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "users"; "@me" ] in
  let body = Call.JSON (User_payload.to_yojson { username; avatar }) in
  Call.run ~headers ~body `PATCH uri (Parse [%of_yojson: Data.User.t])
