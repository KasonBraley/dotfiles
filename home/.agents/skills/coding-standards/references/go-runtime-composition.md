# Go runtime composition

Use this reference when changing startup, a server, worker, handler set, command, dependency wiring, generated infrastructure bindings, or any system with separate planning and runtime phases.

Also apply [`services.md`](services.md) for service ownership, [`configuration-and-resources.md`](configuration-and-resources.md) for lifetimes, and [`modules-services-and-adapters.md`](modules-services-and-adapters.md) for composition-root boundaries.

## Verify the pinned runtime model

Read the pinned framework, platform, and infrastructure documentation and source before choosing a composition shape. Verify initialization order, generated bindings, handler lifecycle, shutdown behavior, and which APIs exist during planning, startup, and request processing. Prefer repository-vendored or pinned examples over remembered APIs.

## Compose at the outer boundary

The composition root:

1. parses configuration and static infrastructure bindings;
2. creates stable clients and application services;
3. creates handlers that close over those stable services;
4. starts the runtime only after construction succeeds;
5. owns graceful shutdown and reverse-order cleanup.

```go
func run(ctx context.Context, cfg Config) error {
    db, err := openDatabase(ctx, cfg.Database)
    if err != nil {
        return fmt.Errorf("start application: open database: %w", err)
    }
    defer db.Close()

    users := postgres.NewUserStore(db)
    app := user.NewService(users)
    server := newHTTPServer(cfg.HTTP, app)

    return serveUntilCanceled(ctx, server)
}
```

Do not bypass an existing constructor to assemble its private dependencies at the composition root. The constructor is the implementation boundary and preserves validation, acquisition semantics, defaults, and substitution. Do not use package globals or `init` functions as a hidden dependency container.

When runtime handlers need planning- or startup-resolved values, capture the stable typed values explicitly in their constructor. Keep generated provider/framework types at the outer adapter and translate them before passing inward.

## Planning versus runtime resources

Planning, code generation, registration, or dry-run phases may have mock or absent runtime state. Those phases may describe bindings and handlers but do not open databases, run migrations, consume queues, or use stateful runtime storage.

Describe runtime construction separately, then acquire state-backed resources only during real startup. Complete migrations, client construction, and readiness checks before publishing handler readiness. Make repeated startup safe when the platform can initialize more than once.

## Shutdown and readiness

Use signal-derived cancellation at the executable boundary. Stop accepting new work before waiting for in-flight work, bound graceful shutdown with a context, and close owned resources even when startup or serving fails. A readiness signal becomes true only after required resources and background workers are ready; liveness does not depend on optional upstream systems unless product policy requires it.

## Completion check

Every changed composition root follows the pinned lifecycle; configuration and bindings are parsed at the outer boundary; stable services are constructed once and passed explicitly; constructors are not bypassed; provider types remain in adapters; planning phases avoid runtime state; state-backed resources start only at runtime; readiness follows successful acquisition; and cancellation, graceful shutdown, and reverse-order cleanup have explicit owners.
