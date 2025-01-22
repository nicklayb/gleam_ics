import gleam/option.{type Option, None, Some}
import properties/class.{type Class}
import property.{Converter, DecodedProperty}

pub type Todo {
  Todo(class: Option(Class), description: Option(String))
}

pub fn new_todo() {
  Todo(class: None, description: None)
}

pub fn converter() {
  Converter(object: new_todo(), apply: apply_property)
}

fn apply_property(event, decoded) {
  case decoded {
    DecodedProperty(name: "CLASS", parameters: _, value: value) ->
      put_class(event, value)
    DecodedProperty(name: "DESCRIPTION", parameters: _, value: value) ->
      put_description(event, value)
    _ -> event
  }
}

fn put_class(todo_item, string) {
  Todo(..todo_item, class: class.decode(string))
}

fn put_description(todo_item, string) {
  Todo(..todo_item, description: Some(string))
}
