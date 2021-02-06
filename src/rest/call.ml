open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body
open Lwt.Infix

let name = "Camlbot"

let headers ~token = Header.of_list [ "Authorization", sprintf "Bot %s" token; "User-Agent", name ]

(* https://discord.com/api/v8/ *)
let base_uri = Uri.make ~scheme:"https" ~host:"discord.com" ()

let make_uri ?(uri = base_uri) ll = "api" :: "v8" :: ll |> String.concat ~sep:"/" |> Uri.with_path uri

let latch = Latch.(create ~cooldown:(Time.ms 400L))

type body = JSON of Yojson.Safe.t [@@unboxed]

type _ handler =
  | Unparsed : string handler
  | Ignore : unit handler
  | Parse     : (Yojson.Safe.t -> ('a, string) result) -> 'a handler
  | Parse_exn : (Yojson.Safe.t -> 'a) -> 'a handler

let run :
   type a.
   headers:Header.t ->
   ?expect:int ->
   ?body:body ->
   Code.meth ->
   Uri.t ->
   ?print_body:bool ->
   a handler ->
   a Lwt.t =
 fun ~headers ?(expect = 200) ?body meth uri ?(print_body = false) handler ->
  let%lwt () = Latch.wait_and_trigger latch in
  let body, headers =
    match body with
    | None as x -> x, headers
    | Some (JSON x) ->
      ( Some (Yojson.Safe.to_string x |> Body.of_string),
        Header.add headers "content-type" "application/json" )
  in
  let%lwt res, res_body = Client.call ~headers ?body meth uri in
  let status = Response.status res in
  let get_body_str = lazy (Body.to_string res_body) in
  let%lwt () = if print_body then force get_body_str >>= Lwt_io.printl else Lwt.return_unit in
  match Code.code_of_status status with
  | code when code = expect ->
    let handle : a Lwt.t =
      match handler with
      | Unparsed -> force get_body_str
      | Ignore -> Body.drain_body res_body
      | Parse f -> force get_body_str >|= fun s -> Yojson.Safe.from_string s |> f |> Result.ok_or_failwith
      | Parse_exn f -> force get_body_str >|= fun s -> Yojson.Safe.from_string s |> f
    in
    handle
  | _ ->
    let%lwt body_str = force get_body_str in
    failwithf
      !"Invalid HTTP response (%{Code.string_of_status})\n%{Header}\n%s"
      status (Response.headers res) body_str ()
