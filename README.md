# ICS

[![Package Version](https://img.shields.io/hexpm/v/ics)](https://hex.pm/packages/ics)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/ics/)

Library to parse Ics calendar in respect to the [RFC2445](https://datatracker.ietf.org/doc/html/rfc5545) spec.

This is still WIP but a few fields are already available.

```sh
gleam add ics@1
```

```gleam
import ics
import ics/document.{Document}

pub fn main() {
  let document = "BEGIN:VCALENDAR
VERSION:2.0
METHOD:REQUEST
PRODID:Product ID
CALSCALE:GREGORIAN
BEGIN:VTIMEZONE
TZID:America/Montreal
BEGIN:STANDARD
TZOFFSETTO:+0300
DTSTART:20250402T113221Z
END:STANDARD
BEGIN:DAYLIGHT
TZOFFSETFROM:-1200
DTSTART:20200201T103021Z
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
CLASS:PRIVATE
DTSTART;VALUE=DATE-TIME:20250102T024054Z
DTSTAMP:20220201T103020
CREATED:20250402T113221Z
LAST-MODIFIED:20250302T010201Z
GEO:43.677128;-79.633453
UNSUPPORTED:This should be ignored
SEQUENCE:2
PRIORITY:9
STATUS:TENTATIVE
ORGANIZER:MAILTO:neil.peart@gmail.com
TRANSP:OPAQUE
END:VEVENT
END:VCALENDAR
  "
  let assert Ok(Document(..)) = ics.parse("some ICS content")
}
```

## Components support

- `VCALENDAR`; **In progress**: Main calendar components.
  - `VEVENT`; **In progress**: Event
  - `VTODO`; **Started**: Todo task scheduled
  - `VJOURNAL`; **Todo**: Journal entry
  - `VTIMEZONE` **Started**: Timezone specification. Other component might refer to these Timezone
  - `VFREEBUSY` **Todo**: Represent availability in the calendar
  - `VALARM` **Todo**: Alarm component
