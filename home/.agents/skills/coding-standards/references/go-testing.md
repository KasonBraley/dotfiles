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

Test pure time-based policy with concrete timestamps.
Never introduce a clock interface. Use the std libraries synctest package to better test time without sleeping for real time.
Inject deterministic randomness when output or retry jitter is under test.
Run focused tests under `go test -race` for changed synchronization or goroutine ownership when practical.
Use leak detection already established by the repository; otherwise prove shutdown with explicit joins and bounded test deadlines.

For retry tests, also read [`scheduling-and-retry.md`](scheduling-and-retry.md).

## Completion check

The completion check in [`testing.md`](testing.md) passes; tests use the standard runtime and repository conventions; contexts and concurrent work have test-owned lifetimes; temporal and concurrent tests use explicit synchronization; observable cancellation and cleanup are asserted; race-sensitive changes receive race coverage when practical; and every matching branch pointer above has been followed.
