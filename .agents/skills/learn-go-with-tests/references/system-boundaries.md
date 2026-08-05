# Testing system boundaries

Read this reference before testing HTTP, filesystems, concurrency, processes,
containers, or a complete user journey. These branches trade speed for confidence,
so keep the boundary explicit and lifecycle deterministic.

## HTTP

Use `httptest.NewRequest` and `httptest.NewRecorder` for handler behavior. Use
`httptest.NewServer` when the client, transport, or real server lifecycle is part of
the behavior. Close servers with `t.Cleanup` or `defer`, inject an `http.Client` with
an explicit timeout, and assert status, headers, and body only where they are part of
the contract.

```go
func TestPlayerServer(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/players/Pepper", nil)
	res := httptest.NewRecorder()

	PlayerServer(res, req)

	if got, want := res.Code, http.StatusOK; got != want {
		t.Fatalf("status = %d, want %d", got, want)
	}
	if got, want := res.Body.String(), "20"; got != want {
		t.Errorf("body = %q, want %q", got, want)
	}
}
```

For client behavior, `httptest.NewServer` provides a controllable endpoint without
calling an external service. Use a real process or server only when its lifecycle,
transport, or wiring is the behavior being verified.

## Filesystems

Accept `fs.FS` when code reads a filesystem. Use `fstest.MapFS` for fast, isolated
cases and `os.DirFS` or `embed.FS` at real integration boundaries. This makes missing
files, empty files, and malformed data easy to exercise without test-file cleanup.

Test permission, path, and decoding errors at the narrowest boundary that still
exercises the relevant behavior. Use `t.Cleanup` for temporary directories and files
that must exist on disk.

## Concurrency and context

Make concurrent tests deterministic with synchronization, channels, and explicit
context cancellation. A short sleep is not synchronization: it creates a timing
assumption. Give goroutines a clear exit path, wait for them, and run the race detector.
Use small configurable timeouts in tests; reserve long defaults for production.

Test both completion and cancellation. Propagate the request context to dependencies,
return `ctx.Err()` or a documented error, and use a deadline so a broken test fails
rather than hanging. Use `t.Context()` when the module's Go version supports it; use
an explicit context constructor otherwise.

Useful commands:

```bash
go test -race ./...
go test -count=1 ./...
```

For a concurrent counter, synchronize all workers before asserting the result:

```go
func TestCounter(t *testing.T) {
	counter := NewCounter()
	const workers = 100

	var wg sync.WaitGroup
	wg.Add(workers)
	for i := 0; i < workers; i++ {
		go func() {
			defer wg.Done()
			counter.Inc()
		}()
	}
	wg.Wait()

	if got := counter.Value(); got != workers {
		t.Errorf("Value() = %d, want %d", got, workers)
	}
}
```

Every goroutine in a test must have a bounded lifetime. A timeout or cancellation
case should make failure diagnostic instead of leaving leaked work behind.

## Acceptance tests

Use an acceptance test as the north star for a valuable user journey, process lifecycle,
packaging concern, or whole-system integration. Start with the smallest public
scenario, then drive the domain and adapters from that failing test. Add unit tests
for domain rules and edge cases after the domain seam is clear.

Separate essential behavior from accidental transport details:

```go
type Greeter interface {
	Greet(string) (string, error)
}

func GreetSpecification(t testing.TB, greeter Greeter) {
	t.Helper()
	got, err := greeter.Greet("Mike")
	if err != nil {
		t.Fatal(err)
	}
	if got != "Hello, Mike" {
		t.Fatalf("got %q, want %q", got, "Hello, Mike")
	}
}
```

Reuse the specification with a domain adapter, HTTP driver, gRPC driver, or browser
driver. The **specification** states what the system does; the **driver** translates
that contract into calls; the **system** is the real implementation under test. The
specification changes when behavior changes, while a driver changes when transport
details change.

Acceptance tests:

- Exercise only the real public boundary being verified.
- Wait explicitly for readiness before making assertions.
- Set a timeout so a failed startup or request cannot hang the suite.
- Clean up processes, containers, listeners, files, and network resources with
  `t.Cleanup`.
- Use `testing.Short()` to skip expensive cases when `go test -short ./...` is run.
- Keep setup ceremony behind helpers once the behavior is readable.

Use Testcontainers or another process harness when container image behavior or an
external dependency lifecycle is part of the contract. Use `httptest` or an in-memory
fake when the full lifecycle is not the behavior under test.
