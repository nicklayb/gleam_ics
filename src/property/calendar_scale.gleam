import data_type/xname
import gleam/option

pub type CalendarScale {
  Gregorian
  XName(xname.XName)
}

pub fn decode(string) {
  case string {
    "GREGORIAN" -> Ok(Gregorian)
    xname -> {
      xname
      |> xname.decode()
      |> option.map(XName)
      |> option.to_result("Expected a X-* parameter")
    }
  }
}
