import gleam/list
import gleam/option
import gleam/uri
import gleeunit
import gleeunit/should
import ics
import object/calendar.{Calendar}
import object/document.{Document}
import object/event.{Event}
import object/todo_item.{Todo}
import property/cal_address
import property/class
import property/date
import property/geo
import property/status/event as event_status
import property/transparency
import simplifile

pub fn main() {
  gleeunit.main()
}

fn cases() {
  let assert Ok(neil_peart_uri) = uri.parse("neil.peart@gmail.com")
  [
    #(
      "valid_calendar.ics",
      Ok(
        Document(calendars: [
          Calendar(
            version: option.Some("2.0"),
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
        ]),
      ),
    ),
  ]
}

pub fn decode_test() {
  list.each(cases(), fn(test_case) {
    let #(input_file, output) = test_case
    input_file
    |> read_file()
    |> ics.parse()
    |> should.equal(output)
  })
}

fn read_file(file) {
  let assert Ok(content) = simplifile.read("./test/fixtures/" <> file)
  content
}
