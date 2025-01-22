import gleam/pair
import gleam/result
import gleam/string
import objects/event.{type Event}
import objects/todo_item.{type Todo}
import property.{type Converter}
import skippable.{type Skippable, Failed, Skip, Success}

pub type Document {
  Document(events: List(Event), todos: List(Todo))
}

type MutateFunction(a) =
  fn(Document, a) -> Document

type Decodable(a) {
  Decodable(mutate: MutateFunction(a), converter: Converter(a))
}

pub fn decode(string: String) -> Result(Document, String) {
  string
  |> string.split("\n")
  |> decode_object(new_document())
}

fn new_document() {
  Document(events: [], todos: [])
}

fn put_event(document, event) {
  Document(..document, events: [event, ..document.events])
}

fn put_todo(document, todo_item) {
  Document(..document, todos: [todo_item, ..document.todos])
}

fn decode_object(lines, acc) {
  case lines {
    [] -> Ok(acc)
    ["BEGIN:" <> object_name, ..rest] -> {
      case decode_object_body(object_name, rest, acc) {
        #(Skip, new_rest) -> decode_object(new_rest, acc)
        #(Success(acc), new_rest) -> decode_object(new_rest, acc)
        #(Failed(error), _) -> Error(error)
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
      decode_item(
        acc,
        rest,
        object_name,
        Decodable(converter: event.converter(), mutate: put_event),
      )
    }
    "VTODO" -> {
      decode_item(
        acc,
        rest,
        object_name,
        Decodable(converter: todo_item.converter(), mutate: put_todo),
      )
    }
    _ -> #(Skip, drop_until_end(object_name, rest))
  }
}

fn decode_item(document, lines, object_key, decodable) {
  let Decodable(mutate: mutate, converter: converter) = decodable

  lines
  |> property.decode_properties(object_key, converter)
  |> pair.map_first(fn(skippable) {
    skippable
    |> result.map(fn(item) { mutate(document, item) })
    |> skippable.from_result()
  })
}

fn drop_until_end(object_name, lines) {
  case lines {
    ["END:" <> name, ..rest] if object_name == name -> rest
    [_, ..rest] -> drop_until_end(object_name, rest)
    [] -> []
  }
}
