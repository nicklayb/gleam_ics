import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam/uri.{type Uri}

pub type Scheme {
  Mailto
}

pub type CalAddress {
  CalAddress(scheme: Scheme, uri: Uri)
}

pub fn decode(string) -> Result(CalAddress, String) {
  string
  |> string.split_once(":")
  |> result.map_error(fn(_) { "Expected MAILTO:uri format, got: " <> string })
  |> result.try(fn(splitted) {
    let #(scheme, uri) = splitted
    case decode_scheme(scheme), uri.parse(uri) {
      Some(scheme), Ok(uri) -> Ok(CalAddress(scheme: scheme, uri: uri))
      None, _ -> Error("Unable to decode scheme, got: " <> scheme)
      _, Error(_) -> Error("Unable to parse URI, got: " <> uri)
    }
  })
}

fn decode_scheme(string) {
  case string {
    "MAILTO" -> Some(Mailto)
    _ -> None
  }
}
