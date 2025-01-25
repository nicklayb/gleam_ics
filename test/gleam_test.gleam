import either
import gleam/list
import gleam/option.{None, Some}
import gleeunit/should

pub type Side {
  Gauche
  Droite
}

fn decode_string(string, check, output) {
  case string == check {
    True -> Some(output)
    False -> None
  }
}

fn decode_gauche(input) {
  decode_string(input, "left", Gauche)
}

fn decode_droite(input) {
  decode_string(input, "right", Droite)
}

const cases = [
  #("left", Some(either.Left(Gauche))),
  #("right", Some(either.Right(Droite))),
  #("other", None),
  #("", None),
]

pub fn decode_test() {
  list.each(cases, fn(test_case) {
    let #(input, output) = test_case
    input
    |> either.decode(decode_gauche, decode_droite)
    |> should.equal(output)
  })
}
