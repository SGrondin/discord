open! Core_kernel

module type S = sig
  type t [@@deriving sexp, compare, equal, yojson]

  val to_int : t -> int

  val of_int : int -> t
end

module Make (M : Shared.S_Bitfield) : S with type t = M.t list = struct
  type t = M.t list [@@deriving sexp, compare, equal]

  let to_int ll = List.fold ll ~init:0 ~f:(fun acc x -> acc lor (1 lsl M.to_enum x))

  let of_int x =
    let rec loop ~here ~of_enum x acc = function
      | -1 -> acc
      | i ->
        let acc = if (1 lsl i) land x > 0 then (of_enum i |> Option.value_exn ~here) :: acc else acc in
        loop ~here ~of_enum x acc (i - 1)
    in
    loop ~here:M.here ~of_enum:M.of_enum x [] M.max

  let to_yojson ll = `Int (to_int ll)

  let of_yojson = function
  | `Int x -> Ok (of_int x)
  | json ->
    Error
      (sprintf
         !"Impossible to parse JSON '%{Yojson.Safe}' into a bitfield at %{Source_code_position}"
         json M.here)
end
