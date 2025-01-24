//
//
//  ; the following are optional,
//                 ; but MUST NOT occur more than once
//
//                 class / created / description / dtstart / geo /
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
import properties/cal_address.{type CalAddress}
import properties/class.{type Class}
import properties/date.{type Date}
import properties/geo.{type Geo}
import properties/location.{type Location}
import properties/primitive
import properties/status/event.{type Status as EventStatus} as event_status
import properties/transparency.{type Transparency}
import property.{Converter, DecodedProperty}

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
    // to validate
    created: Option(Date),
    start_date: Option(Date),
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

fn apply_property(event, decoded) {
  let DecodedProperty(name: name, parameters: parameters, value: value) =
    decoded
  case name {
    "CLASS" -> Ok(Event(..event, class: class.decode(value)))
    "DESCRIPTION" -> Ok(Event(..event, description: Some(value)))
    "STATUS" -> Ok(Event(..event, status: event_status.decode(value)))
    "SEQUENCE" -> Ok(Event(..event, sequence: primitive.decode_int(value)))
    "PRIORITY" -> Ok(Event(..event, priority: primitive.decode_int(value)))
    "TRANSP" -> Ok(Event(..event, transparency: transparency.decode(value)))
    "UID" -> Ok(Event(..event, uid: Some(value)))
    "URL" -> Ok(Event(..event, url: option.from_result(uri.parse(value))))
    "DTSTART" ->
      Ok(
        Event(
          ..event,
          start_date: option.from_result(date.decode_with_parameters(
            value,
            parameters,
          )),
        ),
      )
    "ORGANIZER" ->
      Ok(
        Event(..event, organizer: option.from_result(cal_address.decode(value))),
      )
    _ -> Ok(event)
  }
}
