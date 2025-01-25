import object.{Converter, Decodable}
import object/calendar.{type Calendar}
import property.{DecodedProperty}

pub type Document {
  Document(calendars: List(Calendar))
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn new() {
  Document(calendars: [])
}

fn put_calendar(document: Document, calendar) {
  Document(calendars: [calendar, ..document.calendars])
}

fn apply_property(document, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded

  case name, value {
    "BEGIN", "VCALENDAR" -> {
      document
      |> object.decode(
        rest_lines,
        "VCALENDAR",
        Decodable(mutate: put_calendar, converter: calendar.converter()),
      )
      |> flip_result()
    }
    _, _ -> Ok(#(document, drop_until_end("VCALENDAR", rest_lines)))
  }
}

fn drop_until_end(object_name, lines) {
  case lines {
    ["END:" <> name, ..rest] if object_name == name -> rest
    [_, ..rest] -> drop_until_end(object_name, rest)
    [] -> []
  }
}

fn flip_result(result) {
  case result {
    #(Ok(success), rest_lines) -> Ok(#(success, rest_lines))
    #(Error(error), _) -> Error(error)
  }
}
