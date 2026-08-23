---
name: use-modern-go
description: Apply modern Go syntax guidelines based on project's Go version. Use when writing, modifying, or reviewing Go code.
---

# Modern Go Guidelines

## Detecting the Go Version

This is a monorepo where each service has its own `go.mod`, and Go versions differ
between modules. There is NO single project-wide Go version. Always detect the version
from the module that owns the file(s) you are working on:

1. From the directory of the file you are editing, run:
   ```
   go list -m -f '{{.GoVersion}}'
   ```
   Or equivalently, walk up from the file's directory to the nearest `go.mod` and read
   its `go` directive.
2. Use that version (minor version, e.g. `1.26`) as the feature ceiling for all code in
   that module.
3. Detect once per module, not once per session. If you touch files in multiple modules,
   detect separately for each — never assume one module's version applies to another.

**If a version is detected:**
- Say: "This module is using Go X.XX, so I'll stick to modern Go best practices and freely use language features up to and including this version.
If you'd prefer a different target version, just let me know."

## How to Use This Skill

**If version detected (not "unknown"):**
- Say: "This project is using Go X.XX, so I’ll stick to modern Go best practices and freely use language features up to and including this version. If you’d prefer a different target version, just let me know."
- Do NOT list features, do NOT ask for confirmation

**If no `go.mod` is found above the file:**
- Say: "Could not detect Go version for this file"
- Use AskUserQuestion: "Which Go version should I target?" → [1.23] / [1.24] / [1.25] / [1.26] / [1.27]

**When writing Go code**, use ALL features from this document up to the target version:
- Prefer modern built-ins and packages (`slices`, `maps`, `cmp`) over legacy patterns
- Never use features from newer Go versions than the target
- Never use outdated patterns when a modern alternative is available

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

- `strings.Clone`: `strings.Clone(s)` to copy string without sharing memory
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
- Loop variables are now safe to capture in goroutines (each iteration has its own copy)

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
for k := range maps.Keys(m) { process(k) } // iterate directly
```

**time package**

- `time.Tick`: Use `time.Tick` freely — as of Go 1.23, the garbage collector can recover unreferenced tickers, even if they haven't been stopped. The Stop method is no longer necessary to help the garbage collector. There is no longer any reason to prefer NewTicker when Tick will do.

### Go 1.24+

- `t.Context()` not `context.WithCancel(context.Background())` in tests.
  ALWAYS use t.Context() when a test function needs a context.

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

- `omitzero` not `omitempty` in JSON struct tags.
  ALWAYS use omitzero for time.Duration, time.Time, structs, slices, maps.

Before:
```go
type Config struct {
    Timeout time.Duration `json:"timeout,omitempty"` // doesn't work for Duration!
}
```
After:
```go
type Config struct {
    Timeout time.Duration `json:"timeout,omitzero"`
}
```

- `b.Loop()` not `for i := 0; i < b.N; i++` in benchmarks.
  ALWAYS use b.Loop() for the main loop in benchmark functions.

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
  ALWAYS use SplitSeq/FieldsSeq when iterating over split results in a for-range loop.

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
  ALWAYS use wg.Go() when spawning goroutines with sync.WaitGroup.

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
  DO NOT use `x := val; &x` pattern — always use new(val) directly.
  DO NOT use redundant casts like new(int(0)) — just write new(0).
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
  ALWAYS use errors.AsType when checking if error matches a specific type.

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
