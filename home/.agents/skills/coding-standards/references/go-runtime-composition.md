# Go runtime composition

This reference owns framework lifecycle, startup sequencing, readiness, supervision, and shutdown coordination.

## Verify the pinned runtime model

Read the pinned framework, platform, and infrastructure documentation and source before choosing a composition shape.
Verify initialization order, generated bindings, handler lifecycle, shutdown behavior, and which APIs exist during
planning, startup, and request processing. Prefer repository-vendored or pinned examples over remembered APIs.

## Compose the runtime

At the composition root:

1. receive validated configuration and static infrastructure bindings;
2. construct stable clients and application services through their public constructors;
3. create handlers that close over those stable services;
4. start serving only after required construction and readiness checks succeed;
5. supervise runtime work and coordinate shutdown.

Do not bypass an existing constructor to assemble its private dependencies. The constructor preserves validation,
acquisition semantics, defaults, and substitution.

Capture planning- or startup-resolved values explicitly when constructing runtime handlers. Keep generated provider and
framework types in the outer adapter and translate them before passing inward.

## Planning versus runtime

Planning, code generation, registration, and dry-run phases may describe bindings and handlers but do not open
databases, run migrations, consume queues, or use stateful runtime storage.

Acquire state-backed resources only during real startup. Complete migrations, client construction, and readiness checks
before publishing handler readiness. Make repeated startup safe when the platform can initialize more than once.

## Shutdown and readiness

Use signal-derived cancellation at the executable boundary. Stop accepting new work before draining in-flight work, and
give graceful shutdown a fresh bounded context. Readiness becomes true only after required resources and background
workers are ready; liveness does not depend on optional upstream systems unless product policy requires it.

## Completion check

Every changed composition root follows the pinned lifecycle; validated configuration and provider bindings enter at the
outer boundary; stable services are constructed once through public constructors; provider types remain in adapters;
planning phases avoid runtime state; readiness follows successful construction; and shutdown stops new work, bounds
draining, and terminates supervised work.
