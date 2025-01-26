//
//
//  ; the following are optional,
//                 ; but MUST NOT occur more than once
//
//                 last-mod / location / organizer / priority /
//                 dtstamp / seq / status / summary / transp /
//                 uid / url / recurid /
//
//                 ; either 'dtend' or 'duration' may appear in
//                 ; a 'eventprop', but 'dtend' and 'duration'
//                 ; MUST NOT occur in the same 'eventprop'
//
//                 dtend / duration /
//
//                 ; the following are optional,
//                 ; and MAY occur more than once
//
//                 attach / attendee / categories / comment /
//                 contact / exdate / exrule / rstatus / related /
//                 resources / rdate / rrule / x-prop
//
//                 )
//

import gleam/option.{type Option, None, Some}
import gleam/uri.{type Uri}
import object.{Converter}
import property.{DecodedProperty}
import property/cal_address.{type CalAddress}
import property/class.{type Class}
import property/date.{type Date}
import property/geo.{type Geo}
import property/location.{type Location}
import property/primitive
import property/status/event.{type Status as EventStatus} as event_status
import property/transparency.{type Transparency}

pub type End {
  DatetimeEnd(Date)
  Duration(Int)
}

pub type Event {
  Event(
    class: Option(Class),
    description: Option(String),
    summary: Option(String),
    geo: Option(Geo),
    end: Option(End),
    priority: Option(Int),
    status: Option(EventStatus),
    organizer: Option(CalAddress),
    sequence: Option(Int),
    start_date: Option(Date),
    // to validate
    created: Option(Date),
    last_modified: Option(Date),
    location: Option(Location),
    transparency: Option(Transparency),
    timestamp: Option(Date),
    uid: Option(String),
    url: Option(Uri),
    recurrence_id: Option(String),
  )
}

pub fn new() -> Event {
  Event(
    class: None,
    description: None,
    summary: None,
    geo: None,
    end: None,
    priority: None,
    organizer: None,
    status: None,
    created: None,
    start_date: None,
    last_modified: None,
    sequence: None,
    location: None,
    timestamp: None,
    transparency: None,
    uid: None,
    url: None,
    recurrence_id: None,
  )
}

pub fn converter() {
  Converter(object: new(), apply: apply_property)
}

fn apply_property(event, rest_lines, decoded) {
  let DecodedProperty(name: name, parameters: parameters, value: value) =
    decoded
  case name {
    "CLASS" -> Ok(#(Event(..event, class: class.decode(value)), rest_lines))
    "DESCRIPTION" -> Ok(#(Event(..event, description: Some(value)), rest_lines))
    "STATUS" ->
      Ok(#(Event(..event, status: event_status.decode(value)), rest_lines))
    "SEQUENCE" ->
      Ok(#(Event(..event, sequence: primitive.decode_int(value)), rest_lines))
    "PRIORITY" ->
      Ok(#(Event(..event, priority: primitive.decode_int(value)), rest_lines))
    "TRANSP" ->
      Ok(#(Event(..event, transparency: transparency.decode(value)), rest_lines))
    "GEO" -> Ok(#(Event(..event, geo: geo.decode(value)), rest_lines))
    "UID" -> Ok(#(Event(..event, uid: Some(value)), rest_lines))
    "URL" ->
      Ok(#(
        Event(..event, url: option.from_result(uri.parse(value))),
        rest_lines,
      ))
    "LAST-MODIFIED" ->
      Ok(#(
        Event(
          ..event,
          last_modified: option.from_result(date.decode_date_time(value)),
        ),
        rest_lines,
      ))
    "DTSTAMP" ->
      Ok(#(
        Event(
          ..event,
          timestamp: option.from_result(date.decode_date_time(value)),
        ),
        rest_lines,
      ))
    "CREATED" ->
      Ok(#(
        Event(
          ..event,
          created: option.from_result(date.decode_date_time(value)),
        ),
        rest_lines,
      ))
    "DTSTART" ->
      Ok(#(
        Event(
          ..event,
          start_date: option.from_result(date.decode_with_parameters(
            value,
            parameters,
          )),
        ),
        rest_lines,
      ))
    "ORGANIZER" ->
      Ok(#(
        Event(..event, organizer: option.from_result(cal_address.decode(value))),
        rest_lines,
      ))
    _ -> Ok(#(event, rest_lines))
  }
}
