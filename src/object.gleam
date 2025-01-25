import gleam/pair
import gleam/result
import property.{type DecodedProperty}

pub type MutateFunction(parent, child) =
  fn(parent, child) -> parent

pub type Decodable(parent, child) {
  Decodable(mutate: MutateFunction(parent, child), converter: Converter(child))
}

pub type Converter(a) {
  Converter(
    object: a,
    apply: fn(a, List(String), DecodedProperty) ->
      Result(#(a, List(String)), String),
  )
}

pub fn update_object(converter: Converter(object), object: object) {
  Converter(..converter, object: object)
}

pub fn decode(
  parent: parent,
  lines: List(String),
  object_key: String,
  decodable: Decodable(parent, child),
) -> #(Result(parent, String), List(String)) {
  let Decodable(mutate: mutate, converter: converter) = decodable

  lines
  |> decode_properties(object_key, converter)
  |> pair.map_first(fn(result) {
    result.map(result, fn(item) { mutate(parent, item) })
  })
}

pub fn decode_properties(
  lines: List(String),
  object_key: String,
  converter: Converter(object),
) -> #(Result(object, String), List(String)) {
  let Converter(object: object, apply: apply_property) = converter

  case lines {
    ["END:" <> key, ..rest] if key == object_key -> #(Ok(object), rest)
    ["", ..rest] -> decode_properties(rest, object_key, converter)
    [line, ..rest] -> {
      case property.decode(line) {
        Ok(decoded) -> {
          case apply_property(object, rest, decoded) {
            Ok(#(updated_object, rest)) -> {
              decode_properties(
                rest,
                object_key,
                update_object(converter, updated_object),
              )
            }
            Error(error) -> #(Error(error), rest)
          }
        }
        Error(error) -> #(Error(error), rest)
      }
    }
    [] -> #(Ok(object), [])
  }
}
