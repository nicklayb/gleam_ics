import gleam/option.{type Option, None, Some}
import object.{Converter}
import property.{DecodedProperty}
import property/class.{type Class}

pub type Todo {
  Todo(class: Option(Class), description: Option(String))
}

pub fn new() {
  Todo(class: None, description: None)
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn apply_property(todo_item, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded
  case name {
    "CLASS" -> Ok(#(Todo(..todo_item, class: class.decode(value)), rest_lines))
    "DESCRIPTION" ->
      Ok(#(Todo(..todo_item, description: Some(value)), rest_lines))
    _ -> Ok(#(todo_item, rest_lines))
  }
}
