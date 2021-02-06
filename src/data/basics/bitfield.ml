open! Core_kernel

module type S = sig
  include Set.S

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> (t, string) result
end

module Make (M : Shared.S_Bitfield) : S with type Elt.t := M.t = struct
  module MSet = Set.Make (M)

  let to_z ll =
    let open Z in
    MSet.fold ll ~init:zero ~f:(fun acc x -> logor acc (one lsl M.to_enum x))

  let of_z x =
    let open Z in
    let ( > ) = gt in
    let rec loop x acc = function
      | -1 -> acc
      | i ->
        let acc =
          if (one lsl i) land x > zero
          then MSet.add acc (M.of_enum i |> Option.value_exn ~here:M.here)
          else acc
        in
        (loop [@tailcall]) x acc Int.(i - 1)
    in
    (loop [@tailcall]) x MSet.empty M.max

  let to_yojson ll : Yojson.Safe.t =
    let z = to_z ll in
    if Z.fits_int z then `Int (Z.to_int z) else `Intlit (Z.to_string z)

  let of_yojson = function
  | `Intlit s -> Ok (Z.of_string s |> of_z)
  | `String s -> Ok (Z.of_string s |> of_z)
  | `Int x -> Ok (Z.of_int x |> of_z)
  | json ->
    Error
      (sprintf
         !"Impossible to parse JSON '%{Yojson.Safe}' into a bitfield at %{Source_code_position}"
         json M.here)

  include MSet
end
