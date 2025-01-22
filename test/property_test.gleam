import gleam/dict
import gleam/list
import gleeunit/should
import property.{DecodedProperty}

fn cases() {
  [
    #(
      "CLASS:PRIVATE",
      Ok(DecodedProperty(
        name: "CLASS",
        parameters: dict.new(),
        value: "PRIVATE",
      )),
    ),
    #(
      "KEY;param1=value:value",
      Ok(DecodedProperty(
        name: "KEY",
        value: "value",
        parameters: dict.from_list([#("param1", "value")]),
      )),
    ),
    #("", Error("Missing colon")),
  ]
}

pub fn decode_test() {
  list.each(cases(), fn(test_case) {
    let #(input, output) = test_case
    input
    |> property.decode()
    |> should.equal(output)
  })
}
