import data_type.{type Sign}
import gleam/option.{type Option}

pub type Frequency {
  Secondly
  Minutely
  Hourly
  Daily
  Weekly
  Monthly
  Yearly
}

pub type Duration {
  Indefinite
  Until(Int)
  Count(Int)
}

pub type Weekday {
  Sunday
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
}

pub type ByWeekday {
  ByWeekday(sign: Sign, ordinal_week: Int, weekday: Weekday)
}

pub type Specifier {
  Specifier(
    interval: Option(Int),
    by_second: List(Int),
    by_minute: List(Int),
    by_hour: List(Int),
    by_weekday: List(Weekday),
  )
}

pub type RecurrenceRule {
  RecurrenceRule(
    frequence: Frequency,
    duration: Duration,
    specificers: Specifier,
  )
}
