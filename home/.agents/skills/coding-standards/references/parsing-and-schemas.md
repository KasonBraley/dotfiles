# Parsing and boundary representations

## Parse boundary data

Boundary code turns untrusted or less-structured input into application or domain types before it enters inner code.

## Boundary representations

Use a separate protocol or persistence representation when fields, encoding, naming, optionality, or semantics differ from the application input and separation keeps boundary concerns out of inner code. Symbols use their actual meaning, such as `CreateUserRequest`, `StripeCustomerResponse`, or `UserRecord`:

```txt
bytes -> CreateUserRequest -> CreateUserInput -> EmailAddress/UserID/etc.
```

When boundary and application shapes have the same meaning and invariants, decode directly into the application input:

```txt
bytes -> CreateUserInput
```

A boundary adapter owns its representation and struct tags. Keep that type private where possible and translate it into an application or domain type before calling inner code. Do not let JSON, SQL, protobuf, or vendor-generated types become the domain model merely because decoding produced them.

## Parser names

Use names preserving meaning:

- `ParseX(input) (X, error)` for untrusted or less-structured input;
- `NewX(...) (X, error)` for construction from typed pieces when construction can fail;
- `MustX(...) X` only for package constants, tests, or startup declarations whose invalidity is a programmer defect;
- `IsX(value) bool` for true predicates.

Functions that both normalize and enforce invariants are parsers or constructors, not vague `Validate` helpers that leave the original invalid value in circulation. A `Validate() error` method is appropriate when a framework constructs the struct first or validation is part of a boundary contract; inner code receives a validated value.

## Decoder choices

Use standard-library decoders or the repository's established protocol/schema library. Configure them deliberately: size bounds, unknown fields, duplicate/trailing values where relevant, numeric precision, and required fields. Prefer a hand-written parser or constructor for small domain values over a reflection-heavy validation framework.

Represent parsing failures with classified errors carrying safe field/location context. Do not return partially valid domain values unless the API explicitly models partial success.

Parse every path where less-trusted data re-enters typed code, including database reads, cache hits, RPC responses, event consumption, workflow replay, and serialized-state rehydration—even when the same process wrote it. A write-time parser does not prove stored bytes remain valid.

On a measured performance-critical path, a documented trust invariant may replace read-time parsing. Keep unchecked representation inside its owning adapter.

## Completion check

Every external or serialized input path has an owning decoder/parser; every value passed inward is an application or domain type; every parsing failure is classified; boundary representations and tags remain in their adapters; decoder strictness and size limits match the protocol; no partial domain value escapes accidentally; and every trust invariant replacing read-time parsing has measured evidence, documentation, and containment.
