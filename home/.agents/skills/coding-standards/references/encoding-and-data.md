# Encoding and data modeling

Use this when touching data models, request/response structs, database rows, wire contracts, custom scalar types, variants, optional fields, or decoders.

## Records and boundary types

Default to named structs with domain-meaningful field types. Keep JSON, database, protobuf, and vendor tags on boundary-owned representations when their naming, optionality, or semantics differ from inner application types.

```go
type userResponse struct {
    ID    string  `json:"id"`
    Name  string  `json:"name"`
    Email *string `json:"email,omitempty"`
}

type User struct {
    ID    UserID
    Name  NonEmptyString
    Email Optional[EmailAddress]
}
```

Decode into the boundary representation with a configured decoder, validate all fields, then translate into the application or domain type. Apply [`parsing-and-schemas.md`](parsing-and-schemas.md) to ownership and trust decisions.

## Reuse and mapping

Reuse domain scalar types when fields have the same meaning. Keep explicit mapping when behavior, joins, validation, defaults, renaming, or domain translation is involved. Avoid embedding one transport struct in another merely to reuse fields; embedding also promotes API and couples contracts.

## Optionality and defaults

Apply [`domain-types-and-state.md`](domain-types-and-state.md) to decide domain optionality. Represent the encoded contract precisely:

- use pointer fields when JSON `null` or key absence must be distinguished from a concrete zero value;
- use a custom optional type when absent, null, and present states all matter;
- use values when the zero value is part of the normalized contract;
- apply defaults during parsing or construction so inner values are normalized;
- do not infer omission from a zero value unless the wire contract defines it that way.

Use `omitempty` or version-supported `omitzero` only when its exact encoder behavior matches the protocol.

## Nominal values and text codecs

Apply [`domain-types-and-state.md`](domain-types-and-state.md) to decide which values require named types and constructors. Implement `encoding.TextMarshaler`, `encoding.TextUnmarshaler`, `json.Marshaler`, or `json.Unmarshaler` only when one canonical representation belongs to the type. Keep protocol-specific encodings in the adapter when representations vary by boundary. An unmarshaler validates before assigning, and a failed decode leaves the receiver in a documented safe state.

## Variants

Go has no sum types. Represent a small closed internal state with a named kind plus validated state-specific fields, private concrete implementations behind a sealed interface, or distinct state types with explicit transition functions. Choose the least machinery that makes invalid combinations difficult to construct.

For external tagged unions, decode the discriminator first, then decode the selected payload into a concrete boundary type. Unknown variants have an explicit tested policy: reject, preserve as opaque data, or map to a named unknown case. Every internal switch over a closed set has a default that reports an invariant defect or a test that detects newly added cases.

## Errors

Apply [`errors.md`](errors.md) to meaning, granularity, context, message, and recovery guidance. Public wire error contracts use explicit boundary types and translate from internal errors with `errors.Is` or `errors.As`, never message matching.

## Completion check

Every changed data model uses an intentional domain or boundary representation; reused fields preserve the same meaning; optional, null, omitted, and zero states are deliberate; defaults produce normalized values; each decoder matches its boundary's trust and failure policy; custom codecs preserve invariants; every variant has a construction and unknown-case policy; and serialized error surfaces follow [`errors.md`](errors.md).
