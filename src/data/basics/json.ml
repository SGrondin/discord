open! Core_kernel
include Yojson.Safe

let t_of_sexp = function
| Sexp.Atom s -> from_string s
| sexp -> failwithf !"Impossible to parse S-Exp %{Sexp} into Yojson.Safe.t" sexp ()

let sexp_of_t uri = Sexp.Atom (to_string uri)

let enum = function
| `Int _ -> 0
| `String _ -> 1
| `Bool _ -> 2
| `Float _ -> 3
| `Null -> 4
| `List _ -> 5
| `Assoc _ -> 6

let compare left right =
  let rec loop x y =
    match x, y with
    | `Int x, `Int y -> Int.compare x y
    | `String x, `String y -> String.compare x y
    | `Bool x, `Bool y -> Bool.compare x y
    | `Float x, `Float y -> Float.compare x y
    | `Null, `Null -> Unit.compare () ()
    | `List x, `List y -> List.compare loop x y
    | `Assoc x, `Assoc y ->
      List.compare
        (fun (k1, v1) (k2, v2) ->
          match String.compare k1 k2 with
          | 0 -> loop v1 v2
          | c -> c)
        x y
    | x, y -> Int.compare (enum x) (enum y)
  in
  loop (to_basic left) (to_basic right)

let equal = [%equal: t]

type json_t = t [@@deriving sexp, compare]

module Map = Map.Make (struct
  type t = json_t [@@deriving sexp, compare]
end)

let to_yojson = Fn.id

let of_yojson = Result.return
