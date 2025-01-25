import gleam/option.{type Option, None, Some}

pub type IanaToken {
  IanaToken(String)
}

pub fn decode(string) -> Option(IanaToken) {
  case string {
    "" -> None
    _ -> Some(IanaToken(string))
  }
}
