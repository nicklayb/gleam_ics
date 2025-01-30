import data_type/iana
import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}
import object.{Converter, Decodable}
import object/event.{type Event}
import object/timezone.{type Timezone}
import object/todo_item.{type Todo}
import property.{DecodedProperty}
import property/calendar_scale.{type CalendarScale}

pub type Calendar {
  Calendar(
    version: Option(String),
    product_id: Option(String),
    method: Option(iana.IanaToken),
    scale: Option(CalendarScale),
    timezones: Dict(String, Timezone),
    events: List(Event),
    todos: List(Todo),
  )
}

fn new() {
  Calendar(
    version: None,
    product_id: None,
    method: None,
    scale: None,
    events: [],
    timezones: dict.new(),
    todos: [],
  )
}

fn put_scale(calendar, scale) {
  Calendar(..calendar, scale: Some(scale))
}

fn put_event(calendar, event) {
  Calendar(..calendar, events: [event, ..calendar.events])
}

fn put_todo(calendar, todo_item) {
  Calendar(..calendar, todos: [todo_item, ..calendar.todos])
}

fn put_timezone(calendar, timezone: Timezone) {
  let assert Some(tzid) = timezone.id
  Calendar(
    ..calendar,
    timezones: dict.insert(calendar.timezones, tzid, timezone),
  )
}

/// Returns the converter for the Calendar object
pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn apply_property(calendar, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded
  case name, value {
    "VERSION", _ ->
      Ok(#(Calendar(..calendar, version: Some(value)), rest_lines))
    "CALSCALE", _ ->
      object.map_property_from_result(
        calendar,
        put_scale,
        calendar_scale.decode(value),
        rest_lines,
      )
    "METHOD", _ ->
      Ok(#(Calendar(..calendar, method: iana.decode(value)), rest_lines))
    "PRODID", _ ->
      Ok(#(Calendar(..calendar, product_id: Some(value)), rest_lines))
    "BEGIN", "VTIMEZONE" -> {
      calendar
      |> object.decode(
        rest_lines,
        "VTIMEZONE",
        Decodable(mutate: put_timezone, converter: timezone.converter()),
      )
      |> object.flip_result()
    }
    "BEGIN", "VTODO" -> {
      calendar
      |> object.decode(
        rest_lines,
        "VTODO",
        Decodable(mutate: put_todo, converter: todo_item.converter()),
      )
      |> object.flip_result()
    }
    "BEGIN", "VEVENT" -> {
      calendar
      |> object.decode(
        rest_lines,
        "VEVENT",
        Decodable(mutate: put_event, converter: event.converter()),
      )
      |> object.flip_result()
    }
    _, _ -> Ok(#(calendar, rest_lines))
  }
}
