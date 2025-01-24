import gleam/dict
import gleam/list
import gleam/option
import gleeunit/should
import properties/date

const decode_cases = [
  #("21120101", Ok(date.Date(year: 2112, month: 1, day: 1))),
  #(
    "21120101T024335Z",
    Ok(
      date.DateTime(
        year: 2112,
        month: 1,
        day: 1,
        hour: 2,
        minute: 43,
        second: 35,
      ),
    ),
  ),
  #(
    "21120102X024335",
    Error("Unable to parse 21120102X024335 as date or date time"),
  ),
  #("2112011", Error("Unable to parse 2112011 as date or date time")),
  #("21120110D", Error("Unable to parse 21120110D as date or date time")),
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
  #(
    #("21120101", option.Some("DATE")),
    Ok(date.Date(year: 2112, month: 01, day: 01)),
  ),
  #(
    #("21120101T012343Z", option.Some("DATE-TIME")),
    Ok(
      date.DateTime(
        year: 2112,
        month: 01,
        day: 01,
        hour: 1,
        minute: 23,
        second: 43,
      ),
    ),
  ),
  #(
    #("21120101", option.Some("DATE-TIME")),
    Error("Invalid date format, expected YYYYMMDDHHMMSS, got: 21120101"),
  ),
  #(
    #("21120101T012332Z", option.Some("DATE")),
    Error("Invalid date format, expected YYYYMMDD, got: 21120101T012332Z"),
  ),
  #(
    #("21120101", option.Some("XANADU")),
    Error(
      "Invalid VALUE parameter, expected one of DATE or DATE-TIME, got: XANADU",
    ),
  ),
  #(
    #("21120101", option.Some("")),
    Error("Invalid VALUE parameter, expected one of DATE or DATE-TIME, got: "),
  ),
  #(
    #("21120101T012343Z", option.None),
    Ok(
      date.DateTime(
        year: 2112,
        month: 01,
        day: 01,
        hour: 1,
        minute: 23,
        second: 43,
      ),
    ),
  ),
]

pub fn decode_with_parameters_test() {
  list.each(decode_with_parameters_cases, fn(test_case) {
    let #(#(input, parameter_value), output) = test_case
    let parameters = case parameter_value {
      option.Some(value) -> dict.from_list([#("VALUE", value)])
      _ -> dict.new()
    }

    input
    |> date.decode_with_parameters(parameters)
    |> should.equal(output)
  })
}
