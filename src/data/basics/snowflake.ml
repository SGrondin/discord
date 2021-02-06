open! Core_kernel
open Int64

type t = Int64.t [@@deriving sexp, compare, equal]

let of_yojson = function
| `String s -> Ok (of_string s)
| `Intlit s -> Ok (of_string s)
| `Int x -> Ok (of_int x)
| x -> Error (sprintf !"Invalid snowflake: %{Yojson.Safe}" x)

let to_yojson x = `String (to_string x)

let of_string = of_string

let to_string = to_string

let timestamp x = (x lsr 22) + 1_420_070_400_000L

let to_time x = timestamp x |> to_float |> Time.Span.of_ms |> Time.of_span_since_epoch
