# Resource lifetimes and process-wide effects

This reference owns resource acquisition and release, package initialization, mutable process-wide state, and
dependencies on time or randomness.

Entrypoints and explicit runtime constructors own top-level effects. Keep other package initialization inert: open
connections, register global handlers, and perform I/O only in true entrypoints or explicit constructors. Avoid
side-effectful `init` functions.

Each acquired resource has one owner. Acquire dependencies in order and release them in reverse order on success,
startup failure, cancellation, and shutdown. Prefer an owning type with `Close`, or a blocking `Run` whose return ends
its lifetime; return a cleanup function only when ownership cannot remain on the returned type. Preserve or join cleanup
errors according to repository policy.

Confine mutable process-wide state to unavoidable framework boundaries. Define constants and immutable lookup tables as
ordinary package values.

Make time and randomness explicit when they are part of production behavior. Pure domain functions accept concrete
timestamps or generated values. Dependency-bearing services use standard-library time and randomness unless production
policy or a real alternate source earns a capability. Test-time control is selected by
[`go-testing.md`](go-testing.md#time-randomness-and-race-behavior), not by adding a service automatically.

Use `crypto/rand` for secrets, authentication tokens, cryptographic nonces, and other values requiring unpredictability.
Use `math/rand` or version-supported `math/rand/v2` for non-security simulation, sampling, and jitter. Keep
deterministic seeds confined to those policies and isolated test fixtures; never weaken production security randomness
for reproducibility. Use supported cryptographic test facilities only in isolated tests with their documented
concurrency limits.

## Completion check

Every acquired resource has one owner and is released on success, startup failure, cancellation, and shutdown; package
initialization is inert outside true entrypoints; mutable process-wide state stays at an unavoidable framework boundary;
cleanup failures follow repository policy; time-control choices follow the owning production/test policy; and
security-sensitive randomness remains cryptographically strong.
