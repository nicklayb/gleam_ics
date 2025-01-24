import gleam/option.{None, Some}

pub type Transparency {
  Opaque
  Transparent
}

pub fn decode(string) {
  case string {
    "OPAQUE" -> Some(Opaque)
    "TRANSPARENT" -> Some(Transparent)
    _ -> None
  }
}
