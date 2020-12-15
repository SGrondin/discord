open! Core_kernel

module type S = sig
  type t [@@deriving sexp, compare, equal, yojson]

  val to_int : t -> int

  val of_int : int -> t
end

module Make (X : Shared.S_Bitfield) : S with type t = X.t list = struct
  type t = X.t list [@@deriving sexp, compare, equal]

  let to_int ll = List.fold ll ~init:0 ~f:(fun acc x -> acc lor (1 lsl X.to_enum x))

  let of_int x =
    let rec loop ~here ~of_enum x acc = function
      | -1 -> acc
      | i ->
        let acc = if (1 lsl i) land x > 0 then (of_enum i |> Option.value_exn ~here) :: acc else acc in
        loop ~here ~of_enum x acc (i - 1)
    in
    loop ~here:X.here ~of_enum:X.of_enum x [] X.max

  let to_yojson ll = `Int (to_int ll)

  let of_yojson = function
  | `Int x -> Ok (of_int x)
  | json ->
    Error
      (sprintf "Impossible to parse JSON '%s' into a bitfield at %s" (Yojson.Safe.to_string json)
         (Source_code_position.to_string X.here))
end
