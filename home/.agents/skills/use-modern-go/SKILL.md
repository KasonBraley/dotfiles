---
name: use-modern-go
description: Apply modern Go syntax guidelines based on project's Go version. Use when writing, modifying, or reviewing Go code.
---

# Modern Go Guidelines

## Detecting the Go Version

Detect once per owning module, not once per session. A repository may have one module,
nested modules, or a workspace with different versions.

1. Walk up from each changed file to its nearest owning `go.mod` and read the `go`
   directive. For a buildable package, this query from its directory also identifies
   the owner:
   ```sh
   go list -f '{{.Module.Path}} {{.Module.GoVersion}}' .
   ```
   `go list -m` without a module argument can list every workspace module; its output
   is not a file-owner query. If package loading fails, read the owning file directly.
2. Treat that module's declared version as the compatibility target. A newer installed
   toolchain, `toolchain` directive, or `go.work` version does not raise it. Account for
   deliberate per-file version build tags and ensure older targets retain their fallback.
3. If no module governs the file, inspect the repository's documented target and CI.
   If still unknown, ask the user which Go version to target in ordinary conversation.

## How to Use This Skill

State the target once when relevant to the decision; avoid repeated version announcements.
Use the task's design, implementation, or read-only review mode. Modernization is not
permission to expand the diff or raise the supported Go version.

Prefer applicable modern APIs when they simplify the changed code **and preserve its
behavior, ownership, and compatibility**. Existing wire formats, nil/empty distinctions,
aliasing, cancellation, and performance requirements take priority over mechanical
replacement. Check versioned standard-library documentation for API semantics; this list
is a chooser, not a requirement to use every feature. Experimental APIs require an
explicit project opt-in and a verified toolchain; an API's presence in a newer toolchain
alone does not establish target compatibility.

---

## Features by Go Version

### Go 1.0+

- `time.Since`: `time.Since(start)` instead of `time.Now().Sub(start)`

### Go 1.8+

- `time.Until`: `time.Until(deadline)` instead of `deadline.Sub(time.Now())`

### Go 1.13+

- `errors.Is`: `errors.Is(err, target)` instead of `err == target` (works with wrapped errors)

### Go 1.18+

- `any`: Use `any` instead of `interface{}`
- `bytes.Cut`: `before, after, found := bytes.Cut(b, sep)` instead of Index+slice
- `strings.Cut`: `before, after, found := strings.Cut(s, sep)`
- `strings.Clone`: `strings.Clone(s)` when an independent backing allocation is needed

### Go 1.19+

- `fmt.Appendf`: `buf = fmt.Appendf(buf, "x=%d", x)` instead of `[]byte(fmt.Sprintf(...))`
- `atomic.Bool`/`atomic.Int64`/`atomic.Pointer[T]`: Type-safe atomics instead of `atomic.StoreInt32`

```go
var flag atomic.Bool
flag.Store(true)
if flag.Load() { ... }

var ptr atomic.Pointer[Config]
ptr.Store(cfg)
```

### Go 1.20+

- `bytes.Clone`: `bytes.Clone(b)` to copy byte slice
- `strings.CutPrefix/CutSuffix`: `if rest, ok := strings.CutPrefix(s, "pre:"); ok { ... }`
- `errors.Join`: `errors.Join(err1, err2)` to combine multiple errors
- `context.WithCancelCause`: `ctx, cancel := context.WithCancelCause(parent)` then `cancel(err)`
- `context.Cause`: `context.Cause(ctx)` to get the error that caused cancellation

### Go 1.21+

**Built-ins:**
- `min`/`max`: `max(a, b)` instead of if/else comparisons
- `clear`: `clear(m)` to delete all map entries, `clear(s)` to zero slice elements

**slices package:**
- `slices.Contains`: `slices.Contains(items, x)` instead of manual loops
- `slices.Index`: `slices.Index(items, x)` returns index (-1 if not found)
- `slices.IndexFunc`: `slices.IndexFunc(items, func(item T) bool { return item.ID == id })`
- `slices.SortFunc`: `slices.SortFunc(items, func(a, b T) int { return cmp.Compare(a.X, b.X) })`
- `slices.Sort`: `slices.Sort(items)` for ordered types
- `slices.Max`/`slices.Min`: `slices.Max(items)` instead of manual loop
- `slices.Reverse`: `slices.Reverse(items)` instead of manual swap loop
- `slices.Compact`: `slices.Compact(items)` removes consecutive duplicates in-place
- `slices.Clip`: `slices.Clip(s)` removes unused capacity
- `slices.Clone`: `slices.Clone(s)` creates a copy

**maps package:**
- `maps.Clone`: `maps.Clone(m)` instead of manual map iteration
- `maps.Copy`: `maps.Copy(dst, src)` copies entries from src to dst
- `maps.DeleteFunc`: `maps.DeleteFunc(m, func(k K, v V) bool { return condition })`

**sync package:**
- `sync.OnceFunc`: `f := sync.OnceFunc(func() { ... })` instead of `sync.Once` + wrapper
- `sync.OnceValue`: `getter := sync.OnceValue(func() T { return computeValue() })`

**context package:**
- `context.AfterFunc`: `stop := context.AfterFunc(ctx, cleanup)` runs cleanup on cancellation
- `context.WithTimeoutCause`: `ctx, cancel := context.WithTimeoutCause(parent, d, err)`
- `context.WithDeadlineCause`: Similar with deadline instead of duration

### Go 1.22+

**Loops:**
- `for i := range n`: `for i := range len(items)` instead of `for i := 0; i < len(items); i++`
- Variables declared by the loop have per-iteration bindings. Assignment to pre-existing
  variables still shares them; captured pointers and referenced mutable data need their
  own ownership/synchronization policy.

**cmp package:**
- `cmp.Or`: `cmp.Or(flag, env, config, "default")` returns first non-zero value

```go
// Instead of:
name := os.Getenv("NAME")
if name == "" {
    name = "default"
}
// Use:
name := cmp.Or(os.Getenv("NAME"), "default")
```

**reflect package:**
- `reflect.TypeFor`: `reflect.TypeFor[T]()` instead of `reflect.TypeOf((*T)(nil)).Elem()`

**net/http:**
- Enhanced `http.ServeMux` patterns: `mux.HandleFunc("GET /api/{id}", handler)` with method and path params
- `r.PathValue("id")` to get path parameters

### Go 1.23+

- `maps.Keys(m)` / `maps.Values(m)` return iterators
- `slices.Collect(iter)` not manual loop to build slice from iterator
- `slices.Sorted(iter)` to collect and sort in one step

```go
keys := slices.Collect(maps.Keys(m))       // not: for k := range m { keys = append(keys, k) }
sortedKeys := slices.Sorted(maps.Keys(m))  // collect + sort
for k := range m { process(k) }           // direct map iteration needs no adapter
```

**time package**

- `time.Tick`: Use `time.Tick` freely — as of Go 1.23, the garbage collector can recover unreferenced tickers, even if they haven't been stopped. The Stop method is no longer necessary to help the garbage collector. There is no longer any reason to prefer NewTicker when Tick will do.

### Go 1.24+

- Prefer `t.Context()` as the test-lifetime parent. Derive a child with cancellation or
  a deadline when testing those behaviors or bounding a shorter operation.

  One exception to this rule is for cleanup functions running inside tests. Passing `t.Context()`
  to a function that runs on `t.Cleanup` would be immediately canceled and not run. For these, the
  recommended approach is to use a new context, preferably set with a timeout.

```go
t.Cleanup(func() {
    cleanupCtx, cancel := context.WithTimeout(context.Background(), 1 * time.Second)
    defer cancel()

    thing.Delete(cleanupCtx)
})
```

Before:
```go
func TestFoo(t *testing.T) {
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()
    result := doSomething(ctx)
}
```
After:
```go
func TestFoo(t *testing.T) {
    ctx := t.Context()
    result := doSomething(ctx)
}
```

- `omitzero` adds a distinct omission policy, not a replacement for `omitempty`.
  Choose tags using the encoded-contract rules in
  [`boundary-data.md`](../coding-standards/references/boundary-data.md#encoded-contracts).
  In `encoding/json` v1, both tags omit zero `time.Duration`; `omitzero` can omit zero
  `time.Time` and other structs. Non-nil empty slices/maps are omitted by `omitempty`
  but retained by `omitzero`. Preserve the wire contract and test nil, empty, zero, and
  populated values before changing a tag.

```go
type Response struct {
    Timeout time.Duration `json:"timeout,omitempty"` // omit numeric zero
    Updated time.Time     `json:"updated,omitzero"`   // omit zero time
    Items   []string      `json:"items,omitempty"`    // omit nil and empty slices
}
```

- `b.Loop()` not `for i := 0; i < b.N; i++` in benchmarks.
  Prefer `b.Loop()` for ordinary sequential benchmarks. Keep `b.RunParallel` for parallel
  benchmarks and preserve setup, timing, and allocation semantics when converting.

Before:
```go
func BenchmarkFoo(b *testing.B) {
    for i := 0; i < b.N; i++ {
        doWork()
    }
}
```
After:
```go
func BenchmarkFoo(b *testing.B) {
    for b.Loop() {
        doWork()
    }
}
```

- `strings.SplitSeq` not `strings.Split` when iterating.
  Prefer SplitSeq/FieldsSeq for one-pass iteration; retain a materialized slice when
  indexing, reuse, mutation, or the measured performance contract requires it.

Before:
```go
for _, part := range strings.Split(s, ",") {
    process(part)
}
```
After:
```go
for part := range strings.SplitSeq(s, ",") {
    process(part)
}
```
Also: `strings.FieldsSeq`, `bytes.SplitSeq`, `bytes.FieldsSeq`.

### Go 1.25+

- `wg.Go(fn)` not `wg.Add(1)` + `go func() { defer wg.Done(); ... }()`.
  Prefer `wg.Go()` for tasks owned by a WaitGroup; its callback must not let a panic
  escape. Preserve any supervision/recovery policy. Use `errgroup` when errors should
  cancel peers, and keep explicit Add/Done when tracking work not spawned here.

Before:
```go
var wg sync.WaitGroup
for _, item := range items {
    wg.Add(1)
    go func() {
        defer wg.Done()
        process(item)
    }()
}
wg.Wait()
```
After:
```go
var wg sync.WaitGroup
for _, item := range items {
    wg.Go(func() {
        process(item)
    })
}
wg.Wait()
```

### Go 1.26+

- `new(val)` not `x := val; &x` — returns pointer to any value.
  Go 1.26 extends new() to accept expressions, not just types.
  Type is inferred: new(0) → *int, new("s") → *string, new(T{}) → *T.
  Prefer `new(val)` when allocating an independent initialized value. Preserve `&x`
  when callers need the identity or later mutations of an existing variable. Keep
  conversions required for the intended type; `new(0)` is `*int`, not `*int64`.
  Common use case: struct fields with pointer types.

Before:
```go
timeout := 30
debug := true
cfg := Config{
    Timeout: &timeout,
    Debug:   &debug,
}
```
After:
```go
cfg := Config{
    Timeout: new(30),   // *int
    Debug:   new(true), // *bool
}
```

- `errors.AsType[T](err)` not `errors.As(err, &target)`.
  Prefer `errors.AsType` when the target error type is statically known. Keep `errors.As`
  when the target is supplied dynamically or the established API requires it.

Before:
```go
var pathErr *os.PathError
if errors.As(err, &pathErr) {
    handle(pathErr)
}
```
After:
```go
if pathErr, ok := errors.AsType[*os.PathError](err); ok {
    handle(pathErr)
}
```

### Go 1.27+

**Language:**

- Generic methods may declare their own type parameters. Prefer a generic method over a
  package-level generic function when the operation belongs in the receiver type's namespace.
  Interface methods cannot declare type parameters, and generic methods do not implement
  interface methods.

```go
type List[E any] []E

func (l List[E]) Apply[F any](f func(E) F) List[F] {
    result := make(List[F], len(l))
    for i, value := range l {
        result[i] = f(value)
    }
    return result
}
```

- Keyed struct literals may initialize promoted fields directly. Prefer the promoted field key
  over spelling out an embedded value solely to set that field. Do not specify both an embedded
  field and one of its promoted fields in the same literal because they overlap.

```go
type Metadata struct{ Name string }
type Record struct{ Metadata; ID int }

record := Record{Name: "example", ID: 1}
```

- Let the target function type infer a generic function's type arguments in assignments,
  conversions, arguments, and return statements. Omit explicit type arguments when the target
  type determines all of them.

```go
func Identity[T any](value T) T { return value }

var transform func(string) string = Identity
func stringTransform() func(string) string { return Identity }
converted := (func(string) string)(Identity)
```

**Standard library:**

- `strings.CutLast` / `bytes.CutLast`: use them instead of `LastIndex` plus manual slicing when
  splitting around the final separator.
- `(*url.URL).Clone()` / `url.Values.Clone()`: use these for deep copies instead of copying fields
  or nested query-value slices manually.
- `synctest.Sleep(d)`: inside a `testing/synctest` bubble, use it instead of `time.Sleep(d)` followed
  by `synctest.Wait()` so peer goroutines settle after fake time advances.
- `uuid`: prefer the standard package for UUID generation and parsing. Use `uuid.New()` when no
  specific version is required, `uuid.NewV4()` or `uuid.NewV7()` when it is, and `uuid.Parse()` for
  untrusted input.
- `encoding/json/v2`: prefer it for new JSON code that benefits from configurable options and
  stricter defaults. It rejects invalid UTF-8 and duplicate object names and matches struct field
  names case-sensitively by default, so preserve `encoding/json` v1 when compatibility requires its
  semantics rather than migrating mechanically. Use `MarshalWrite` / `UnmarshalRead` for
  `io.Writer` / `io.Reader` values instead of adding an intermediate buffer.
- `(*rand.Rand).N`: use the receiver method instead of the package-level `rand.N` when values must
  come from a specific `math/rand/v2.Rand` source.
- `httptest.NewTestServer`: use it with `testing/synctest` when an HTTP test needs an in-memory fake
  network rather than a loopback socket.
