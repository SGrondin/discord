open! Core_kernel
open! Cohttp
open! Cohttp_lwt_unix
module Body = Cohttp_lwt.Body

module Create_message = struct
  type t = {
    content: string;
    nonce: string;
    tts: bool;
    embed: Data.Embed.t option; [@default None]
  }
  [@@deriving sexp, fields, to_yojson]
end

module Bulk_delete_messages = struct
  type t = { messages: Basics.Snowflake.t list } [@@deriving sexp, fields, to_yojson]
end

let ss = Basics.Snowflake.to_string

let get_channel_message ~token ~channel_id ~message_id =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "channels"; ss channel_id; "messages"; ss message_id ] in
  Call.run ~headers `GET uri (Parse [%of_yojson: Data.Message.t])

let create_message ~token ~channel_id ~content ?embed () =
  let body =
    Call.JSON
      (Create_message.to_yojson
         { content; nonce = Latch.Time.get () |> Int64.to_string; tts = false; embed })
  in
  let headers = Header.add (Call.headers ~token) "content-type" "application/json" in
  let uri = Call.make_uri [ "channels"; ss channel_id; "messages" ] in
  Call.run ~headers ~body `POST uri (Parse [%of_yojson: Data.Message.t])

let delete_message ~token ~channel_id ~message_id =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "channels"; ss channel_id; "messages"; ss message_id ] in
  Call.run ~headers ~expect:204 `DELETE uri Ignore

let bulk_delete_messages ~token ~channel_id messages =
  let body = Call.JSON (Bulk_delete_messages.to_yojson { messages }) in
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "channels"; ss channel_id; "messages"; "bulk-delete" ] in
  Call.run ~headers ~body ~expect:204 `POST uri Ignore

let create_reaction ~token ~channel_id ~message_id ~emoji =
  let headers = Call.headers ~token in
  let uri =
    Call.make_uri
      [
        "channels";
        ss channel_id;
        "messages";
        ss message_id;
        "reactions";
        Basics.Reference.to_url emoji;
        "@me";
      ]
  in
  (* The docs confirm that the emoji rate limiting is different *)
  let%lwt () = Latch.wait_and_trigger ~custom_cooldown:(Latch.Time.ms 1500L) Call.latch in
  Call.run ~headers ~expect:204 `PUT uri Ignore

let get_reactions ~token ~channel_id ~message_id ~emoji =
  let headers = Call.headers ~token in
  let uri =
    Call.make_uri
      [ "channels"; ss channel_id; "messages"; ss message_id; "reactions"; Basics.Reference.to_url emoji ]
  in
  Call.run ~headers `GET uri (Parse [%of_yojson: Data.User.t list])

let delete_all_reactions ~token ~channel_id ~message_id =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "channels"; ss channel_id; "messages"; ss message_id; "reactions" ] in
  Call.run ~headers ~expect:204 `DELETE uri Ignore

let delete_all_reactions_for_emoji ~token ~channel_id ~message_id ~emoji =
  let headers = Call.headers ~token in
  let uri =
    Call.make_uri
      [ "channels"; ss channel_id; "messages"; ss message_id; "reactions"; Basics.Reference.to_url emoji ]
  in
  Call.run ~headers ~expect:204 `DELETE uri Ignore

let trigger_typing_indicator ~token ~channel_id =
  let headers = Call.headers ~token in
  let uri = Call.make_uri [ "channels"; ss channel_id; "typing" ] in
  Call.run ~headers ~expect:204 `POST uri Ignore
