import gleam/float
import gleam/int
import gleam/option.{None, Some}

pub fn decode_int(string) {
  string
  |> int.parse()
  |> option.from_result()
}

pub fn decode_float(string) {
  string
  |> float.parse()
  |> option.from_result()
}

pub fn decode_bool(string) {
  case string {
    "TRUE" -> Some(True)
    "FALSE" -> Some(False)
    _ -> None
  }
}
