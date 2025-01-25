import gleam/dict
import gleam/int
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import property

const date_regexp = "^([0-9]{4})([0-9]{2})([0-9]{2})$"

const date_time_regexp = "^([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})Z$"

pub type Date {
  Date(year: Int, month: Int, day: Int)
  DateTime(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)
}

pub fn decode(string) {
  string
  |> decode_date_time()
  |> result.try_recover(fn(_) { decode_date(string) })
  |> result.replace_error(
    "Unable to parse " <> string <> " as date or date time",
  )
}

pub fn decode_with_parameters(string, parameters: property.Parameters) {
  case dict.get(parameters, "VALUE") {
    Ok("DATE-TIME") | Error(Nil) -> decode_date_time(string)
    Ok("DATE") -> decode_date(string)
    Ok(other) ->
      Error(
        "Invalid VALUE parameter, expected one of DATE or DATE-TIME, got: "
        <> other,
      )
  }
}

pub fn decode_date(string) {
  let assert Ok(regexp) = regexp.from_string(date_regexp)
  case regexp.scan(content: string, with: regexp) {
    [regexp.Match(submatches: [Some(year), Some(month), Some(day)], ..)] -> {
      let assert Ok(year) = int.parse(year)
      let assert Ok(month) = int.parse(month)
      let assert Ok(day) = int.parse(day)

      Ok(Date(year: year, month: month, day: day))
    }
    _ -> {
      Error("Invalid date format, expected YYYYMMDD, got: " <> string)
    }
  }
}

pub fn decode_date_time(string) {
  let assert Ok(regexp) = regexp.from_string(date_time_regexp)
  case regexp.scan(content: string, with: regexp) {
    [
      regexp.Match(
        submatches: [
          Some(year),
          Some(month),
          Some(day),
          Some(hour),
          Some(minute),
          Some(second),
        ],
        ..,
      ),
    ] -> {
      let assert Ok(year) = int.parse(year)
      let assert Ok(month) = int.parse(month)
      let assert Ok(day) = int.parse(day)
      let assert Ok(hour) = int.parse(hour)
      let assert Ok(minute) = int.parse(minute)
      let assert Ok(second) = int.parse(second)

      Ok(DateTime(
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
      ))
    }
    _ -> {
      Error("Invalid date format, expected YYYYMMDDHHMMSS, got: " <> string)
    }
  }
}
