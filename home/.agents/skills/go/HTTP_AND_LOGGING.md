# HTTP and Logging Reference

## Routing and handlers

For method and path routing supported by the module's Go version, prefer `http.ServeMux`:

```go
mux := http.NewServeMux()
mux.HandleFunc("GET /users/{id}", getUser)
```

Use a third-party router only for a demonstrated feature the standard library does not provide or to follow an established repository choice. Middleware is ordinary composition:

```go
type Middleware func(http.Handler) http.Handler

func withRequestLog(log *slog.Logger, next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        next.ServeHTTP(w, r)
        log.Info("request", "method", r.Method, "path", r.URL.Path, "duration", time.Since(start))
    })
}
```

Handlers should honor `r.Context()`. Bound request bodies, validate input at the edge, and keep domain logic out of transport-specific code when it has independent value.

## Server and client lifetimes

Production servers need explicit timeouts chosen for the workload:

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

Treat these values as examples, not universal defaults. Streaming endpoints may require different write-timeout handling. Outbound clients also need an explicit lifetime policy through a client timeout, request context, or both; reuse clients and transports rather than constructing one per request.

On shutdown, stop accepting work and drain in-flight requests with a fresh bounded context. Normalize `http.ErrServerClosed` as successful shutdown when appropriate. Long-lived handlers must observe request cancellation.

## Structured logging

Pass `*slog.Logger` as a dependency, preferably as function parameter. Derive a request logger with stable attributes and pass it explicitly to deeper operations that log:

```go
logger := logger.With("request_id", requestID, "user_id", userID)
logger.Info("handling request")
```

Use levels consistently:

- `Debug` for high-volume diagnostic state;
- `Info` for normal lifecycle events;
- `Warn` for recovered or degraded conditions; and
- `Error` for failures requiring attention.

Use stable field names and structured values. Put related fields in `slog.Group` where grouping improves downstream queries. Redact secrets and sensitive user data at the logging boundary.

Return errors through lower layers and log once where the application decides their operational consequence. Package-level default loggers are acceptable at the composition root; reusable packages should accept a logger or remain silent.
