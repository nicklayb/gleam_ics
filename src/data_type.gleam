import gleam/int
import gleam/option.{Some}
import gleam/regexp

pub type Sign {
  Plus
  Minus
}

pub type Offset {
  Offset(sign: Sign, hour: Int, minute: Int)
}

const offset_regexp = "^([0-9]{2})([0-9]{2})$"

pub fn parse_sign(string) {
  case string {
    "-" <> rest_string -> #(Minus, rest_string)
    "+" <> rest_string -> #(Plus, rest_string)
    rest_string -> #(Plus, rest_string)
  }
}

pub fn decode_offset(string) {
  let assert Ok(regexp) = regexp.from_string(offset_regexp)
  let #(sign, rest_string) = parse_sign(string)
  case regexp.scan(content: rest_string, with: regexp) {
    [regexp.Match(submatches: [Some(hours), Some(minutes)], ..)] -> {
      let assert Ok(hours) = int.parse(hours)
      let assert Ok(minutes) = int.parse(minutes)

      Ok(Offset(sign: sign, hour: hours, minute: minutes))
    }
    _ -> Error("Invalid pattern, expected format +HHMM, got: " <> string)
  }
}
