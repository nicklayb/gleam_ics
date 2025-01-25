import gleam/list
import gleam/option.{None, Some}
import gleeunit/should
import property/geo

const cases = [
  #("123,32112;3432,231", Some(geo.Geo(123.32112, 3432.231))),
  #("123;3432,231", None),
  #("123,32;3432", None),
  #("123;3432", None),
  #("12,;32,21", None),
  #("12,1;", None),
  #(";12,1", None),
  #(";", None),
  #("other", None),
  #("", None),
]

pub fn decode_test() {
  list.each(cases, fn(test_case) {
    let #(input, output) = test_case
    input
    |> geo.decode()
    |> should.equal(output)
  })
}
