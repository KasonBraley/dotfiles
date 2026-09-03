# Go

These defaults target the Go version declared by the repository's `go.mod`.

## Source rule

Inspect the project's `go` directive, pinned module versions, and relevant source or package documentation before selecting APIs. Prefer standard-library documentation and examples for that supported version, then pinned dependency source, over remembered APIs. Consult current upstream source only when the pinned module does not answer the question.

## Branch chooser

Read every branch that matches the changed behavior:

- Identifiers, packages, files, receivers, methods, accessors, interfaces, or exported names: [`go-naming.md`](go-naming.md).
- Data models, JSON, text/binary encoding, custom scalar types, variants, optional fields, or decoders: [`encoding-and-data.md`](encoding-and-data.md).
- Services, package surfaces, interfaces, constructors, runtime wiring, or test implementations: [`services.md`](services.md).
- Startup, servers, workers, handlers, dependency wiring, or planning/runtime phases: [`go-runtime-composition.md`](go-runtime-composition.md).
- Runtime configuration, environment variables, flags, files, or typed config: [`go-configuration.md`](go-configuration.md).
- Retry, repeat, polling, backoff, jitter, rate limits, timeouts, or worker loops: [`scheduling-and-retry.md`](scheduling-and-retry.md).
- Memoization, TTL caches, concurrent lookup deduplication, `singleflight`, or request batching: [`caching-and-batching.md`](caching-and-batching.md).
- Goroutines, channels, event sources, queues, pagination, backpressure, or long-lived consumers: [`concurrency-and-streams.md`](concurrency-and-streams.md).
- Outgoing HTTP, `http.Client`, status handling, transport configuration, or HTTP rate limiting: [`http-clients.md`](http-clients.md).
- HTTP servers, handlers, middleware, graceful shutdown, or structured logging: [`go-http-servers-and-logging.md`](go-http-servers-and-logging.md).
- Go tests, time, synchronization, fakes, race-sensitive behavior, or test helpers: [`go-testing.md`](go-testing.md).
- Persistent build, test, runtime, intermittent, or performance failures: [`go-debugging.md`](go-debugging.md).

## Cross-cutting defaults

- Write boring Go with direct control flow and early returns.
- Pass `context.Context` first for request-scoped cancellation; do not store it in structs.
- Return concrete types and accept small interfaces at the consuming boundary.
- Wrap errors with concise operation context while preserving `errors.Is`/`errors.As` behavior that is part of the contract.
- Give every goroutine an owner, exit condition, and error path.
- Prefer multi-line keyed struct literals with one field per line when a struct is too large to remain immediately readable on one line.
- Prefer modern standard-library types and APIs supported by the repository's Go version.
    Isolate unavoidable platform or vendor APIs in their owning adapter.
    Add a dependency only when it removes meaningful complexity, has a narrow role, and justifies its maintenance and supply-chain cost; follow an established repository choice when it already fits.

## Completion check

Every matching branch has been read, every chosen API is supported by the repository's Go and module versions, and every cross-cutting default has been checked against each changed Go path. Report any exception with concrete evidence.
