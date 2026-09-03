# Go HTTP servers and structured logging

## Routing and handlers

For method-and-path routing supported by the repository's Go version, prefer `http.ServeMux`:

```go
mux := http.NewServeMux()
mux.HandleFunc("GET /users/{id}", getUser)
```

Use a third-party router only for a demonstrated feature the standard library lacks or to follow an established repository choice. Treat middleware as ordinary composition:

```go
type Middleware func(http.Handler) http.Handler

func withRequestLog(logger *slog.Logger, next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        next.ServeHTTP(w, r)
        logger.Info("request", "method", r.Method, "path", r.URL.Path, "duration", time.Since(start))
    })
}
```

Handlers honor `r.Context()`, bound request bodies, validate input at the edge, and keep independently valuable domain logic out of transport code.

## Server lifetime

Production servers have explicit workload-specific timeouts:

```go
srv := &http.Server{
    Addr:              ":8080",
    Handler:           mux,
    ReadHeaderTimeout: 5 * time.Second,
    ReadTimeout:       10 * time.Second,
    WriteTimeout:      30 * time.Second,
    IdleTimeout:       120 * time.Second,
}
```

These values are examples, not universal defaults. Streaming endpoints may require different write-timeout handling.

On shutdown, stop accepting work and drain in-flight requests with a fresh bounded context. Normalize `http.ErrServerClosed` as successful shutdown where appropriate. Long-lived handlers observe request cancellation.

## Structured logging

Pass `*slog.Logger` explicitly, preferably as a function parameter rather than in a configuration struct.
Derive request loggers with stable attributes and pass them to deeper operations that log:

```go
logger := logger.With("request_id", requestID, "user_id", userID)
logger.Info("handling request")
```

Use levels consistently:

- `Debug` for high-volume diagnostic state;
- `Info` for normal lifecycle events;
- `Warn` for recovered or degraded conditions;
- `Error` for failures requiring attention.

Use stable field names and structured values. Group related fields with `slog.Group` when it improves downstream queries.
Apply [`sensitive-data-and-observability.md`](sensitive-data-and-observability.md) for redaction and single-owner logging.

Reusable packages accept a logger or remain silent. A package-level default logger is acceptable at the composition root.
Tests that need a logger pass `slog.New(slog.DiscardHandler)`, never `nil`.

## Completion check

Routing uses the smallest supported mechanism; handlers honor cancellation and bound input; server timeouts and graceful shutdown match the workload; loggers are explicit and non-nil; levels, fields, groups, and redaction are deliberate; and each failure is logged only at its owning operational boundary.
