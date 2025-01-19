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
import class.{type Class}
import geo.{type Geo}
import gleam/option.{type Option}
import location.{type Location}

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
    location: Location,
  )
}
