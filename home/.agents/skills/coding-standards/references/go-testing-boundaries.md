# Testing Go system boundaries

Use this reference for HTTP, filesystems, concurrency, processes, containers, or a complete user journey. Keep each boundary explicit and every lifecycle deterministic.

## HTTP

Use `httptest.NewRequest` and `httptest.NewRecorder` for handler behavior. Use `httptest.NewServer` when the client, transport, or real server lifecycle is part of the behavior. Close servers with `t.Cleanup` or `defer`, inject an `http.Client` with an explicit timeout, and assert status, headers, and body only where they belong to the contract.

For client behavior, `httptest.NewServer` provides a controllable endpoint without an external service. Use a real process or server only when lifecycle, transport, or wiring is what the test verifies.

## Filesystems

Accept `fs.FS` when code reads a filesystem. Use `fstest.MapFS` for fast isolated cases and `os.DirFS` or `embed.FS` at integration boundaries. Exercise missing, empty, malformed, permission, path, and decoding behavior at the narrowest useful boundary. Use `t.Cleanup` for temporary directories and files that must exist on disk.

## Concurrency and context

Use synchronization, channels, and explicit cancellation rather than sleeps. Every test goroutine has a bounded lifetime and is joined. Test completion and cancellation, propagate context to dependencies, and use a deadline so broken behavior fails rather than hangs. Return `ctx.Err()` or the operation's documented cancellation error. Run race-sensitive paths with the race detector.

## Acceptance tests

Use an acceptance test as the north star for a valuable user journey, process lifecycle, packaging concern, or whole-system integration. Begin with the smallest public scenario and drive domain and adapter design from that failure. Add focused domain tests for rules and edge cases once the domain seam is clear.

Separate essential behavior from transport mechanics:

- the **specification** states what the system does;
- the **driver** translates that contract into calls through one transport;
- the **system** is the real implementation under test.

A reusable specification may run against domain, HTTP, gRPC, CLI, or browser drivers. The specification changes with behavior; a driver changes with transport details.

Acceptance tests exercise only the public boundary under review, wait explicitly for readiness, use a timeout, and clean up processes, containers, listeners, files, and network resources with `t.Cleanup`. Use `testing.Short()` to skip expensive cases under `go test -short ./...`. Hide setup ceremony behind helpers only after the behavior remains readable.

Use Testcontainers or another process harness when container image behavior or an external dependency lifecycle is part of the contract. Prefer `httptest` or an in-memory fake when that full lifecycle is not under test.

## Completion check

The harness matches the boundary being verified; requests, clients, files, contexts, goroutines, servers, processes, and containers have test-owned bounded lifetimes; synchronization is explicit; acceptance specifications remain independent of their drivers; readiness is observed rather than guessed; and cleanup runs on success and failure.
