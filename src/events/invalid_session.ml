open! Core_kernel
open! Basics

module Self = struct
  type t = { resumable: bool } [@@deriving sexp, compare, equal, fields] [@@unboxed]

  let of_yojson x = [%of_yojson: bool] x |> Result.map ~f:(fun resumable -> { resumable })

  let to_yojson { resumable } = `Bool resumable [@@deriving sexp, compare, equal]
end

include Self

let%expect_test "Invalid session of yojson" =
  let test = Shared.test (module Self) in
  test {|false|};
  [%expect {| ((resumable false)) |}]
