# Go Design Reference

## Packages

Start with one package until a boundary clarifies ownership, creates a reusable unit, or isolates an independently testable concern. Name packages for their domain or capability (`billing`, `auth`, `slug`), not an architectural layer (`service`, `repository`, `controller`).

Keep dependency direction obvious. The composition root—usually `main`—wires packages together. A cycle means the boundary or ownership is wrong. Place code in `internal` when compiler-enforced import privacy is useful. Avoid catch-all packages such as `util`, `helpers`, and `common`; move behavior to the package that owns it.

Keep tightly coupled artifacts together: handlers with the templates they render, a type with its validation, and a domain operation with its data vocabulary.

## APIs and types

Design from call sites. Start concrete and extract an interface only when a consumer needs substitution or a narrower boundary. Define that interface beside the consumer and include only the methods it calls. Return concrete types so callers retain the full API.

Use a domain object as the entry point for a stateful resource:

```go
v, err := vault.Open(path)
if err != nil {
    return fmt.Errorf("opening vault: %w", err)
}
people, err := v.People()
```

Prefer instance state over package globals in reusable packages. Keep state fresh and explicit; add caching only with a measured need and a defined invalidation policy.

A type's zero value should work when zero has a safe, unsurprising meaning. Otherwise use a constructor that establishes invariants. Use functional options when there are several independent optional settings with stable defaults; use a config struct when settings are naturally validated together or commonly loaded from configuration.

## Interfaces

Interfaces model behavior needed by a consumer, not a family tree:

```go
type UserFetcher interface {
    FetchUser(context.Context, string) (*User, error)
}

type Processor struct {
    users UserFetcher
}
```

Keep interfaces small. Accept `io.Reader`, `io.Writer`, or another established capability when that is the actual requirement. Avoid speculative interfaces colocated with their only implementation.

## Generics

Use generics for one algorithm that genuinely serves multiple concrete types:

```go
func Map[S, T any](in []S, f func(S) T) []T {
    out := make([]T, len(in))
    for i, v := range in {
        out[i] = f(v)
    }
    return out
}
```

Use constraints that express operations the algorithm performs (`comparable`, `cmp.Ordered`, or a narrow type set). Prefer domain-specific concrete APIs over generic repositories, services, and base types. Begin concrete; generalize when repeated implementations demonstrate the common algorithm.

## Dependencies

Check the standard library first. A dependency should remove meaningful complexity, have a narrow role, and justify its maintenance and supply-chain cost. Follow the repository's existing dependency choices when they already solve the problem.
