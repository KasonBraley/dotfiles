# Configuration and resources

At startup or the earliest composition boundary, read environment, flags, files, and runtime configuration once; parse them into typed values; and pass those values inward.

Apply [`errors.md`](errors.md) to configuration failures and [`sensitive-data-and-observability.md`](sensitive-data-and-observability.md) to credentials and sensitive configuration. For Go configuration, resources, time, or randomness, apply [`go.md`](go.md) and every matching branch.

Entrypoints and explicit constructors own top-level side effects and each resource's acquisition, lifetime, and release. Keep every other package's initialization inert: start servers, open connections, read environment variables, register global handlers, and perform I/O only in true entrypoints or explicit runtime constructors. Avoid side-effectful `init` functions.

Acquire resources in dependency order and release them in reverse order on success, failure, and cancellation. Constructors return cleanup only when ownership cannot remain on the returned type; otherwise the owning type exposes `Close` or a blocking `Run` whose return ends its lifetime. Cleanup errors are preserved or joined according to repository policy rather than silently discarded.

Confine mutable singleton/global state to unavoidable framework boundaries. Define constants and immutable lookup tables as ordinary package values.

Make time and randomness explicit where behavior depends on them. Dependency-bearing services consume small clock/random capabilities only when deterministic control is required; pure domain functions accept concrete timestamps or generated values. Do not abstract standard-library calls without a current behavior or test need.

## Completion check

Every configuration source is read at startup or the earliest composition boundary and parsed once into typed values; every known configuration failure remains classified until startup produces a non-sensitive outcome; every acquired resource has one explicit owner and is released on success, failure, and cancellation; package initialization is inert outside true entrypoints; mutable global state stays at an unavoidable framework boundary; and time and randomness enter dependency-bearing services as earned capabilities and pure functions as concrete values.
