import data_type.{type Sign, Plus}
import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import gleam/string

pub type Duration {
  Duration(
    sign: Sign,
    days: Int,
    weeks: Int,
    hours: Int,
    minutes: Int,
    seconds: Int,
  )
}

const duration_regexp = "^P(([0-9]+Y)?([0-9]+M)?([0-9]+W)?([0-9]+D)?(T([0-9]+H)?([0-9]+M)?([0-9]+(\\.?[0-9]+)?S)?))?$"

fn new() {
  Duration(sign: Plus, days: 0, weeks: 0, hours: 0, minutes: 0, seconds: 0)
}

pub fn parse(string) {
  let #(sign, rest_string) = data_type.parse_sign(string)
  let assert Ok(regexp) = regexp.from_string(duration_regexp)
  let duration = Duration(..new(), sign: sign)

  case regexp.scan(content: rest_string, with: regexp) {
    [
      regexp.Match(
        submatches: [
          _full_match,
          _year_match,
          _month_match,
          weeks,
          days,
          _time_match,
          hours,
          minutes,
          seconds,
        ],
        ..,
      ),
    ] -> {
      list.fold(
        over: [weeks, days, hours, minutes, seconds],
        from: duration,
        with: fn(duration, match) {
          case match {
            option.Some(match) -> {
              update_duration_from_match(duration, match)
            }
            _ -> duration
          }
        },
      )
    }
    _ -> duration
  }
}

fn update_duration_from_match(duration, match) {
  case extract_char(match) {
    #("W", weeks) -> Duration(..duration, weeks: weeks)
    #("H", hours) -> Duration(..duration, hours: hours)
    #("M", minutes) -> Duration(..duration, minutes: minutes)
    #("S", seconds) -> Duration(..duration, seconds: seconds)
    #("D", days) -> Duration(..duration, days: days)
    _ -> duration
  }
}

fn extract_char(match) {
  let assert Ok(char) = string.last(match)
  let without_char = string.replace(match, char, "")
  let assert Ok(int) = int.parse(without_char)
  #(char, int)
}
