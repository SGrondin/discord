open! Core_kernel

type body = JSON of Yojson.Safe.t [@@unboxed]

type _ handler =
  | Unparsed : string handler
  | Ignore : unit handler
  | Parse     : (Yojson.Safe.t -> ('a, string) result) -> 'a handler
  | Parse_exn : (Yojson.Safe.t -> 'a) -> 'a handler

val name : string

val latch : Latch.t

val headers : token:string -> Cohttp.Header.t

val make_uri : ?uri:Uri.t -> string list -> Uri.t

val run :
  headers:Cohttp.Header.t ->
  ?expect:int ->
  ?body:body ->
  Cohttp.Code.meth ->
  Uri.t ->
  ?print_body:bool ->
  'a handler ->
  'a Lwt.t
