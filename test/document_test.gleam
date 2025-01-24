import document.{Document}
import gleam/list
import gleam/option
import gleam/uri
import gleeunit/should
import objects/event.{Event}
import objects/todo_item.{Todo}
import properties/cal_address
import properties/class
import properties/status/event as event_status
import properties/transparency

fn cases() {
  let assert Ok(bobby_hill_uri) = uri.parse("bobby.hill@gmail.com")
  [
    #(
      "BEGIN:VEVENT
CLASS:PRIVATE
DTSTART;VALUE=DATE:20250102T024054Z
UNSUPPORTED:This should be ignored
SEQUENCE:2
PRIORITY:9
STATUS:TENTATIVE
ORGANIZER:MAILTO:bobby.hill@gmail.com
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
                uri: bobby_hill_uri,
              )),
              status: option.Some(event_status.Tentative),
              sequence: option.Some(2),
              priority: option.Some(9),
              class: option.Some(class.Private),
              transparency: option.Some(transparency.Opaque),
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
