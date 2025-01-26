import gleam/option.{type Option, None, Some}
import object.{Converter, Decodable}

import object/timezone/saving.{type Saving}
import property.{DecodedProperty}

pub type Timezone {
  Timezone(
    id: Option(String),
    standard: Option(Saving),
    daylight: Option(Saving),
  )
}

pub fn new() {
  Timezone(id: None, standard: None, daylight: None)
}

fn put_standard(timezone, standard) {
  Timezone(..timezone, standard: Some(standard))
}

fn put_daylight(timezone, daylight) {
  Timezone(..timezone, daylight: Some(daylight))
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn decode_saving(timezone, rest_lines, mutate, saving) {
  timezone
  |> object.decode(
    rest_lines,
    saving,
    Decodable(mutate: mutate, converter: saving.converter()),
  )
  |> object.flip_result()
}

fn apply_property(timezone, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: _, value: value) = decoded
  case name, value {
    "TZID", _ -> Ok(#(Timezone(..timezone, id: Some(value)), rest_lines))
    "BEGIN", "DAYLIGHT" ->
      decode_saving(timezone, rest_lines, put_daylight, value)
    "BEGIN", "STANDARD" ->
      decode_saving(timezone, rest_lines, put_standard, value)
    _, _ -> Ok(#(timezone, rest_lines))
  }
}
