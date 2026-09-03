# Go testing patterns

Use these patterns when selecting assertions, subtests, tables, examples, benchmarks, edge cases, seams, or test doubles. Apply [`testing.md`](testing.md) and [`go-testing.md`](go-testing.md) first.

## Basic tests and assertions

Derive expected values independently from the implementation. Test files end in `_test.go`; test functions begin with `Test` and accept `*testing.T`. Use `%q` for strings, `%d` for integers, `%v` for general values, and `%T` when type matters. Include inputs in failure messages.

Assert observable behavior rather than private functions, struct layout, unobservable call order, SQL strings, or incidental markup. Multiple assertions are useful when they jointly establish one behavior; split the test when behaviors or failure diagnosis differ. Tautological tests that restate or execute the implementation to derive the expected value provide no independent confidence.

A reusable helper accepts `testing.TB` and calls `t.Helper()` so failures point to its caller. Use `t.Fatal` when a failed prerequisite makes later work unsafe or meaningless; use `t.Error` when later assertions can still add useful evidence.

Use subtests to name independent scenarios and make one scenario directly runnable. Use a table only when cases share setup, action, and assertion. Name fields and cases so a failure explains behavior. A table with many optional fields, flags, or divergent setup is a signal to split focused tests. On Go 1.22 and later, range variables are per-iteration; still keep subtest closures simple.

## Examples and benchmarks

Examples with an `Output` comment are compiled, executed, and published as documentation:

```go
func ExampleAdd() {
    fmt.Println(Add(1, 5))
    // Output: 6
}
```

A benchmark answers a specific performance question rather than proving correctness. Keep setup outside `b.Loop()` and use `-benchmem` when allocations matter:

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

Choose edge cases from the domain. Relevant boundaries commonly include empty and nil collections, zero values, minima and maxima, malformed or duplicate input, cancellation, deadlines, partial I/O, and dependency errors. Use type-safe helpers such as `slices.Equal` or `maps.Equal` where appropriate, and compare only fields promised by the behavior.

## Testable boundaries

Testing friction is design evidence. Prefer concrete production types and small interfaces discovered at the consuming seam. Inject dependencies through parameters or constructors rather than globals. Use standard capabilities such as `io.Reader`, `io.Writer`, `fs.FS`, and `context.Context` where they are the actual effect boundary. Separate what is done from where the effect goes; for example, accept an `io.Writer` instead of capturing process-global output.

Apply the same approach to clocks, HTTP clients, filesystems, and other effects only when behavior requires control. Keep a useful zero value and direct control flow so fixtures remain small.

## Test doubles

Use these terms precisely:

- A **stub** returns predetermined data or errors.
- A **spy** records calls for later assertion.
- A **mock** enforces expected interaction and often fails on unexpected calls.
- A **fake** is a lightweight working implementation, commonly in memory.
- A **contract** is a reusable suite that both fake and real implementations pass.

Choose the simplest double that creates meaningful confidence. Use a stub for a narrow error path, a spy when an interaction is itself the contract, a fake when state across calls best expresses behavior, and a real dependency when its behavior must be verified. A growing fixture, many collaborators, or repeated interaction assertions indicates a boundary problem; reconsider the interface and final observable state before adding another mock. Prefer a small struct or standard-library type to a mocking framework.

When a fake models a meaningful external dependency, run one focused contract against both the real implementation and the fake. Keep the contract to behavior callers rely on. Use a small decorator or stub for one forced failure rather than weakening the shared contract.

## Completion check

Expectations are independent and diagnosable; test structure matches behavioral structure; examples and benchmarks answer their intended questions; edge and error assertions cover stable contracts; effect seams are earned; every double has the precise simplest role; and reusable fakes remain faithful through a contract shared with the real implementation.
