open! Core_kernel
include Uri

let t_of_sexp = function
| Sexp.Atom s -> of_string s
| sexp -> failwithf "Impossible to parse S-Exp %s into an URI" (Sexp.to_string sexp) ()

let sexp_of_t uri = Sexp.Atom (to_string uri)

let to_yojson uri : Yojson.Safe.t = `String (to_string uri)

let of_yojson : Yojson.Safe.t -> (t, string) result = function
| `String s -> Ok (of_string s)
| json -> Shared.invalid json "url"
