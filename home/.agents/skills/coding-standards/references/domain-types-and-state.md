# Domain types and state

This reference owns semantic application and domain representation after input has crossed any external or serialized
boundary.

## Values and records

Define distinct named types for domain and entity identifiers by default, such as `UserID`, `OrganizationID`, or
`WorkflowID`.

Define named unit types whose raw values could be mixed, such as `Milliseconds`, `Bytes`, or `USDCents`. Prefer standard
semantic types such as `time.Duration`, `time.Time`, `url.URL`, and `netip.Addr` when they express the meaning
correctly.

Use refined types for strings and numbers with real rules or meaning, such as `EmailAddress`, `Slug`, `PositiveInt`, or
`Percentage`. Keep display text, local counters, indexes, and implementation-only values primitive until they gain an
invariant or mix-up risk. Model records with fields whose types carry their domain meaning.

Construct refined values through parsers or constructors, then pass those values instead of primitives. Keep fields
unexported when exporting them would let callers bypass invariants. Make useful zero values intentional; otherwise
require construction and reject invalid zero values at boundaries.

## Operation inputs and optionality

Push semantic optionality outward. Resolve absence before calling an operation that requires a value. Use `(value, ok)`,
a pointer, or a named optional type according to whether zero is valid, nil is safe, and absence has domain meaning.

For non-trivial calls, keep the one obvious primary domain input positional. Group related settings or policy controls
into a named request/options struct when field names prevent order mistakes or expose policy. Replace
behavior-controlling boolean parameters with named options or domain values; booleans remain appropriate for independent
states and predicate results such as `IsExpired` or `HasPermission`.

## Lifecycle state

Use distinct state types when lifecycle states permit different data or operations and compile-time separation
materially simplifies valid use. Use a named state kind plus validated fields when separate types add more machinery
than safety. Use a named status with explicit transition functions when states only need identification.

Keep construction and transitions in the owning package so invalid field combinations cannot escape. Handle every
internal closed state deliberately. Since Go switches are not compile-time exhaustive, use table-driven coverage, an
established generated exhaustiveness check, or an invariant-reporting default.

## Completion check

Every changed domain value, record, operation input, and lifecycle concern has one intentional representation;
identifiers, mixable units, and constrained scalars prevent invalid or ambiguous use; remaining primitives carry no
invariant or mix-up risk warranting a type; semantic absence is resolved before required operations; policy controls are
named; construction and transitions preserve invariants; and every internal closed state is handled deliberately.
