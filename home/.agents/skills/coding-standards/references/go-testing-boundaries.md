# Testing Go system boundaries

Use this reference for HTTP, filesystems, concurrent streams, processes, containers, or a complete user journey. Keep each boundary explicit and every lifecycle deterministic.

## HTTP

Use `httptest.NewRequest` and `httptest.NewRecorder` for handler behavior. Use `httptest.NewServer` when the client, transport, or real server lifecycle is part of the behavior. Close servers with `t.Cleanup` or `defer`, inject an `http.Client` with an explicit timeout, and assert status, headers, and body only where they belong to the contract.

For client behavior, `httptest.NewServer` provides a controllable endpoint without an external service. Use a real process or server only when lifecycle, transport, or wiring is what the test verifies.

## Filesystems

Use `fstest.MapFS` for fast isolated cases and `os.DirFS` or `embed.FS` at integration boundaries. Exercise missing, empty, malformed, permission, path, and decoding behavior at the narrowest useful boundary. Use `t.Cleanup` for temporary directories and files that must exist on disk.

## Streams and concurrent boundaries

Use `net.Pipe` for in-memory connection behavior when a real listener or socket lifecycle is not part of the contract. Bound every open stream or consumer with test-owned cancellation or an expected count before waiting. Give each test goroutine a deadline and join it before the test returns. Assert the operation's documented completion or cancellation result so broken behavior fails instead of hanging.

## Acceptance tests

When the policy in [`testing.md`](testing.md) selects a valuable user journey for acceptance coverage, begin with the smallest public scenario whose contract includes the relevant process lifecycle, packaging, application wiring, or whole-system integration. Add focused domain tests for rules and edge cases once the domain seam is clear.

Separate essential behavior from transport mechanics:

- the **specification** states what the system does;
- the **driver** translates that contract into calls through one transport;
- the **system** is the real implementation under test.

A reusable specification may run against domain, HTTP, gRPC, CLI, or browser drivers. The specification changes with behavior; a driver changes with transport details.

Acceptance tests exercise only the public boundary under review, wait explicitly for readiness, use a timeout, and clean up processes, containers, listeners, files, and network resources with `t.Cleanup`. Use `testing.Short()` to skip expensive cases under `go test -short ./...`. Hide setup ceremony behind helpers only after the behavior remains readable.

Use Testcontainers or another process harness when container image behavior or an external dependency lifecycle is part of the contract. Prefer `httptest` or an in-memory fake when that full lifecycle is not under test.

## Completion check

The harness matches the boundary being verified; requests, clients, files, contexts, goroutines, servers, processes, and containers have test-owned bounded lifetimes; concurrent harnesses terminate deterministically; acceptance specifications remain independent of their drivers; readiness is observed rather than guessed; and cleanup runs on success and failure.
