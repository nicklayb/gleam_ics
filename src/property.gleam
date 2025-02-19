import gleam/dict.{type Dict}
import gleam/result
import gleam/string

const value_separator = ":"

const parameter_separator = ";"

const key_value_separator = "="

pub type Parameters =
  Dict(String, String)

pub type DecodedProperty {
  DecodedProperty(name: String, parameters: Parameters, value: String)
}

pub fn decode(string) -> Result(DecodedProperty, String) {
  string
  |> string.split_once(value_separator)
  |> result.map_error(fn(_) { "Missing colon" })
  |> result.try(fn(result) {
    let #(left, value) = result
    left
    |> decode_name()
    |> result.map(fn(result) {
      let #(name, parameters) = result

      DecodedProperty(name: name, parameters: parameters, value: value)
    })
  })
}

fn decode_name(left) -> Result(#(String, Parameters), String) {
  left
  |> string.split(parameter_separator)
  |> default_parameters()
  |> result.try(fn(result) {
    let #(name, parameters) = result

    parameters
    |> decode_parameters(dict.new())
    |> result.map(fn(parameters) { #(name, parameters) })
  })
}

fn default_parameters(parameters) {
  case parameters {
    [name] -> Ok(#(name, []))
    [name, ..rest] -> Ok(#(name, rest))
    _ -> Error("Expected a name with optional parameters")
  }
}

fn decode_parameters(
  raw_parameters: List(String),
  dict: Parameters,
) -> Result(Parameters, String) {
  case raw_parameters {
    [] -> Ok(dict)
    [parameter, ..rest] -> {
      parameter
      |> decode_parameter()
      |> result.try(fn(result) {
        let #(name, value) = result
        decode_parameters(rest, dict.insert(dict, name, value))
      })
    }
  }
}

fn decode_parameter(parameter) -> Result(#(String, String), String) {
  parameter
  |> string.split_once(key_value_separator)
  |> result.map_error(fn(_) { "Invalid parameter: " <> parameter })
}
