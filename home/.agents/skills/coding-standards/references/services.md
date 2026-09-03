# Go services

Apply [`modules-services-and-adapters.md`](modules-services-and-adapters.md) for ownership and adapter decisions.

Treat a service as an **authority seam**: a cohesive capability that owns policy, I/O, state, or runtime resources.
The concrete implementation owner keeps its constructor and applicable production or reusable test implementations with that implementation.

## Service test

A real service owns at least one meaningful capability:

- authority over persistence, credentials, external I/O, runtime resources, configuration, time, randomness, or lifecycle;
- cohesive side-effect sequencing or policy reused across entrypoints;
- state or behavior with real production and test/runtime variation.

Prefer an existing standard-library capability or concrete value before defining an application service. Keep these as values or pure packages:

- parsed domain inputs and per-call request data;
- deterministic calculations, parsers, and constructors;
- options that select policy for one call;
- framework values confined to their adapter;
- wrappers that only rename or forward another service.

An interface seam represents real ownership or variability in production or a necessary consumer-owned test seam.
When injection is the only need, pass a concrete value or function if that is the complete capability.
Record production evidence for the interface-or-concrete decision and the rejected alternative.

## Authority and dependencies

The consuming application package owns the interface. A technology adapter owns its concrete type and constructor only after translation, mechanics, reuse, or real implementation variation earns that seam. The composition root selects top-level implementations.

Construct stable runtime dependencies once and store them on the concrete service. Pass request- or operation-scoped `context.Context` to each method; never store it. Authorization evidence, scoped handles, and operation-specific capability values remain explicit inputs when they are part of the request or domain contract.

## Package shape

Follow the repository's established equivalent of this shape:

```go
// Store is the user persistence capability required by Service.
type Store interface {
    FindByID(context.Context, UserID) (User, error)
}

type Service struct {
    users Store
}

func NewService(users Store) *Service {
    return &Service{users: users}
}

func (s *Service) GetUser(ctx context.Context, id UserID) (User, error) {
    user, err := s.users.FindByID(ctx, id)
    if err != nil {
        return User{}, fmt.Errorf("get user: %w", err)
    }
    return user, nil
}
```

Use concrete constructor parameters unless the consumer needs multiple implementations or a test seam.
Define small interfaces where they are consumed.
Return concrete implementations from constructors.
Validate required dependencies at construction when nil would make later execution invalid; otherwise make the zero value useful.

Use functional options for several independent optional settings with stable defaults.
Use a config struct when settings are naturally validated together or commonly loaded from configuration.
For a stateful resource, prefer a domain object as the entry point so state and operations stay explicitly owned rather than spread across package globals.

Keep interfaces cohesive and domain-shaped. One-method interfaces are natural when one behavior is the capability. Do not add getters solely to expose dependencies or implementation state.

## Package surface and wiring

- Keep implementation types unexported unless callers need to configure or name them.
- Export constructors and domain-shaped operations, not wiring internals.
- Keep dependency construction at `main`, a server/worker constructor, or another explicit composition root.
- Keep runtime wiring flat, named, and easy to trace.

## Operation boundaries

Public service methods expose cohesive domain operations. Add concise operation context when wrapping errors and structured operation names to logs and spans. Keep orchestration focused on sequence and decisions; move domain calculations and protocol mechanics to their owners. Apply retry, timeout, cleanup, and result translation once at the narrowest owning boundary.

## Test implementations

When tests or reusable implementations change, apply the double-selection and fidelity rules in [`go-testing-patterns.md`](go-testing-patterns.md).
The concrete implementation owner keeps reusable production and test implementations with that implementation.

## Completion check

Complete when the service-or-value decision cites real ownership or variability and the rejected alternative; every interface, constructor, expected error, method, production implementation, and reusable test implementation has one owner; interfaces are consumer-owned and minimal; stable dependencies are captured at construction while contexts remain method inputs; construction and cleanup lifetimes are explicit; long-lived work is owned; public operations have operation-level diagnostics; package surfaces expose only intended API; and tests exercise the production interface at the fidelity required by its observable contract.
