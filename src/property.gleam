import gleam/dict.{type Dict}
import gleam/result
import gleam/string

type Parameters =
  Dict(String, String)

pub type DecodedProperty {
  DecodedProperty(name: String, parameters: Parameters, value: String)
}

pub fn decode(string) -> Result(DecodedProperty, String) {
  string
  |> string.split_once(":")
  |> result.try(fn(result) {
    let #(left, value) = result
    left
    |> decode_name()
    |> result.try(fn(result) {
      let #(name, parameters) = result

      Ok(DecodedProperty(name: name, parameters: parameters, value: value))
    })
  })
}

fn decode_name(left) -> Result(#(String, Parameters), String) {
  left
  |> string.split_once(";")
  |> result.try(fn(result) {
    let #(name, parameters) = result

    parameters
    |> string.split(";")
    |> decode_parameters(dict.new())
    |> result.map(fn(parameters) { #(name, parameters) })
  })
}

fn decode_parameters(raw_parameters, dict) {
  case raw_parameters {
    [] -> Ok(dict)
    [paramter, ..rest] -> {
      case decode_parameter(parameter) {
        Ok(#(name, value)) -> decode_parameters(rest, dict.insert(name, value))
        error -> error
      }
    }
  }
}

fn decode_parameter(parameter) -> Result(#(String, String), String) {
  parameter
  |> string.split_once("=")
  |> result.map_error(fn(_) { "Invalid parameter: " <> parameter })
}
