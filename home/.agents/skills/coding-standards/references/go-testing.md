# Go testing

Apply the test levels, observable-outcome rules, and completion check in [`testing.md`](testing.md) to every Go test. This reference adds Go runtime, time, synchronization, helper, and fake rules.

Read every matching testing branch:

- Test-first feature or bug-fix work and behavior-preserving refactoring: [`go-test-first.md`](go-test-first.md).
- Assertions, subtests, tables, examples, benchmarks, edge cases, or test doubles: [`go-testing-patterns.md`](go-testing-patterns.md).
- HTTP, filesystems, concurrency, processes, containers, or complete user journeys: [`go-testing-boundaries.md`](go-testing-boundaries.md).

## Defaults

- Use the standard `testing` package by default.
- Use table tests when cases share setup and assertion shape; use separate tests when behavior or setup differs materially.
- Mark helpers with `t.Helper()` and register cleanup with `t.Cleanup()`.
- Use `t.Context()` when supported by the repository's Go version; otherwise derive cancellation from a test-owned context.
- Use `t.TempDir()` for filesystem isolation and `httptest.Server` for HTTP protocol boundaries.
- Run independent subtests in parallel only when all fixtures and environment are isolated.
- Assert cancellation, goroutine exit, and cleanup when observable parts of the contract change.

```go
func TestServiceFindsUser(t *testing.T) {
    users := newInMemoryUserStore(User{ID: UserID("u1")})
    service := NewService(users)

    got, err := service.Find(t.Context(), UserID("u1"))
    if err != nil {
        t.Fatalf("Find() error = %v", err)
    }
    if diff := cmp.Diff(User{ID: UserID("u1")}, got); diff != "" {
        t.Fatalf("Find() mismatch (-want +got):\n%s", diff)
    }
}
```

Use the repository's established assertion/diff library; otherwise prefer clear standard-library checks over adding a dependency.

## Explicit synchronization

- Use channels for one-shot readiness or completion signals.
- Use `sync.WaitGroup`/`errgroup` to join known goroutines.
- Use mutex-protected recording state for concurrent observations.
- Use atomics only for simple independent state with a documented invariant.
- Coordinate through an existing lifecycle, status, or result interface. Keep test-only controls on the fake or harness, not the production interface.

Never use `time.Sleep` to guess readiness. A real-time test is appropriate only when timing itself is the integration behavior and has generous, bounded tolerances.

## Reusable test implementations

Read [`services.md`](services.md) before designing a reusable fake. When reusable state, failure injection, or observation belongs to a real service seam, implement the same consumer-owned interface and expose controls on the concrete test type.

```go
type RecordingNotifier struct {
    mu       sync.Mutex
    sent     []Message
    nextErr  error
}

func (n *RecordingNotifier) Send(_ context.Context, message Message) error {
    n.mu.Lock()
    defer n.mu.Unlock()
    if n.nextErr != nil {
        err := n.nextErr
        n.nextErr = nil
        return err
    }
    n.sent = append(n.sent, message)
    return nil
}

func (n *RecordingNotifier) SentMessages() []Message {
    n.mu.Lock()
    defer n.mu.Unlock()
    return slices.Clone(n.sent)
}
```

Keep a tiny one-off stub in its test. Use compile-time interface assertions when a reusable implementation's conformance is important. Avoid elaborate general-purpose mock frameworks; explicit fakes should fail loudly for unsupported behavior.

## Time, randomness, and race behavior

Test pure time-based policy with concrete timestamps. Introduce a small clock/timer seam only when code must control waiting or current time. Inject deterministic randomness when output or retry jitter is under test. Run focused tests under `go test -race` for changed synchronization or goroutine ownership when practical. Use leak detection already established by the repository; otherwise prove shutdown with explicit joins and bounded test deadlines.

For retry tests, also read [`scheduling-and-retry.md`](scheduling-and-retry.md).

## Completion check

The completion check in [`testing.md`](testing.md) passes; tests use the standard runtime and repository conventions;
helpers, cleanup, contexts, files, and servers have test-owned lifetimes; temporal and concurrent tests use explicit synchronization;
reusable fakes cross the production interface while controls remain on the concrete test type;
observable cancellation and cleanup are asserted; race-sensitive changes receive race coverage when practical;
and every applicable service, retry, configuration, and concurrency pointer has been followed.
