import data_type/iana
import data_type/xname
import gleam/list
import gleam/option.{None, Some}
import gleeunit/should
import property/class

const cases = [
  #("PRIVATE", Some(class.Private)),
  #("PUBLIC", Some(class.Public)),
  #("CONFIDENTIAL", Some(class.Confidential)),
  #("X-Something", Some(class.XName(xname.XName("Something")))),
  #("Something", Some(class.IanaToken(iana.IanaToken("Something")))),
  #("", None),
]

pub fn decode_test() {
  list.each(cases, fn(test_case) {
    let #(input, output) = test_case
    input
    |> class.decode()
    |> should.equal(output)
  })
}
