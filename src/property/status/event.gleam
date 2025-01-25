import gleam/option.{None, Some}

pub type Status {
  Tentative
  Confirmed
  Cancelled
}

pub fn decode(string) {
  case string {
    "TENTATIVE" -> Some(Tentative)
    "CANCELLED" -> Some(Cancelled)
    "CONFIRMED" -> Some(Confirmed)
    _ -> None
  }
}
