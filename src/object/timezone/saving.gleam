import data_type.{type Offset}
import gleam/option.{type Option, None}
import object.{Converter}
import property.{DecodedProperty}
import property/date.{type Date}
import property/recurrence_rule.{type RecurrenceRule}

//
// ; the following are each REQUIRED,
// ; but MUST NOT occur more than once
//
// dtstart / tzoffsetto / tzoffsetfrom /
//
// ; the following are optional,
// ; and MAY occur more than once
//
// comment / rdate / rrule / tzname / x-prop
//
// )

/// A "Saving" is used inside of a timezone. It defines how a timezone should
/// calculate daylight saving. Inside a Timezone component, this structure is 
/// used twice, once for Daylight saving time and once for Standard (i.e. not
/// daylight).
///
/// ## Fields
///
/// - ̀`start` (from `DTSTART`): At which time this saving starts
/// - `offset_from` (from ̀`TZOFFSETFROM`): Defines the offset prior to the timezone observance
/// - `offset_to` (from ̀`TZOFFSETTO`): Defines the offset used in the timezone observance
/// - `comment` (from `COMMENT`): Comments for the Saving object
/// - `reccurence_rule` (from `RRULE`): Defines a recurrence for the saving
///
pub type Saving {
  Saving(
    start: Option(Date),
    offset_from: Option(Offset),
    offset_to: Option(Offset),
    comment: Option(String),
    reccurence_rule: Option(RecurrenceRule),
  )
}

fn new() {
  Saving(
    start: None,
    offset_to: None,
    offset_from: None,
    reccurence_rule: None,
    comment: None,
  )
}

/// Saving converter
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
