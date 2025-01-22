import gleam/option.{type Option, None, Some}

pub type XName {
  XName(String)
}

pub fn decode(string) -> Option(XName) {
  case string {
    "X-" <> name -> Some(XName(name))
    _ -> None
  }
}
