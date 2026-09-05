# Go services

Apply [`modules-services-and-adapters.md`](modules-services-and-adapters.md) for ownership and adapter decisions.

Treat a service as an **authority seam**: a cohesive capability that owns policy, I/O, state, or runtime resources.
The concrete implementation owner keeps its constructor and applicable production or reusable test implementations with
that implementation.

## Service test

A real service owns at least one meaningful capability:

- authority over persistence, credentials, external I/O, runtime resources, configuration, time, randomness, or
  lifecycle;
- cohesive side-effect sequencing or policy reused across entrypoints;
- state or behavior with real production and test/runtime variation.

Prefer an existing standard-library capability or concrete value before defining an application service. Keep these as
values or pure packages:

- parsed domain inputs and per-call request data;
- deterministic calculations, parsers, and constructors;
- options that select policy for one call;
- framework values confined to their adapter;
- wrappers that only rename or forward another service.

An interface seam represents real ownership or variability in production or a necessary consumer-owned test seam.
When injection is the only need, pass a concrete value or function if that is the complete capability.
Explain consequential interface-or-concrete decisions; routine injection needs no written alternatives ledger.

## Authority and dependencies

The consuming application package owns the interface. A technology adapter owns its concrete type and constructor only
after translation, mechanics, reuse, or real implementation variation earns that seam. The composition root selects
top-level implementations.

Construct stable runtime dependencies once and store them on the concrete service. Context lifetime follows
[`go-safety.md`](go-safety.md#context-and-concurrency-safety). Authorization evidence, scoped handles, and
operation-specific capability values remain explicit inputs when they are part of the request or domain contract.

## Package shape

Follow the repository's established equivalent of this shape:

```go
// In the account application package; domain types are omitted here.
// Store supplies the persistence operations needed to deactivate an account.
type Store interface {
    Find(context.Context, AccountID) (Account, error)
    Save(context.Context, Account) error
}

// Service enforces account lifecycle policy.
type Service struct {
    accounts Store
}

// New constructs a service with a required account store.
func New(accounts Store) (*Service, error) {
    if accounts == nil {
        return nil, errors.New("account service: missing store")
    }
    return &Service{accounts: accounts}, nil
}

// Deactivate applies the domain transition and persists it.
func (s *Service) Deactivate(ctx context.Context, id AccountID) error {
    account, err := s.accounts.Find(ctx, id)
    if err != nil {
        return fmt.Errorf("deactivate account: %w", err)
    }
    deactivated, err := account.Deactivate()
    if err != nil {
        return err
    }
    return s.accounts.Save(ctx, deactivated)
}
```

The sketch assumes `Save` enforces the required concurrency/version contract; it does not imply a check-then-write
sequence is atomic. Use concrete constructor parameters unless the consumer needs multiple implementations or a test
seam.
Define small interfaces where they are consumed.
Return concrete implementations from constructors.
Validate required dependencies at construction when nil would make later execution invalid; otherwise make the zero
value useful.

Use functional options for several independent optional settings with stable defaults.
Use a config struct when settings are naturally validated together or commonly loaded from configuration.
For a stateful resource, prefer a domain object as the entry point so state and operations stay explicitly owned rather
than spread across package globals.

Keep interfaces cohesive and domain-shaped. One-method interfaces are natural when one behavior is the capability. Do
not add getters solely to expose dependencies or implementation state.

## Package surface and wiring

- Keep implementation types unexported unless callers need to configure or name them.
- Export constructors and domain-shaped operations, not wiring internals.
- Keep dependency construction at `main`, a server/worker constructor, or another explicit composition root.
- Keep runtime wiring flat, named, and easy to trace.

## Operation boundaries

Public service methods expose cohesive domain operations. Add concise operation context when wrapping errors and
structured operation names to logs and spans. Keep orchestration focused on sequence and decisions; move domain
calculations and protocol mechanics to their owners. Apply retry, timeout, cleanup, and result translation once at the
narrowest owning boundary.

## Test implementations

When tests or reusable implementations change, apply the double-selection and fidelity rules in
[`go-testing-patterns.md`](go-testing-patterns.md).

## Completion check

The checklist identifies service ownership, earned interfaces, stable dependencies, intended exports, and operation
contracts. Consequential decisions have a rationale. Resource, context, error, and test behavior satisfy their owning
references rather than a second service-specific policy.
