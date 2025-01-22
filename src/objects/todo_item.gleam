import gleam/option.{type Option, None}
import properties/class.{type Class}
import property.{Converter, DecodedProperty}

pub type Todo {
  Todo(class: Option(Class))
}

pub fn new_todo() {
  Todo(class: None)
}

pub fn converter() {
  Converter(object: new_todo(), apply: apply_property)
}

fn apply_property(event, decoded) {
  case decoded {
    DecodedProperty(name: "CLASS", parameters: _, value: value) ->
      put_class(event, value)
    _ -> event
  }
}

fn put_class(todo_item, string) {
  Todo(..todo_item, class: class.decode(string))
}
