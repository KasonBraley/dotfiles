# Resource lifetimes and process-wide effects

This reference owns resource acquisition and release, package initialization, mutable process-wide state, and dependencies on time or randomness.

Entrypoints and explicit runtime constructors own top-level effects. Keep other package initialization inert: open connections, register global handlers, and perform I/O only in true entrypoints or explicit constructors. Avoid side-effectful `init` functions.

Each acquired resource has one owner. Acquire dependencies in order and release them in reverse order on success, startup failure, cancellation, and shutdown. Prefer an owning type with `Close`, or a blocking `Run` whose return ends its lifetime; return a cleanup function only when ownership cannot remain on the returned type. Preserve or join cleanup errors according to repository policy.

Confine mutable process-wide state to unavoidable framework boundaries. Define constants and immutable lookup tables as ordinary package values.

Make time and randomness explicit when they are part of production behavior. Pure domain functions accept concrete timestamps or generated values. Dependency-bearing services use standard-library time and randomness unless production policy or a real alternate source earns a capability; do not add an abstraction solely for tests.

## Completion check

Every acquired resource has one owner and is released on success, startup failure, cancellation, and shutdown; package initialization is inert outside true entrypoints; mutable process-wide state stays at an unavoidable framework boundary; cleanup failures follow repository policy; and time or randomness abstractions represent production behavior rather than test-only substitution.
