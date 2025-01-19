import gleam/float
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

type Longitude =
  Float

type Latitude =
  Float

pub type Geo {
  Geo(Longitude, Latitude)
}

const separator = ";"

pub fn decode(string: String) -> Option(Geo) {
  string
  |> string.split_once(separator)
  |> option.from_result()
  |> option.then(decode_pair)
}

fn decode_pair(pair: #(String, String)) -> Option(Geo) {
  let #(left, right) = pair
  case float.parse(left), float.parse(right) {
    Ok(left_float), Ok(right_float) -> Some(Geo(left_float, right_float))
    _, _ -> None
  }
}
