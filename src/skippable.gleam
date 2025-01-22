pub type Skippable(a, b) {
  Success(a)
  Failed(b)
  Skip
}

pub fn from_result(result) {
  case result {
    Ok(success) -> Success(success)
    Error(error) -> Failed(error)
  }
}
