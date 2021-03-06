open! Core_kernel

module type Make_S = sig
  include Shared.S_Base

  val here : Source_code_position.t

  module Variants : sig
    val to_rank : t -> int

    val descriptions : (string * int) list
  end
end

module type Make_Int_S = sig
  include Make_S

  val unknown : int -> t
end

module type Make_String_S = sig
  include Make_S

  val unknown : string -> t
end

module type S = sig
  type t

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> (t, string) result

  val is_enum : unit
end

module Make_Int (X : Make_Int_S) : sig
  include S with type t := X.t
end = struct
  type t = X.t [@@deriving sexp, compare, equal]

  let is_enum = ()

  let tags = Array.of_list X.Variants.descriptions

  let last = Array.length tags - 1

  let lookup_of, lookup_to =
    Array.filter_mapi tags ~f:(fun i -> function
      | name, 0 when i < last -> Some (Ok ([%of_sexp: X.t] (Sexp.Atom name)), `Int i)
      | "Unknown", 1 when i = last -> None
      | name, x ->
        failwithf
          "Invalid enum, tags must not have arguments except for the 'Unknown' last one that must have \
           exactly one. Found: %s (%i)"
          name x ())
    |> Array.unzip

  let of_yojson = function
  | `Int i when i < last -> lookup_of.(i)
  | `Int i -> Ok (X.unknown i)
  | json ->
    Error
      (sprintf
         !"Impossible to parse JSON '%{Yojson.Safe}' into an Int Enum at %{Source_code_position}"
         json X.here)

  let to_yojson x : Yojson.Safe.t =
    let i = X.Variants.to_rank x in
    try lookup_to.(i) with
    | Invalid_argument _ -> (
      match [%sexp_of: X.t] x with
      | Sexp.(List [ _; Atom s ]) -> `Intlit s
      | sexp -> failwithf !"Assertion Failure at %{Source_code_position}: %{Sexp}" X.here sexp ()
    )
end

module Make_String (X : Make_String_S) : sig
  include S with type t := X.t
end = struct
  type t = X.t [@@deriving sexp, compare, equal]

  let is_enum = ()

  let tags = Array.of_list X.Variants.descriptions

  let last = Array.length tags - 1

  let lookup_of, lookup_to =
    let lookup_of, ll_to =
      Array.foldi tags ~init:(Json.Map.empty, []) ~f:(fun i ((lookup_of, ll_to) as acc) -> function
        | name, 0 when i < last ->
          let x = [%of_sexp: X.t] (Sexp.Atom name) in
          let json = [%to_yojson: X.t] x |> Yojson.Safe.Util.index 0 in
          Json.Map.set lookup_of ~key:json ~data:x, json :: ll_to
        | "Unknown", 1 when i = last -> acc
        | name, x ->
          failwithf
            "Invalid enum, tags must not have arguments except for the 'Unknown' last one that must have \
             exactly one. Found: %s (%i)"
            name x ())
    in
    lookup_of, Array.of_list_rev ll_to

  let of_yojson json =
    match Json.Map.find lookup_of json with
    | Some x -> Ok x
    | None -> (
      match json with
      | `String s -> Ok (X.unknown s)
      | _ ->
        Error
          (sprintf
             !"Impossible to parse JSON '%{Yojson.Safe}' into an Int Enum at %{Source_code_position}"
             json X.here)
    )

  let to_yojson x =
    let i = X.Variants.to_rank x in
    try lookup_to.(i) with
    | Invalid_argument _ -> (
      match [%sexp_of: X.t] x with
      | Sexp.(List [ _; Atom s ]) -> `Intlit s
      | sexp -> failwithf !"Assertion Failure at %{Source_code_position}: %{Sexp}" X.here sexp ()
    )
end

let%expect_test "Enum Int to yojson" =
  let module M = struct
    module Self = struct
      type t =
        | A
        | B [@key "Name_should_be_ignored"]
        | Unknown of int
      [@@deriving sexp, compare, equal, variants, yojson]

      let here = [%here]
    end

    include Self
    include Make_Int (Self)
  end in
  let test m = M.to_yojson m |> Yojson.Safe.to_string |> print_endline in
  test A;
  [%expect {| 0 |}];
  test B;
  [%expect {| 1 |}];
  test (Unknown 5);
  [%expect {| 5 |}]

let%expect_test "Enum Int of yojson" =
  let module M = struct
    module Self = struct
      type t =
        | A
        | B [@key "Name_should_be_ignored"]
        | Unknown of int
      [@@deriving sexp, compare, equal, variants, yojson]

      let here = [%here]
    end

    include Self
    include Make_Int (Self)
  end in
  let test s =
    Yojson.Safe.from_string s
    |> M.of_yojson
    |> Result.ok_or_failwith
    |> sprintf !"%{sexp: M.t}"
    |> print_endline
  in
  test {|0|};
  [%expect {| A |}];
  test {|1|};
  [%expect {| B |}];
  test {|10|};
  [%expect {| (Unknown 10) |}]

let%expect_test "Enum String to yojson" =
  let module M = struct
    module Self = struct
      type t =
        | Abc
        | DEF_GHI
        | Custom_Name [@name "$custom"]
        | Unknown     of string
      [@@deriving sexp, compare, equal, variants, yojson]

      let here = [%here]
    end

    include Self
    include Make_String (Self)
  end in
  let test m = M.to_yojson m |> Yojson.Safe.to_string |> print_endline in
  test Abc;
  [%expect {| "Abc" |}];
  test DEF_GHI;
  [%expect {| "DEF_GHI" |}];
  test Custom_Name;
  [%expect {| "$custom" |}];
  test (Unknown "XYz");
  [%expect {| XYz |}]

let%expect_test "Enum String of yojson" =
  let module M = struct
    module Self = struct
      type t =
        | Abc
        | DEF_GHI
        | Custom_Name [@name "$custom"]
        | Unknown     of string
      [@@deriving sexp, compare, equal, variants, yojson]

      let here = [%here]
    end

    include Self
    include Make_String (Self)
  end in
  let test s =
    Yojson.Safe.from_string s
    |> M.of_yojson
    |> Result.ok_or_failwith
    |> sprintf !"%{sexp: M.t}"
    |> print_endline
  in
  test {|"Abc"|};
  [%expect {| Abc |}];
  test {|"DEF_GHI"|};
  [%expect {| DEF_GHI |}];
  test {|"$custom"|};
  [%expect {| Custom_Name |}];
  test {|"XY_zz"|};
  [%expect {| (Unknown XY_zz) |}]
