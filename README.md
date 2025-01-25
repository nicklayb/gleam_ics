# ICS

[![Package Version](https://img.shields.io/hexpm/v/ics)](https://hex.pm/packages/ics)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/ics/)

Library to parse Ics calendar in respect to the RFC2445 spec.

This is still WIP

```sh
gleam add ics@1
```

```gleam
import ics
import ics/document.{Document}

pub fn main() {
  let assert Ok(Document(..)) = ics.parse("some ICS content")
}
```
