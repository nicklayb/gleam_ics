import gleam/dict.{type Dict}
import gleam/result
import gleam/string

const value_separator = ":"

const parameter_separator = ";"

const key_value_separator = "="

type Parameters =
  Dict(String, String)

pub type Converter(a) {
  Converter(object: a, apply: fn(a, DecodedProperty) -> a)
}

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
    |> result.try(fn(result) {
      let #(name, parameters) = result

      Ok(DecodedProperty(name: name, parameters: parameters, value: value))
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
      case decode_parameter(parameter) {
        Ok(#(name, value)) ->
          decode_parameters(rest, dict.insert(dict, name, value))
        Error(error) -> Error(error)
      }
    }
  }
}

fn decode_parameter(parameter) -> Result(#(String, String), String) {
  parameter
  |> string.split_once(key_value_separator)
  |> result.map_error(fn(_) { "Invalid parameter: " <> parameter })
}

pub fn decode_properties(lines, object_key, converter) {
  let Converter(object: object, apply: apply_property) = converter

  case lines {
    ["END:" <> key, ..rest] if key == object_key -> #(Ok(object), rest)
    [line, ..rest] -> {
      case decode(line) {
        Ok(decoded) -> {
          let object = apply_property(object, decoded)

          decode_properties(
            rest,
            object_key,
            Converter(..converter, object: object),
          )
        }
        Error(error) -> #(Error(error), rest)
      }
    }
    [] -> #(Ok(object), [])
  }
}
