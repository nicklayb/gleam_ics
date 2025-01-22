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

import birl.{type Time}
import gleam/option.{type Option, None}
import properties/class.{type Class}
import properties/geo.{type Geo}
import properties/location.{type Location}
import property.{Converter, DecodedProperty}

type DateTime =
  Time

pub type End {
  DatetimeEnd(DateTime)
  Duration(Int)
}

pub type Event {
  Event(
    class: Option(Class),
    description: Option(String),
    geo: Option(Geo),
    end: Option(End),
    priority: Option(Int),
    status: Option(String),
    // to validate
    created: Option(DateTime),
    start_date: Option(DateTime),
    last_modified: Option(DateTime),
    location: Option(Location),
  )
}

pub fn new_event() -> Event {
  Event(
    class: None,
    description: None,
    geo: None,
    end: None,
    priority: None,
    status: None,
    created: None,
    start_date: None,
    last_modified: None,
    location: None,
  )
}

pub fn converter() {
  Converter(object: new_event(), apply: apply_property)
}

fn apply_property(event, decoded) {
  case decoded {
    DecodedProperty(name: "CLASS", parameters: _, value: value) ->
      put_class(event, value)
    _ -> event
  }
}

fn put_class(event, string) {
  Event(..event, class: class.decode(string))
}
