import gleam/option.{type Option}

pub type Location {
  Location(location: String, language: Option(String), alt_rep: Option(String))
}
