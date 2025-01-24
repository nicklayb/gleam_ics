import document.{Document}
import gleam/list
import gleam/option
import gleam/uri
import gleeunit/should
import objects/event.{Event}
import objects/todo_item.{Todo}
import properties/cal_address
import properties/class
import properties/date
import properties/geo
import properties/status/event as event_status
import properties/transparency

fn cases() {
  let assert Ok(neil_peart_uri) = uri.parse("neil.peart@gmail.com")
  [
    #(
      "BEGIN:VEVENT
CLASS:PRIVATE
DTSTART;VALUE=DATE-TIME:20250102T024054Z
DTSTAMP:20220201T103020Z
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
BEGIN:VTODO
CLASS:PUBLIC
DESCRIPTION:Some description
END:VTODO",
      Ok(
        Document(
          events: [
            Event(
              ..event.new(),
              organizer: option.Some(cal_address.CalAddress(
                scheme: cal_address.Mailto,
                uri: neil_peart_uri,
              )),
              status: option.Some(event_status.Tentative),
              sequence: option.Some(2),
              priority: option.Some(9),
              class: option.Some(class.Private),
              geo: option.Some(geo.Geo(43.677128, -79.633453)),
              transparency: option.Some(transparency.Opaque),
              start_date: option.Some(date.DateTime(
                year: 2025,
                month: 1,
                day: 2,
                hour: 2,
                minute: 40,
                second: 54,
              )),
              timestamp: option.Some(date.DateTime(
                year: 2022,
                month: 2,
                day: 1,
                hour: 10,
                minute: 30,
                second: 20,
              )),
              created: option.Some(date.DateTime(
                year: 2025,
                month: 4,
                day: 2,
                hour: 11,
                minute: 32,
                second: 21,
              )),
              last_modified: option.Some(date.DateTime(
                year: 2025,
                month: 3,
                day: 2,
                hour: 1,
                minute: 2,
                second: 1,
              )),
            ),
          ],
          todos: [
            Todo(
              class: option.Some(class.Public),
              description: option.Some("Some description"),
            ),
          ],
        ),
      ),
    ),
  ]
}

pub fn decode_test() {
  list.each(cases(), fn(test_case) {
    let #(input, output) = test_case
    input
    |> document.decode()
    |> should.equal(output)
  })
}
