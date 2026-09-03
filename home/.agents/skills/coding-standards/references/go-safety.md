# Go safety

## Version, compilation, and values

Use the Go version declared by the nearest owning `go.mod`. New or changed code passes the repository's formatter, compiler, tests, vet/static-analysis, and lint settings. Keep version-specific APIs and build constraints explicit.

Prefer values and useful zero values. Use pointers when mutation, identity, large-copy avoidance, or semantic absence requires them. Do not use a pointer merely to make a field optional when a domain state or explicit option type communicates the contract better.

Localize mutation inside imperative-shell code, performance-sensitive internals, builders, or adapters and hide it behind a precise API. Copy slices, maps, and byte buffers at ownership boundaries when retaining caller-owned mutable storage would violate the contract. Document intentional aliasing.

Exported functions and methods state their complete Go signature. Introduce a named result or request type when it adds domain meaning, prevents same-type argument mistakes, or is reused. Keep dynamic values at genuinely dynamic boundaries; decode them before inner code.

## Conversions, dynamic values, generics, and unsafe

Resolve uncertain values with comma-ok checks, parsing, validation, type switches, or more precise types. Check narrowing numeric conversions when truncation or overflow is possible. Treat unchecked type assertions as invariant claims and prefer the comma-ok form outside proven internal invariants.

Use `any` only at genuinely dynamic boundaries or in generic constraints where it means all types. Decode `map[string]any`, reflection results, and untyped protocol values into named types at the owning boundary.

Use generics when one algorithm genuinely serves multiple types without hiding domain behavior. Prefer ordinary functions and concrete types when they are clearer. Constraints describe the operations the implementation needs; avoid broad constraints added only for hypothetical reuse.

Reserve `unsafe` for measured, contained interoperability or performance requirements that safe Go cannot meet. Every use has a `// SAFETY:` comment stating the invariant, who establishes it, why the safe alternative is insufficient, and how the unsafe value is contained. Add focused tests around the invariant.

## Context and concurrency safety

Pass `context.Context` first, propagate it through blocking calls, and derive cancellation as close as possible to the bounded operation.
The function creating a cancel function owns calling it. Keep request lifetime in parameters and durable configuration in structs.

Use `context.WithoutCancel` only for intentionally detached work that must retain context values.
Detached work still needs an owner, deadline, shutdown path, and error handling.

Every shared mutable value has an explicit owner or synchronization policy. Prefer confinement to one goroutine; otherwise use the smallest fitting primitive and document lock ordering or atomic invariants that are not obvious. Never copy values containing mutexes after first use. Run race-sensitive tests with `go test -race` when practical.

## Completion check

Changed source builds under the repository's Go version and passes applicable analysis. Pointer use and mutable aliasing are intentional; dynamic values are decoded at boundaries; numeric conversions and type assertions are checked or backed by a proven invariant; generics remove real duplication without obscuring ownership; every `unsafe` use has a valid safety comment and tests; and every shared mutable value has a clear ownership or synchronization policy.
