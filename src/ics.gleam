import gleam/string
import object.{Converter}
import object/document.{type Document}
import property

pub fn parse(string: String) -> Result(Document, String) {
  string
  |> string.split("\n")
  |> decode_document(document.converter())
}

fn decode_document(lines, converter) {
  let Converter(object: document, apply: apply_property) = converter
  case lines {
    [] -> Ok(document)
    ["", ..rest] -> decode_document(rest, converter)
    [line, ..rest] -> {
      case property.decode(line) {
        Ok(decoded) -> {
          case apply_property(document, rest, decoded) {
            Ok(#(document, rest_lines)) ->
              decode_document(
                rest_lines,
                object.update_object(converter, document),
              )
            Error(error) -> Error(error)
          }
        }
        Error(error) -> Error(error)
      }
    }
  }
}
