import gleam/option.{None, Some}

pub type TodoStatus {
  Completed
  NeedsAction
  InProgress
  Cancelled
}

pub fn decode(string) {
  case string {
    "COMPLETED" -> Some(Completed)
    "NEEDS-ACTION" -> Some(NeedsAction)
    "IN-PROGRESS" -> Some(InProgress)
    "CANCELLED" -> Some(Cancelled)
    _ -> None
  }
}
