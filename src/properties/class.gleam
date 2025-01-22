import data_types/iana.{type IanaToken}
import data_types/xname.{type XName}
import gleam/option.{type Option, None, Some}

pub type Class {
  Private
  Confidential
  Public
  XName(XName)
  IanaToken(IanaToken)
}

pub fn decode(string: String) -> Option(Class) {
  case string {
    "PUBLIC" -> Some(Public)
    "PRIVATE" -> Some(Private)
    "CONFIDENTIAL" -> Some(Confidential)
    "" -> None
    value -> decode_complex(value)
  }
}

fn decode_complex(string: String) -> Option(Class) {
  case xname.decode(string) {
    None -> {
      string
      |> iana.decode()
      |> option.map(IanaToken)
    }
    decoded -> option.map(decoded, XName)
  }
}
