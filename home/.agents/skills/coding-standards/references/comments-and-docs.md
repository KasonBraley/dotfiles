# Comments and Go documentation

Every exported package, type, function, method, variable, and constant has a Go doc comment at its original declaration. A concise comment is sufficient when it states the sharpest caller-visible fact the signature cannot show. Use additional prose only for further constraints, expected failures, side effects, ownership, invariants, units, ordering, cancellation, concurrency safety, trade-offs, or non-obvious domain rules.

Start an exported declaration's comment with its name, as Go tooling expects. Package comments begin `Package name` and live in one owning file, commonly `doc.go` when substantial. Document embedded or promoted API where its locally relevant contract differs; aliases and forwarding declarations rely on the owner's documentation when no behavior changes.

Names, public documentation, UI copy, and rendered errors use durable vocabulary appropriate to their audience. Include ordinary domain phrases readers are likely to search for when those phrases differ from an identifier's spelling. Keep ticket names, migration phases, internal storage fields, framework mechanics, and planning language in internal implementation or planning material.

Document unexported code when safe maintenance depends on a non-obvious purpose, invariant, domain rule, side effect, trade-off, synchronization rule, or safety justification. Comments explain why or the contract; code explains how.

```go
// ParseEmailAddress parses and validates an email address received at an
// external boundary. It returns InvalidEmailAddress when input is malformed.
func ParseEmailAddress(input string) (EmailAddress, error)
```

Document non-obvious fields where their semantics extend beyond names and types:

```go
// RequestOptions bounds and identifies an outbound request.
type RequestOptions struct {
    // Timeout is the total request budget, including retries.
    Timeout time.Duration

    // CorrelationID is forwarded unchanged to downstream services.
    CorrelationID CorrelationID
}
```

Use `Deprecated:` in the declaration's doc paragraph and name the replacement. Describe expected errors in the operation's outcomes and panic behavior only when panic is an intentional caller-visible contract. Keep TODOs actionable and owned according to repository convention.

## Completion check

Every exported declaration has useful Go documentation at its original owner; concise comments state the sharpest fact the signature cannot show and longer comments earn their detail; package docs and deprecations follow Go conventions; non-obvious fields, invariants, synchronization, and internal behavior are documented; expected errors and intentional panic contracts are truthful; comments add meaning beyond the code and include searchable domain phrases; and public language uses durable, audience-appropriate vocabulary.
