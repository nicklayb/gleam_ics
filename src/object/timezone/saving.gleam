import data_type.{type Offset}
import gleam/option.{type Option, None}
import object.{Converter}
import property.{DecodedProperty}
import property/date.{type Date}

pub type Saving {
  Saving(
    start: Option(Date),
    offset_from: Option(Offset),
    offset_to: Option(Offset),
  )
}

pub fn new() {
  Saving(start: None, offset_to: None, offset_from: None)
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn apply_property(saving, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded
  case name {
    "DTSTART" ->
      Ok(#(
        Saving(
          ..saving,
          start: option.from_result(date.decode_date_time(value)),
        ),
        rest_lines,
      ))
    "TZOFFSETFROM" ->
      Ok(#(
        Saving(
          ..saving,
          offset_from: option.from_result(data_type.decode_offset(value)),
        ),
        rest_lines,
      ))
    "TZOFFSETTO" ->
      Ok(#(
        Saving(
          ..saving,
          offset_to: option.from_result(data_type.decode_offset(value)),
        ),
        rest_lines,
      ))
    _ -> Ok(#(saving, rest_lines))
  }
}
