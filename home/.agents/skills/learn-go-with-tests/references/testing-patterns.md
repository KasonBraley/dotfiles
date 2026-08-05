# Go testing patterns

Read this reference when a slice needs a concrete test shape, helper, table, error
assertion, benchmark, injected dependency, or test double.

## Basic tests

Keep the test readable as a specification and derive `want` independently from the
implementation.

```go
func TestAdd(t *testing.T) {
	got := Add(2, 2)
	want := 4

	if got != want {
		t.Errorf("Add(2, 2) = %d, want %d", got, want)
	}
}
```

Test files end in `_test.go`; test functions start with `Test` and accept `*testing.T`.
Use `%q` for strings, `%d` for integers, `%v` for general values, and `%T` when the
type is relevant. Put inputs in failure messages so a failing case is diagnosable.

Tests assert behavior, not implementation detail. Avoid private functions, struct
layout, unobservable call order, SQL strings, and incidental markup. Several assertions
are appropriate when they jointly establish one behavior; split tests when the
behaviors or failure diagnosis differ.

## Helpers and subtests

A reusable helper accepts `testing.TB` and calls `t.Helper()` so failures point at the
test that called it.

```go
func assertNoError(t testing.TB, err error) {
	t.Helper()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}
```

Use subtests to name independent scenarios and make one case runnable:

```go
func TestHello(t *testing.T) {
	t.Run("named person", func(t *testing.T) {
		got := Hello("Chris")
		if got != "Hello, Chris" {
			t.Errorf("Hello(%q) = %q, want %q", "Chris", got, "Hello, Chris")
		}
	})

	t.Run("empty name uses the default", func(t *testing.T) {
		got := Hello("")
		if got != "Hello, World" {
			t.Errorf("Hello(\"\") = %q, want %q", got, "Hello, World")
		}
	})
}
```

## Table-driven tests

Use a table when cases share the same setup, action, and assertion. Name fields and
cases so failures explain the behavior. On Go 1.22 and later, range variables are
per-iteration; keep the closure simple.

```go
func TestAdd(t *testing.T) {
	tests := []struct {
		name string
		a, b int
		want int
	}{
		{name: "positive", a: 2, b: 3, want: 5},
		{name: "negative", a: -1, b: -2, want: -3},
		{name: "zero", a: 0, b: 5, want: 5},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if got := Add(tc.a, tc.b); got != tc.want {
				t.Errorf("Add(%d, %d) = %d, want %d", tc.a, tc.b, got, tc.want)
			}
		})
	}
}
```

A table with many optional fields, flags, or divergent setup is a design signal.
Split it into focused tests. A table should make a new behavior easy to add, not hide
the behavior behind a framework.

## Examples and benchmarks

Examples are compiled, executed, and published as documentation when they include an
`Output` comment:

```go
func ExampleAdd() {
	fmt.Println(Add(1, 5))
	// Output: 6
}
```

Benchmarks measure a specific question rather than serving as correctness tests. Keep
setup outside `b.Loop()` and use `-benchmem` when allocations matter:

```go
func BenchmarkRepeat(b *testing.B) {
	for b.Loop() {
		Repeat("a")
	}
}
```

Use a benchmark to compare a change and keep the faster implementation only when
measurements and required behavior support it. Run with:

```bash
go test -bench=. -benchmem ./path/to/package
```

## Errors and edge behavior

Exercise both successful and unsuccessful outcomes. For a successful operation, assert
that the error is nil before using its result. For a failure, assert the error category
or type that callers rely on:

```go
if !errors.Is(err, ErrInsufficientFunds) {
	t.Fatalf("got error %v, want %v", err, ErrInsufficientFunds)
}
```

Use `errors.Is` and `errors.As` when errors may be wrapped. Compare exact error text
only when the text is a documented user-facing contract. Export a sentinel or custom
error type when callers need to classify the failure; otherwise return a useful
wrapped error without forcing an API commitment.

Use `t.Fatal` for a prerequisite that makes the rest of the test unsafe or meaningless;
use `t.Error` when later assertions can still provide useful information.

Select edge cases from the domain rather than from a ritual list. Typical boundaries
include empty and nil collections, zero values, minimum and maximum values, malformed
input, duplicate input, cancellation, deadlines, partial I/O, and dependency errors.
For collections, use type-safe helpers such as `slices.Equal` or `maps.Equal` where
they fit. Compare only the fields that are part of the behavior under test.

## Designing testable Go code

Testing difficulty is design feedback. Prefer:

- Concrete production types and small interfaces discovered at the consuming seam.
- The smallest interface a consumer needs, defined by that consumer.
- Dependency injection through parameters or constructors instead of package globals.
- Standard interfaces at effect boundaries: `io.Writer`, `io.Reader`, `fs.FS`, and
  `context.Context`.
- Public behavior tests over tests that require exporting private implementation details.
- A useful zero value and direct control flow, which make fixtures smaller.

Separate what is written from where it is written:

```go
func Greet(w io.Writer, name string) error {
	_, err := fmt.Fprintf(w, "Hello, %s", name)
	return err
}

func TestGreet(t *testing.T) {
	var got bytes.Buffer
	if err := Greet(&got, "Chris"); err != nil {
		t.Fatal(err)
	}
	if got.String() != "Hello, Chris" {
		t.Errorf("got %q, want %q", got.String(), "Hello, Chris")
	}
}
```

The production caller can pass `os.Stdout`; the test controls the writer without
capturing process-global output. Apply the same boundary to clocks, HTTP clients,
filesystems, and other effects when the behavior needs control.

## Test doubles

Use these terms precisely:

- A **stub** returns predetermined data or errors.
- A **spy** records calls for an assertion.
- A **mock** enforces an expected interaction, often failing on an unexpected call.
- A **fake** is a lightweight working implementation, commonly in memory.
- A **contract** is a reusable test suite that both fake and real implementations pass.

Choose the simplest double that creates meaningful confidence. A stub is appropriate
for a narrow error path; a spy is appropriate when an interaction is itself the
contract; a fake is appropriate when state across calls and final state express the
behavior more clearly. A real dependency belongs in an integration or acceptance test
when its behavior is what must be verified.

A growing fixture, many collaborators, or repeated interaction assertions signals a
boundary problem. Reconsider the interface and test final observable state before
adding another mock. A small struct or standard-library type is often clearer than a
mocking framework.

### Contracts for fakes

When a fake models a meaningful external dependency, give it a contract and run that
contract against both implementations. Keep the contract focused on behavior callers
rely on:

```go
type Store interface {
	Save(context.Context, Item) error
	Find(context.Context, string) (Item, error)
}

func storeContract(t *testing.T, newStore func(testing.TB) Store) {
	t.Helper()
	ctx := context.Background()
	store := newStore(t)

	item := Item{ID: "one"}
	if err := store.Save(ctx, item); err != nil {
		t.Fatal(err)
	}
	got, err := store.Find(ctx, item.ID)
	if err != nil {
		t.Fatal(err)
	}
	if got.ID != item.ID {
		t.Fatalf("got ID %q, want %q", got.ID, item.ID)
	}
}
```

Run the contract against the real dependency to validate the assumption, then against
the fake to keep local tests honest. Use a small decorator or stub for one forced
failure rather than weakening the contract for an unhappy path.
