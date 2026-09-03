# Test-first Go

Build Go behavior in vertical slices: one observable behavior, one failing test, one minimal implementation, then a behavior-preserving refactor. Keep each slice small enough that feedback takes minutes, not hours.

Apply [`testing.md`](testing.md), [`go-testing.md`](go-testing.md), and every matching testing branch while following this workflow.

## 1. Scope one slice

- Read the relevant package, existing tests, module Go version, local conventions, and applicable architecture records.
- State the requested observable behavior in one sentence.
- Choose the narrowest useful seam: the public function, package API, handler, command, or other boundary through which a consumer observes the behavior.
- Choose the test level: unit for isolated domain behavior, integration for collaborating real components, or acceptance for a user journey or whole-system boundary.
- Pick one concrete example whose expected result comes from the requirement rather than the implementation.
- Choose the smallest focused command, such as `go test -run '^TestName$' ./path/to/package`.

**Complete when:** the behavior, seam, first example, test level, and focused command are explicit. Record or clarify any assumption before changing code.

## 2. Red

Write the test before production code. Give it a behavior-oriented name and test through the selected seam. Include the input and both `got` and `want` in failures where practical.

Run the focused test immediately. An undefined identifier is an initial red; after adding only the compile-time shape, prefer an assertion failure so the expectation itself is exercised.

**Complete when:** the test has run and failed for the expected reason, and setup, imports, and the assertion are verified. A broken fixture, missing service, or typo is not red for the behavior.

## 3. Green

Implement only enough behavior to pass. Follow compiler errors and the failing assertion. Keep the first implementation direct; defer abstractions, configuration, error variants, and optimization until a test requires them.

Run the focused test and then the package tests. Preserve the test as specification: satisfy it in production code rather than weakening its assertion.

**Complete when:** the focused and affected package tests pass and the implementation contains no behavior the tests did not require.

## 4. Refactor

With tests green, improve names, boundaries, duplication, and clarity in small steps. Run focused or package tests after each meaningful step. Keep behavior assertions and the public contract stable.

A behavior, public-signature, or expected-result change is design work: begin another red cycle. A test-structure-only change can be a refactor; changing what the test promises cannot.

**Complete when:** the result is clearer or simpler, public behavior is unchanged, and relevant tests remain green.

## 5. Extend confidence

Add the next smallest example for a distinct behavior. Prefer another case or subtest when setup, action, and assertion are the same; use a separate test when control flow or meaning diverges. Cover requirement-relevant boundaries and failures, including empty and nil inputs, zero values, malformed input, cancellation, timeouts, and dependency errors.

Use the repository's commands and the applicable feedback below:

- `gofmt` on modified Go files;
- `go test ./path/to/package` for package feedback;
- `go test -count=1 ./...` when cached results could hide a problem;
- `go test -race ./...` for shared state across goroutines;
- `go vet ./...` for suspicious constructs, including copied synchronization values;
- `go test -cover ./...` to locate gaps rather than chase a percentage;
- `go test -bench=. -benchmem ./path/to/package` for a performance question;
- `go test -short ./...` for a fast suite and `go test ./...` for the full suite when the project has slow acceptance tests.

**Complete when:** every requested behavior and relevant edge or failure identified during scoping has a test at an appropriate seam and all applicable checks pass.

## Seams and design signals

A seam exposes behavior without requiring a test to reach into implementation. Prefer the highest useful seam that keeps feedback fast and failures specific. Use the test pyramid as a cost heuristic: many focused domain tests, some integration tests, and few valuable acceptance tests.

Choose `package foo_test` when the public contract must be exercised as an external consumer. Choose `package foo` when package-level behavior cannot otherwise be observed. Do not invent `_internal_test.go` as a special test category; Go recognizes the `_test.go` suffix, while the package declaration determines the test boundary.

Treat friction as design feedback:

| Signal | Likely issue | Response |
| --- | --- | --- |
| Long or repeated setup | Too many responsibilities or dependencies | Narrow the seam, simplify construction, and inject only required effects |
| Many spies or interaction assertions | The test knows implementation choreography | Assert final observable behavior or use a stateful fake |
| Refactors break unchanged behavior tests | Tests reach into accidental structure | Move the test to a public seam |
| Timing-based or flaky tests | Uncontrolled time or lifecycle | Inject timing, synchronize explicitly, and bound cleanup |
| The expected result is hard to name | Behavior or requirement is unclear | Restate the contract before coding |
| A table needs many flags or optional fields | Scenarios do not share one behavior | Split focused tests |

The test is the API's first consumer. Redesign awkward APIs rather than hiding awkwardness in helpers or mocks.

## Refactoring discipline

Refactoring changes structure while preserving behavior. Make small reversible changes: rename symbols, extract coherent functions, inline needless variables, improve names, and remove duplication that represents one concept. Replace explanatory comments with names when the code can express the operation. Prefer automated symbol refactors and use source control for experiments. Run affected tests after each meaningful change.

## Completion check

The requested behavior is explicit at an observable seam; the first test failed for the intended reason before implementation; production behavior is no broader than required; refactoring preserved the contract; relevant edge, error, integration, acceptance, and concurrency paths are covered at the cheapest sufficient seam; and all applicable formatting and verification checks pass.
