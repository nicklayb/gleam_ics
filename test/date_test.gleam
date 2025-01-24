import gleam/dict
import gleam/list
import gleeunit/should
import properties/date

const decode_cases = [
  #("20250101", Ok(date.Date(year: 2025, month: 1, day: 1))),
  #(
    "20250101T024335Z",
    Ok(
      date.DateTime(
        year: 2025,
        month: 1,
        day: 1,
        hour: 2,
        minute: 43,
        second: 35,
      ),
    ),
  ),
  #(
    "20250102X024335",
    Error("Unable to parse 20250102X024335 as date or date time"),
  ),
  #("2025011", Error("Unable to parse 2025011 as date or date time")),
  #("20250110D", Error("Unable to parse 20250110D as date or date time")),
]

pub fn decode_test() {
  list.each(decode_cases, fn(test_case) {
    let #(input, output) = test_case
    input
    |> date.decode()
    |> should.equal(output)
  })
}

const decode_with_parameters_cases = [
  #(#("20250101", "DATE"), Ok(date.Date(2025, 01, 01))),
  #(
    #("20250101T012343Z", "DATE-TIME"),
    Ok(date.DateTime(2025, 01, 01, 1, 23, 43)),
  ),
  #(
    #("20250101", "DATE-TIME"),
    Error("Invalid date format, expected YYYYMMDDHHMMSS, got: 20250101"),
  ),
  #(
    #("20250101T012332Z", "DATE"),
    Error("Invalid date format, expected YYYYMMDD, got: 20250101T012332Z"),
  ),
]

pub fn decode_with_parameters_test() {
  list.each(decode_with_parameters_cases, fn(test_case) {
    let #(#(input, parameter_value), output) = test_case
    let parameters = dict.from_list([#("VALUE", parameter_value)])
    input
    |> date.decode_with_parameters(parameters)
    |> should.equal(output)
  })
}
