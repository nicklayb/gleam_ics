import data_type.{Plus}
import data_type/duration.{Duration}
import gleam/list
import gleeunit/should

const cases = [
  #(
    "P15DT5H0M20S",
    Duration(sign: Plus, days: 15, weeks: 0, hours: 5, minutes: 0, seconds: 20),
  ),
  #(
    "P1W5DT5H3M20S",
    Duration(sign: Plus, days: 5, weeks: 1, hours: 5, minutes: 3, seconds: 20),
  ),
  #(
    "PT5H0M20S",
    Duration(sign: Plus, days: 0, weeks: 0, hours: 5, minutes: 0, seconds: 20),
  ),
]

pub fn parse_test() {
  list.each(cases, fn(test_case) {
    let #(input, output) = test_case
    input
    |> duration.parse()
    |> should.equal(output)
  })
}
