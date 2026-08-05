---
name: go
description: Go guidance for writing, reviewing, debugging, refactoring, or designing Go code. Use when a task concerns Go source, modules, packages, APIs, CLIs, services, tests, concurrency, or Go tooling.
---

# Idiomatic Go

Write **boring Go**: concrete, explicit, local, and easy to delete. Prefer the standard library and the repository's established vocabulary over new machinery.

## Process

1. **Establish the target.** Use the version reported by `use-modern-go` when changing Go code, then read nearby code, tests, and repository guidance before choosing syntax or dependencies. Done when the supported Go version and local conventions are known.
2. **Choose the smallest design.** Start with concrete types, direct control flow, useful zero values, and the fewest package boundaries that clarify ownership. Add interfaces, generics, goroutines, options, or dependencies only for a demonstrated need. Done when every abstraction has a current caller and a clear owner.
3. **Load the applicable reference below.** Read every file whose condition matches the task; keep unrelated branches out of context. Done when every changed concern is covered by one reference branch.
4. **Implement and verify.** Format changed Go files, run focused tests, then the broadest relevant test or static-analysis commands the repository supports. For concurrency changes, exercise cancellation and race-sensitive paths. Done when changed behavior is tested, all relevant checks pass, and any unrun or failing checks are reported.

## Core rules

- Keep the happy path left-aligned with early returns.
- Make zero values useful when a natural zero exists; otherwise require explicit construction and validate at the boundary.
- Accept behavior at boundaries and return concrete types. Define small interfaces in the consuming package.
- Pass `context.Context` as the first parameter for request-scoped cancellation; do not store it in structs.
- Wrap errors with concise operation context and preserve inspectability only when it is part of the API.
- Give every goroutine an owner, an exit condition, and an error path.
- Prefer tests written with `testing`, small fakes, and explicit synchronization.
- Use the standard library before adding a dependency.

## Branch reference

- For identifiers, packages, files, receivers, methods, accessors, interfaces, or exported APIs, read [`NAMING.md`](NAMING.md).
- For package boundaries, APIs, interfaces, constructors, configuration, or generics, read [`DESIGN.md`](DESIGN.md).
- For errors, contexts, goroutines, synchronization, or concurrent failure handling, read [`ERRORS_AND_CONCURRENCY.md`](ERRORS_AND_CONCURRENCY.md).
- For tests, benchmarks, fakes, filesystem seams, golden files, or concurrent tests, read [`TESTING.md`](TESTING.md).
- For HTTP servers, handlers, middleware, shutdown, clients, or structured logging, read [`HTTP_AND_LOGGING.md`](HTTP_AND_LOGGING.md).
- For a persistent build, test, or runtime failure, read [`DEBUGGING.md`](DEBUGGING.md).

The change is complete only when every applicable branch has been consulted and every modified Go file is formatted and covered by the relevant checks.
