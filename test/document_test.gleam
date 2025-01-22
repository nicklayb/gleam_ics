import document.{Document}
import gleam/list
import gleam/option
import gleeunit/should
import objects/event.{Event}
import objects/todo_item.{Todo}
import properties/class

fn cases() {
  [
    #(
      "BEGIN:VEVENT
CLASS:PRIVATE
UNSUPPORTED:This should be ignored
END:VEVENT
BEGIN:VTODO
CLASS:PUBLIC
DESCRIPTION:Some description
END:VTODO",
      Ok(
        Document(
          events: [
            Event(..event.new_event(), class: option.Some(class.Private)),
          ],
          todos: [
            Todo(
              ..todo_item.new_todo(),
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
