# Go testing

Apply the coverage and test-level policy in [`testing.md`](testing.md) to every Go test. This reference owns Go runtime, lifecycle, synchronization, time, and race behavior.

Read every matching testing branch:

- Assertions, helpers, subtests, tables, examples, benchmarks, edge cases, properties, fuzzing, compile-time behavior, or test doubles: [`go-testing-patterns.md`](go-testing-patterns.md).
- HTTP, filesystems, concurrent streams or consumers, processes, containers, or complete user journeys: [`go-testing-boundaries.md`](go-testing-boundaries.md).

## Runtime and lifecycle

- Use the standard `testing` package by default.
- Use `t.Context()` when supported by the repository's Go version; otherwise derive cancellation from a test-owned context.
- Register cleanup for test-owned resources with `t.Cleanup()`.
- Run independent subtests in parallel only when all fixtures and environment are isolated.
- Assert cancellation, goroutine exit, and cleanup when they are observable parts of the contract.

The active test-first workflow owns red-green sequencing.
For Go, run the smallest focused command, such as `go test -run '^TestName$' ./path/to/package`.
An undefined identifier is an initial red; after adding only the compile-time shape, prefer an assertion failure so the expectation itself is exercised.

## Explicit synchronization

- Use channels for one-shot readiness or completion signals.
- Use `sync.WaitGroup` or `errgroup` to join known goroutines.
- Use mutex-protected recording state for concurrent observations.
- Use atomics only for simple independent state with a documented invariant.
- Coordinate through an existing lifecycle, status, or result interface.

Never use `time.Sleep` to guess readiness. A real-time test is appropriate only when timing itself is the integration behavior and has generous, bounded tolerances.

## Time, randomness, and race behavior

This section owns time-control selection for tests:

| Behavior | Control |
| --- | --- |
| Pure time policy | Pass concrete timestamps to the domain calculation. |
| Self-contained concurrent work on Go 1.25+ | Use `testing/synctest.Test`; create participating goroutines and synchronization inside its bubble. |
| Real network/process integration, or older Go targets | Use explicit synchronization and bounded deadlines; use real elapsed time only when timing is the contract. |
| Production policy needs an alternate time source | Use the earned capability described in [`resources-and-process-effects.md`](resources-and-process-effects.md). |

A synctest bubble does not virtualize external processes or real socket I/O. On Go 1.27+, `httptest.NewTestServer` provides an in-memory network for compatible HTTP tests; otherwise use `net.Pipe` where suitable or test real I/O outside the bubble. Go 1.24's experimental synctest API requires an existing project opt-in; it is not the stable Go 1.25 API.

For an older target where elapsed-time tests would be impractical, reuse an established clock seam or consider a narrow time function at the existing owner and explain the need. Avoid a new clock service merely to replace an already-testable timestamp calculation. Inject deterministic randomness for non-security policy such as retry jitter; security-sensitive randomness follows [`resources-and-process-effects.md`](resources-and-process-effects.md).
Run focused tests under `go test -race` for changed synchronization or goroutine ownership when practical.
Use leak detection already established by the repository; otherwise prove shutdown with explicit joins and bounded test deadlines.

For retry tests, also read [`scheduling-and-retry.md`](scheduling-and-retry.md).

## Completion check

The scoped checklist covers test-owned lifetimes, applicable time-control selection, observable cancellation/cleanup, and race coverage or its blocker. Coverage breadth remains owned by [`testing.md`](testing.md).
