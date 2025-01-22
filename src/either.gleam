import gleam/option.{type Option}

pub type Either(a, b) {
  Left(a)
  Right(b)
}

pub fn decode(
  input,
  decode_left: fn(String) -> Option(a),
  decode_right: fn(String) -> Option(b),
) -> Option(Either(a, b)) {
  input
  |> decode_left()
  |> option.map(Left)
  |> option.lazy_or(fn() {
    input
    |> decode_right()
    |> option.map(Right)
  })
}
