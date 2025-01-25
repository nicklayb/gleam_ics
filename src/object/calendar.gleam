import gleam/option.{type Option, None, Some}
import object.{Converter, Decodable}
import object/event.{type Event}
import object/todo_item.{type Todo}
import property.{DecodedProperty}

pub type Calendar {
  Calendar(version: Option(String), events: List(Event), todos: List(Todo))
}

fn new() {
  Calendar(version: None, events: [], todos: [])
}

fn put_event(calendar, event) {
  Calendar(..calendar, events: [event, ..calendar.events])
}

fn put_todo(calendar, todo_item) {
  Calendar(..calendar, todos: [todo_item, ..calendar.todos])
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn apply_property(calendar, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded
  case name, value {
    "VERSION", _ ->
      Ok(#(Calendar(..calendar, version: Some(value)), rest_lines))
    "BEGIN", "VTODO" -> {
      case
        object.decode(
          calendar,
          rest_lines,
          "VTODO",
          Decodable(mutate: put_todo, converter: todo_item.converter()),
        )
      {
        #(Ok(calendar), rest_lines) -> Ok(#(calendar, rest_lines))
        #(Error(error), _) -> Error(error)
      }
    }
    "BEGIN", "VEVENT" -> {
      case
        object.decode(
          calendar,
          rest_lines,
          "VEVENT",
          Decodable(mutate: put_event, converter: event.converter()),
        )
      {
        #(Ok(calendar), rest_lines) -> Ok(#(calendar, rest_lines))
        #(Error(error), _) -> Error(error)
      }
    }
    _, _ -> Ok(#(calendar, rest_lines))
  }
}
