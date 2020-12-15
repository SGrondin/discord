open! Core_kernel

type t = string [@@deriving sexp, compare, equal]

let to_string = Fn.id

let of_string = Fn.id

let to_yojson s = `String s

let of_yojson = function
| `String s -> Ok s
| json -> Shared.invalid json "image hash"
