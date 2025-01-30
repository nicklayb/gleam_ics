# Objects

Any `BEGIN` blocks in the ICS format are considere "Object" in this library. An object is defined by a "Converter".

## Converters

A converter specifies an object as well as function to apply the property to the object. The apply function will receive an object, the current property and the rest of the lines.

When a property gets applied, it needs to decode the value then, if valid, apply the value to the object.

Some objects (like `VCALENDAR` and `VTIMEZONE`) will have child objects. In this case, the child converter get used with the rest of the lines and will return the lines remaining after that this object is fully decoded.

## Example

The process goes recursively decoding every properties until in encounter a `END:` block to return the object.

```
BEGIN:VCALENDAR
|
|-> Decode the lines with the Calendar.converter()
    |
    |-> VERSION: Decode the version as string
    |-> PRODID: Decode the product id as string
    |-> BEGIN:VEVENT
        |
        |-> Decode the following lines with Event.converter()
            |
            |-> CLASS: Decode the event's class using the Class decoder
            |-> DESCRIPTION: Decode the event's description as a string
            |-> GEO: Decode the event's geo using the Geo decoder
    |<------|   END:VEVENT: Returns the decoded event with the following lines
    |-> BEGIN:VTIMEZONE
        |
        |-> Decode a timezone component with Timezone.converter()
            |
            |-> TZID: Decode the timezone's ID
    |<------|   END:VTIMEZONE: Returns the decoded timezone with the following lines
|<--|   END:VCALENDAR: Returns the calendar object
```
