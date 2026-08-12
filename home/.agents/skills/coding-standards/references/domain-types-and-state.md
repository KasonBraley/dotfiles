# Domain types and state

## Named and refined values

Define distinct named types for domain/entity identifiers by default, such as `UserID`, `OrganizationID`, or `WorkflowID`.

Define named unit types whose raw values could be mixed, such as `Milliseconds`, `Bytes`, or `USDCents`. Prefer standard semantic types such as `time.Duration`, `time.Time`, `url.URL`, and `netip.Addr` when they express the domain correctly.

Use parsed domain types for strings and numbers with real rules or meaning, such as `EmailAddress`, `Slug`, `PositiveInt`, or `Percentage`. Keep ordinary display text, local counters, indexes, and implementation-only values primitive until they gain an invariant or mix-up risk.

Construct refined values through parsers or constructors, then pass those values instead of primitives. Keep fields unexported when exporting them would let callers bypass invariants. Make useful zero values intentional; otherwise require construction and reject invalid zero values at boundaries.

## Operation inputs and optionality

Push optionality outward. Branch or parse before calling a function that requires a value. Use `(value, ok)`, a pointer, or a named optional type according to whether zero is valid, nil is safe, and absence is domain-significant.

For non-trivial calls, keep the one obvious primary domain input positional. Group related configuration or capability controls into a named request/options struct when field names prevent order mistakes or make policy visible. Avoid boolean parameters that change behavior.

## Lifecycle state

Use distinct state types when lifecycle states permit different data or operations and the transition API benefits from compile-time separation. Use a named state kind plus validated fields when separate types add more machinery than safety. Use a simple named status when states only need identification. A status plus clear transition functions is enough when it fully expresses lifecycle rules.

```go
type InvoiceStatus uint8

const (
    InvoiceDraft InvoiceStatus = iota
    InvoiceSent
    InvoicePaid
)

type Invoice struct {
    id     InvoiceID
    status InvoiceStatus
    sentAt time.Time
    paidAt time.Time
}
```

Keep construction and transitions in the owning package so invalid field combinations cannot escape. Handle every internal closed state deliberately. Since Go switches are not compile-time exhaustive, use table-driven coverage, a generated exhaustiveness check already used by the repository, or an invariant-reporting default. At external protocol boundaries, unknown variants follow an explicit tested reject, preserve, or fallback policy.

## Boolean blindness

Use independent booleans when combinations are genuinely independent and valid. Behavior-controlling booleans become named options or domain values:

```go
type EmailVerificationPolicy uint8

const (
    VerifyEmail EmailVerificationPolicy = iota
    SkipEmailVerification
)
```

Booleans remain appropriate predicate results such as `IsExpired` and `HasPermission`.

## Completion check

Every changed domain value, operation input, and state concern is accounted for: each identifier, mixable unit, and constrained scalar has a parser or constructor; each remaining primitive has no invariant or mix-up risk that warrants a type; optionality is resolved before required calls; non-trivial calls keep their primary input obvious and name policy controls; lifecycle representations permit exactly their valid construction and transitions; every closed internal state and open external protocol has an explicit tested unknown-case policy; and each boolean is either an independently valid state or predicate result.
