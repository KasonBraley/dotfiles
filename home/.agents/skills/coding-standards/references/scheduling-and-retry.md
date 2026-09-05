# Scheduling and retry

Use direct loops, `time.Timer`, and `time.Ticker` to express retry, polling, pacing, and repeated background work. Prefer the repository's established retry package when it already encodes the required policy.

## Core rules

- Retry classified expected errors; programmer defects are not retry policy.
- Repeat successful passes only when the worker contract requires it.
- State whether the initial operation runs immediately or after the first delay.
- Bound retries by attempts, elapsed time, context deadline, or an explicitly documented unbounded worker lifetime.
- Use exponential backoff with jitter to avoid synchronized retry storms.
- Use fixed-delay scheduling when delay starts after work; use cadence scheduling when starts align to wall-clock intervals.
- Wait with context cancellation, not bare `time.Sleep`, in request or worker code.
- Retry only at the narrowest boundary with proven idempotency.
- Keep exhausted failures visible unless the boundary has a truthful fallback.

When retries can duplicate side effects, read [`workflows-transactions-and-idempotency.md`](workflows-transactions-and-idempotency.md).

## Polling workers

Handle expected pass failures according to explicit product policy:

```go
func runWorker(ctx context.Context, logger *slog.Logger, interval time.Duration) error {
    timer := time.NewTimer(0)
    defer timer.Stop()

    for {
        select {
        case <-ctx.Done():
            return context.Cause(ctx)
        case <-timer.C:
        }

        if err := runPass(ctx); err != nil {
            logger.ErrorContext(ctx, "worker pass failed", "error", err)
        }
        timer.Reset(interval)
    }
}
```

This shape logs expected operational pass failures and continues. If a failure invalidates the worker, return it to the supervisor. Do not swallow cancellation, invariant failures, or errors the policy cannot truthfully ignore.

## Per-item failure isolation

For batch workers, isolate expected item failures when one bad item should not stall the batch. Bound concurrency, preserve or deliberately discard ordering, and record each failed item's safe identity. Decide whether the item retries later, moves to a dead letter, skips permanently, or stops the batch. Use `errgroup.WithContext` when one failure should cancel peers; use an explicit worker pool/result collection when all outcomes must be observed.

## Reusable retry policy

A reusable policy specifies:

- error classifier;
- initial delay, multiplier, cap, and jitter source;
- maximum attempts or elapsed time;
- context-aware wait;
- attempt diagnostics;
- final-error behavior.

Select test-time control using [`go-testing.md`](go-testing.md#time-randomness-and-race-behavior). Keep the loop direct when a generic retry abstraction would obscure side-effect safety.

## Rate-limit-aware retry

For provider errors carrying a retry delay, wait for the larger of bounded local backoff and trusted provider delay. Reject negative, malformed, or unreasonable delays according to policy. The context deadline remains the outer bound.

## Timeouts and delays

- Use `context.WithTimeout`/`WithDeadline` when an operation has a real deadline.
- Use a context-aware timer when one operation should start later.
- Use a ticker or reset timer for recurring work according to cadence semantics.
- Stop owned timers and tickers when required by the supported Go version and lifecycle.
- Verify delay, attempt bounds, and cancellation using the test-time control selected above.

## Completion check

Every retry and repetition has an explicit owner, initial-run rule, and termination policy, including intentional unbounded workers. Every retried side effect has a proven safety guarantee. Polling and batch workers state whether each failure continues, retries, skips, dead-letters, or stops. Waits honor context cancellation. Exhausted failures remain classified and visible unless the owning boundary provides a truthful fallback. Time-based tests use deterministic control where practical.
