---
name: learn-go-with-tests
description: Use when implementing Go behavior test-first, practicing red-green-refactor, choosing test seams or test doubles, or designing unit, integration, or acceptance tests.
---

# Test-first Go

Build Go software in **vertical slices**: one observable behavior, one failing test,
one minimal implementation, then a safe refactor. Tests are executable specifications
and the fastest feedback on API design.

This skill drives TDD and Go test design. Use a general Go skill for language, package,
API, or concurrency guidance that is not specifically about testing.

## Operating model

Work through the steps in order. Each completion criterion is a gate: stay in the
current step until it is true. Keep the slice small enough that feedback takes minutes,
not hours.

Use these context pointers when a branch needs detail:

- Before writing assertions, subtests, tables, examples, benchmarks, error tests, or
  test doubles, read [testing-patterns.md](references/testing-patterns.md).
- Before testing HTTP, filesystems, concurrency, processes, containers, or a complete
  user journey, read [system-boundaries.md](references/system-boundaries.md).

## Workflow

### 1. Scope one slice

- Read the relevant package, existing tests, module Go version, and local conventions.
  Read `CONTEXT.md` or applicable architecture records when they exist.
- Translate the request into one sentence describing observable behavior.
- Choose the narrowest useful **seam**: the public function, package API, handler,
  command, or other boundary through which a consumer observes that behavior.
- Choose the test level. Use a unit test for isolated domain behavior, an integration
  test for collaborating real components, and an acceptance test for a user journey
  or whole-system boundary.
- Pick one concrete example and an expected result that comes from the requirement,
  not from copying the implementation.
- Choose the smallest focused command, such as
  `go test -run '^TestName$' ./path/to/package`.

**Complete when:** the behavior, seam, first example, test level, and focused test
command are explicit. If the seam or expected behavior is ambiguous, record the
assumption or clarify it before changing code.

### 2. Red

Write the test before production code. Give it a behavior-oriented name and test
through the chosen seam. Make the failure useful: include the input and both `got`
and `want` in the assertion when practical. Read the applicable reference before
choosing a test shape.

Run the focused test immediately. An undefined identifier is an initial red; after
adding only the compile-time shape, prefer to see an assertion failure so the test's
expectation has been exercised.

**Complete when:** the test has run and failed for the expected reason, with setup,
imports, and the assertion itself verified. A failure caused by a broken fixture,
missing service, or typo is not red for the behavior under test.

### 3. Green

Implement only enough behavior to pass the new test. Follow compiler errors and the
failing assertion. Keep the first implementation direct; defer abstractions,
configuration, error variants, and optimizations until a test requires them.

Run the focused test, then the package test. Preserve the test as the specification:
change production code to satisfy it rather than weakening the assertion.

**Complete when:** the new test and the affected package tests pass, and the
implementation contains no behavior that the tests did not require.

### 4. Refactor

With green tests as the safety net, improve names, boundaries, duplication, and
clarity in small steps. Run the focused or package tests after each meaningful
change. Keep the behavior assertions and public contract stable.

A change to behavior, a public signature, or the expected result is design work, not
a refactor. Start a new red cycle for it. A test change that merely improves test
structure can be part of a refactor; a test change that changes what is promised
requires a new red test.

**Complete when:** the code is clearer or simpler, the public behavior is unchanged,
and the relevant tests remain green after the final refactor.

### 5. Extend confidence

Add the next smallest example for a distinct behavior. Prefer a new subtest or test
case when the testing logic is the same; use a separate test when control flow or
meaning diverges. Include boundary and failure behavior that the requirement makes
relevant: empty and nil inputs, zero values, invalid input, cancellation, timeouts,
and dependency errors.

Use the appropriate feedback for the code:

- `gofmt` on modified Go files.
- `go test ./path/to/package` for package feedback.
- `go test -count=1 ./...` when cached results could hide a problem.
- `go test -race ./...` for code that shares state across goroutines.
- `go vet ./...` for suspicious constructs, including copied synchronization values.
- `go test -cover ./...` to find gaps, not to chase a percentage.
- `go test -bench=. -benchmem ./path/to/package` when a performance question exists.
- `go test -short ./...` for the fast suite and `go test ./...` for the full suite
  when the project has slow acceptance tests.

**Complete when:** every behavior named in the request and every relevant edge or
failure path identified during scoping has a test at an appropriate seam, and all
applicable focused, package, race, integration, or acceptance checks pass.

## Seams and test levels

A seam is the boundary where a test observes behavior without reaching into internal
implementation. Prefer the highest useful seam that keeps feedback fast and failures
specific.

- **Unit tests** exercise a small package or pure domain operation. They are numerous,
  fast, and precise.
- **Integration tests** exercise real collaborating components such as an HTTP client
  and server, a filesystem adapter, or a persistence implementation.
- **Acceptance tests** exercise the real system through a public boundary such as an
  HTTP API, CLI, browser, queue, or process lifecycle. Keep them few and valuable.

Use the test pyramid as a cost heuristic: many unit tests, some integration tests,
and a small number of acceptance tests. A separate `package mypackage_test` is useful
when the contract must be verified as an external consumer would use it; an internal
package test is useful when package-level behavior cannot be observed otherwise.
Choose deliberately rather than enforcing either form everywhere.

A good test survives implementation refactoring. Assert observable results and
meaningful side effects, not private functions, struct layout, call order that users
cannot observe, SQL strings, or incidental HTTP markup.

## Design signals from tests

Treat test friction as design feedback, then make the smallest useful change:

| Signal | Likely design issue | Productive response |
| --- | --- | --- |
| Test setup is long or repeated | Too many responsibilities or dependencies | Narrow the seam; simplify construction; inject only required effects |
| Many spies or interaction assertions | The test knows implementation choreography | Assert final observable behavior; use a fake when state matters |
| Refactors break unchanged behavior tests | Tests reach into accidental structure | Move the test to a public seam |
| Timing-based or flaky tests | Uncontrolled time or lifecycle | Inject timing; synchronize explicitly; use deadlines and cleanup |
| Expected result is hard to name | Behavior or requirement is unclear | Return to scope and state the contract before coding |
| Table needs many flags and optional fields | Scenarios no longer share one behavior | Split into focused tests |

The test is the first consumer of the API. When it is awkward to use, redesign the API
before hiding the awkwardness in helpers or mocks.

## Refactoring discipline

Refactoring changes structure while preserving behavior. Keep the test contract stable
and use small, reversible changes:

- Rename symbols, extract functions, inline needless variables, and improve names.
- Extract a function when it gives a coherent idea a name; keep public functions easy
  to scan as a sequence of what happens.
- Remove duplication when it represents one concept, not merely when lines look alike.
- Replace explanatory comments with names that express the operation.
- Prefer automated editor refactors for symbol changes and use source control for
  experiments.
- Run the affected tests after each meaningful change.

When a change alters behavior, a public signature, or a test expectation, treat it as
a new feature or design decision and return to **red**. The safety net protects a
refactor; it does not decide what the new behavior should be.

## Completion checklist

Before declaring a test-first change complete, verify:

- The requested behavior is stated at an observable seam.
- The first test existed and failed for the intended reason before its implementation.
- The implementation is no broader than the tested behavior requires.
- Refactoring preserved the contract and left tests green.
- Relevant edge, error, integration, acceptance, or concurrency paths are covered at
  the cheapest seam that gives sufficient confidence.
- Modified Go files are formatted, and applicable package, full-suite, race, vet, or
  benchmark checks have passed.

## Sources

This skill is based on [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests)
by Chris James and Go's standard [`testing` package](https://pkg.go.dev/testing).
