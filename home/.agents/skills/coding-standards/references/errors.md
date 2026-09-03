# Errors

## Expected failures are values

Every known failure mode appears in the operation's `error` result, even when the immediate caller cannot recover. A caller handles the error or returns it upward. The outermost boundary translates it into a valid outcome such as an HTTP response, CLI exit code, retry decision, dead letter, or startup error message.

Known failures include domain, parsing, authorization, integration, I/O, persistence, configuration, cancellation, and workflow failures.

Prefer ordinary Go returns:

```go
func (s *UserStore) Find(ctx context.Context, id UserID) (User, error)
```

Use sentinel errors when callers only need stable classification. Use custom error types when callers or diagnostics need structured context.
Return an error unchanged when the caller already has the missing context; otherwise add a concise operation
phrase at the package or subsystem boundary without repeating details from the inner error.
Wrap causes with `%w` when preserving `errors.Is` or `errors.As` is part of the contract.
Third-party errors are translated by the module that owns that dependency before crossing its public boundary.
Combine independent cleanup failures with `errors.Join` when every cause should remain inspectable.

## Defects

Panic only when a defect makes correct execution impossible, rather than because the current caller lacks a recovery strategy. Defects include violated internal invariants, impossible internal states, temporary not-implemented paths, and catastrophic initialization assumptions that cannot be represented as startup errors.

Known configuration and startup failures are error values; `main` reports them safely and exits. Prefer exhaustive tests and constructors that prevent invalid state over panic helpers. Keep any invariant helper local until stable semantics or reuse earns shared ownership.

## Custom errors

A custom expected error includes structured safe context such as operation, domain identifier, provider, or retry state, plus an `Unwrap() error` method when the cause is intentionally inspectable.

Classify errors with `errors.Is` and `errors.As`, never by matching message text.

```go
type UserStoreUnavailableError struct {
    Operation string
    Provider  string
    Cause     error
}

func (e *UserStoreUnavailableError) Error() string {
    return fmt.Sprintf("user store unavailable during %s", e.Operation)
}

func (e *UserStoreUnavailableError) Unwrap() error { return e.Cause }
```

Keep failure sets precise in operation docs and tests. Broad application-level classification belongs near entrypoints, orchestration, logging, and rendering layers.

Model absence according to meaning. Return `(value, found, error)` when absence is an ordinary lookup result and the zero value is safe; use a named optional/result type when that contract is clearer; return `ErrNotFound` or a typed not-found error when the operation requires the value or absence violates a precondition. Do not use a nil pointer plus nil error as an undocumented absence channel.

Cancellation is expected control flow. Preserve `context.Canceled` and `context.DeadlineExceeded` through wrapping,
stop work promptly, and avoid translating cancellation into an unrelated dependency failure.
At a request boundary, map cancellation and deadline expiry to the protocol's intentional result.

## Completion check

Every known failure is represented by a classified error or explicitly identified as a defect; panic is reserved for defects; absence has the intended found/optional or not-found meaning; error definitions carry safe structured context; third-party failures are translated by their owner; cancellation remains identifiable; outer boundaries translate expected errors into valid outcomes; and classification uses `errors.Is`/`errors.As`, not message text.
