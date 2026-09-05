# Go testing patterns

Use these patterns when selecting assertions, helpers, subtests, tables, examples, benchmarks, edge cases, properties, fuzzing, compile-time checks, seams, or test doubles. Apply the coverage policy in [`testing.md`](testing.md).

## Basic tests and assertions

Derive expected values independently from the implementation. Test files end in `_test.go`; test functions begin with `Test` and accept `*testing.T`. Use `%q` for strings, `%d` for integers, `%v` for general values, and `%T` when type matters. Include inputs in failure messages.

Choose `package foo_test` when the public contract must be exercised as an external consumer. Choose `package foo` when package-level behavior cannot otherwise be observed. Do not invent `_internal_test.go` as a special category; Go recognizes the `_test.go` suffix, while the package declaration determines the test boundary.

Assert observable behavior rather than private functions, struct layout, unobservable call order, SQL strings, or incidental markup. Multiple assertions are useful when they jointly establish one behavior; split the test when behaviors or failure diagnosis differ. Tautological tests that restate or execute the implementation to derive the expected value provide no independent confidence.

Use the repository's established assertion or diff library; otherwise prefer clear standard-library checks over adding a dependency. A reusable helper accepts `testing.TB` and calls `t.Helper()` so failures point to its caller. Use `t.Fatal` when a failed prerequisite makes later work unsafe or meaningless; use `t.Error` when later assertions can still add useful evidence.

Use subtests to isolate independent scenarios and make one scenario directly runnable. Use a table only when cases share setup, action, and assertion. Ensure each failure identifies its scenario and behavior. A table with many optional fields, flags, or divergent setup is a signal to split focused tests. On Go 1.22 and later, range variables are per-iteration; still keep subtest closures simple.

## Examples and benchmarks

Examples with an `Output` comment are compiled, executed, and published as documentation:

```go
func ExampleAdd() {
    fmt.Println(Add(1, 5))
    // Output: 6
}
```

A benchmark answers a specific performance question rather than proving correctness. When supported by the repository's Go version, keep setup outside `b.Loop()` and use `-benchmem` when allocations matter:

```go
func BenchmarkRepeat(b *testing.B) {
    for b.Loop() {
        Repeat("a")
    }
}
```

Compare changes under equivalent conditions and retain an optimization only when measurements and required behavior support it.

## Errors and edge behavior

Exercise success and failure. On success, check the error before using the result. On failure, assert only the stable category or type callers rely on, using `errors.Is` or `errors.As` for wrapped errors. Compare exact text only when it is a documented user-facing contract.

Choose edge cases from the domain. Relevant boundaries commonly include empty and nil collections, zero values, minima and maxima, malformed or duplicate input, cancellation, deadlines, partial I/O, and dependency errors. Use type-safe helpers such as `slices.Equal` or `maps.Equal` where supported and appropriate, and compare only fields promised by the behavior.

## Property and fuzz tests

Assess property or fuzz testing for every changed invariant, transition, normalization, equivalence, ordering, idempotence, and roundtrip. Add fuzz tests when generated inputs cover meaningful cases beyond a short example list. Apply this especially to parsers, smart constructors, custom scalar types, state machines, serialization, and protocol decoders.

Use Go's native fuzzing support when the repository's Go version supports it. Seed the corpus with valid, boundary, malformed, and regression examples. Generated valid data passes through the same parsers, constructors, and invariants as production values. Keep reusable generators beside the owning domain package and deterministic from the supplied test or fuzz seed.

## Compile-time behavior

When generic inference, interface satisfaction, method sets, or API assignability is public behavior, add compile-time assertions or ordinary call sites without rescue conversions. Use a compile-time interface assertion when a reusable implementation's conformance is important. Verify both accepted use and, where tooling supports it, rejected use through repository-established compile-fail tests.

## Testable boundaries

Testing friction is design evidence. Prefer concrete production types and small interfaces discovered at the consuming seam. Inject dependencies through parameters or constructors rather than globals. Use standard capabilities such as `io.Reader`, `io.Writer`, `fs.FS`, and `context.Context` where they are the actual effect boundary. Separate what is done from where the effect goes; for example, accept an `io.Writer` instead of capturing process-global output.

Apply the same approach to HTTP clients, filesystems, and other effects only when behavior requires control. Time and randomness follow the selection policy in [`go-testing.md`](go-testing.md#time-randomness-and-race-behavior). Keep a useful zero value and direct control flow so fixtures remain small.

## Test doubles

Use these terms precisely:

- A **stub** returns predetermined data or errors.
- A **spy** records calls for later assertion.
- A **mock** enforces expected interaction and often fails on unexpected calls.
- A **fake** is a lightweight working implementation, commonly in memory.
- A **contract** is a reusable suite that both fake and real implementations pass.

Choose the simplest double that creates meaningful confidence. Use a stub for a narrow error path, a spy when an interaction is itself the contract, a fake when state across calls best expresses behavior, and a real dependency when its behavior must be verified. Avoid monkey-patching and generated mocks that merely mirror interfaces. A growing fixture, many collaborators, or repeated interaction assertions indicates a boundary problem; reconsider the interface and final observable state before adding another mock. Prefer a small struct or standard-library type to a mocking framework.

Keep a narrow one-off fake local to its test. Export a reusable static or recording implementation only when its complete behavior is useful across packages; otherwise keep it in internal test support or the owning package's external test package.

Use a real local substitute when queries, schema, serialization, transactions, or protocol behavior matter. Call an implementation in-memory only when it faithfully preserves the complete observable contract under test. When a fake models a meaningful external dependency, run one focused contract against both the real implementation and the fake. Keep the contract to behavior callers rely on. Use a small decorator or stub for one forced failure rather than weakening the shared contract.

A reusable implementation exposes test controls on its concrete type while crossing the same consumer-owned interface as production code:

```go
type RecordingNotifier struct {
    mu      sync.Mutex
    sent    []Message
    nextErr error
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

Keep production branches, exports, flags, and behavior determined by production needs. When no dependency interface exists, test through the existing public API or a faithful inert harness rather than expanding production API solely for tests. Make unsupported fake behavior fail loudly.

## Completion check

Expectations are independent and diagnosable; test structure matches behavioral structure; examples and benchmarks answer their intended questions; edge and error assertions cover stable contracts; changed properties and compile-time behavior have applicable coverage; effect seams are earned; every double has the simplest truthful role; reusable fakes remain faithful through a contract shared with the real implementation when needed; and production surfaces remain determined by production needs.
