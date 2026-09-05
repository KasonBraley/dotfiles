# Boundary data

This reference owns representations and trust transitions at external or serialized boundaries: protocols, persistence,
caches, RPC, events, and workflow state. Application and domain meaning belongs to
[`domain-types-and-state.md`](domain-types-and-state.md).

## Representations and mapping

A boundary adapter owns its representation and encoding tags. Use a separate protocol or persistence type when encoding,
naming, optionality, or semantics differ from the inner application type. Keep it private where possible and translate
it before calling inner code. Decode directly into an application input only when the boundary and inner shape have the
same meaning and invariants.

Reuse a domain scalar when a boundary field has exactly the same meaning. Keep mapping explicit when validation,
normalization, defaults, renaming, joins, or domain translation occurs. Do not embed one transport type in another
merely to reuse fields; embedding also promotes API and couples contracts. Do not let JSON, SQL, protobuf, ORM, or
vendor-generated types become the domain model merely because decoding produced them.

## Parsing and normalization

Turn less-trusted input into application or domain types before it enters inner code. Functions that normalize and
enforce invariants are parsers or constructors rather than checks that leave the original invalid value in circulation.
A `Validate() error` method is appropriate when a framework constructs the value first or validation itself is part of
the boundary contract.

Use standard-library decoders or the repository's established protocol/schema library. Configure size bounds, unknown
and duplicate fields, trailing values, numeric precision, and required fields according to the contract. Prefer a small
explicit parser or constructor over a reflection-heavy validation framework.

Return classified parsing errors with safe field or location context. Do not return a partially valid domain value
unless the API explicitly models partial success. Apply defaults while parsing so inner values are normalized; a
malformed supplied value remains an error.

Parse whenever serialized or less-trusted data re-enters typed code, including database reads, external or durable cache
entries, RPC responses, event consumption, workflow replay, and state rehydration. A write-time parser does not prove
stored bytes remain valid. A measured critical path may rely on a documented trust invariant instead, provided unchecked
representation remains inside its adapter.

## Encoded contracts

Represent absence, null, zero, and omission according to the boundary contract:

- use a pointer when absence or `null` must differ from a concrete zero value;
- use a custom optional type when absent, null, and present are distinct states;
- use a value when its zero value is part of the normalized contract;
- do not infer omission from zero unless the protocol defines that behavior;
- use `omitempty` or version-supported `omitzero` only when its exact behavior matches the protocol.

Implement text, binary, or JSON marshal methods on a semantic type only when one canonical representation belongs to
that type. Keep protocol-specific codecs in their adapter when representations vary by boundary. An unmarshaler
validates before assignment, and failed decoding leaves its receiver in a documented safe state.

For an external tagged union, decode the discriminator before the selected payload. Give unknown variants an explicit
tested policy: reject them, preserve opaque data, or map them to a named unknown case.

Translate internal errors into explicit wire error types with `errors.Is` or `errors.As`, never message matching. Apply
[`errors.md`](errors.md) to their classification and safe context.

## Completion check

Every changed external or serialized path has one owning representation and trust transition; boundary types and tags
remain in their adapters; mappings preserve meaning explicitly; defaults and absent, null, zero, and omitted states
match the encoded contract; decoder strictness and size bounds are deliberate; no partial or unchecked domain value
escapes accidentally; custom codecs preserve invariants; and every external variant has a tested unknown-case policy.
