import event.{type Event}
import gleam/string

pub type Document {
  Document(events: List(Event))
}

type Skippable(a, b) {
  Success(a)
  Failed(b)
  Skip
}

pub fn decode(string: String) -> Result(Document, String) {
  string
  |> string.split("\n")
  |> decode_object(new_document())
}

fn new_document() {
  Document(events: [])
}

fn put_event(document, event) {
  Document(..document, events: [event, ..document.events])
}

fn decode_object(lines, acc) {
  case lines {
    [] -> Ok(acc)
    ["BEGIN:" <> object_name, ..rest] -> {
      case decode_object_body(object_name, rest, acc) {
        #(Skip, new_rest) -> decode_object(new_rest, acc)
        #(Success(acc), new_rest) -> decode_object(new_rest, acc)
        #(error, _) -> error
      }
    }
    [unexpected, ..] -> Error("Unexpected " <> unexpected)
  }
}

fn decode_object_body(
  object_name,
  rest,
  acc,
) -> #(Skippable(Document, String), List(String)) {
  case object_name {
    "VEVENT" -> {
      case event.decode(rest) {
        #(Ok(event), new_rest) -> #(Success(put_event(acc, event)), new_rest)
        #(Error(error), new_rest) -> #(Failed(error), new_rest)
      }
    }
    _ -> #(Skip, drop_until_end(object_name, rest))
  }
}

fn drop_until_end(object_name, lines) {
  case lines {
    ["END:" <> name, ..rest] if object_name == name -> rest
    [_, ..rest] -> drop_until_end(object_name, rest)
    [] -> []
  }
}
