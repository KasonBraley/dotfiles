# Concurrency and streams

Use this when working with goroutines, channels, event sources, queues, pub/sub, pagination, backpressure, throttling,
debouncing, or long-lived consumers.

## Mental model

Concurrency is an ownership decision, not a default optimization. Every goroutine needs an owner, start point, exit
condition, cancellation path, error path, and join strategy. Prefer synchronous iteration until concurrency is required
by latency, throughput, or independently progressing work.

Use channels when values move between concurrent owners or coordinate readiness. Use direct calls and ordinary iterators
for synchronous pipelines. Use callback or iterator APIs when the caller should pull values without a background
goroutine.

## Synchronization chooser

Choose by ownership:

- Use a mutex to protect small state shared by multiple goroutines.
- Use a channel to transfer ownership, stream values, or coordinate events.
- Use atomics only for small lock-free state whose memory semantics remain obvious.
- Use `errgroup.WithContext` when peer operations form one failure domain.

For bounded fan-out, prefer `errgroup.Group.SetLimit` to a permanent worker pool. Use the loop-capture form required by
the repository's Go version.

## Source chooser

- In-memory values: range over a slice or iterator.
- Callback boundary: adapt with a bounded channel only when producer and consumer truly run independently.
- Work distribution: one queue consumed by workers.
- Broadcast: an established pub/sub implementation with explicit subscriber lifecycle.
- Latest state plus updates: synchronized state plus a subscription API.
- Scheduled ticks: timer/ticker when values matter; a worker loop otherwise.
- Pagination: an iterator or `Next(ctx)` API that fetches one page at a time.
- Platform stream: use its native reader or iterator before adding a goroutine/channel adapter.

## Transformation and consumption

Keep pure transforms as ordinary functions. For effectful work, use a direct loop unless bounded concurrency is
required. A worker pool states concurrency, order, cancellation, queue bound, and per-item failure policy. Do not
materialize an unbounded or potentially infinite source into memory.

Expose the simplest caller-facing shape:

```go
type EventSource interface {
    Next(context.Context) (Event, error)
    Close() error
}
```

Use `<-chan Event` only when channel delivery semantics are part of the contract. If a service returns a channel,
document who closes it, whether errors have a separate channel or terminal value, buffering, cancellation, and whether
the caller must drain it.

## Long-lived consumers

Own long-lived consumers in a server, worker, or service with explicit `Start`/`Run` and shutdown behavior. Prefer a
blocking `Run(ctx) error` that lets the composition root supervise it.

```go
func (w *Worker) Run(ctx context.Context) error {
    for {
        event, err := w.source.Next(ctx)
        if err != nil {
            return fmt.Errorf("run event worker: %w", err)
        }
        if err := w.handle(ctx, event); err != nil {
            return fmt.Errorf("run event worker: handle event: %w", err)
        }
    }
}
```

Use `errgroup.WithContext` when peer goroutines form one failure domain. Ensure the owner waits for all started
goroutines.
A goroutine reporting through a channel must not become stranded when its receiver exits; prefer `errgroup`,
or size and coordinate the channel so the sender can finish. The producer owns closing its channel.
Signal that a consumer is done through context cancellation rather than closing a producer-owned channel.

## Backpressure and buffers

Prefer natural synchronous backpressure first. Add a bounded buffer only when producer and consumer should decouple.
State full-buffer behavior: block, drop newest, drop oldest, coalesce, or fail. Unbounded queues require a proven
external bound and monitoring.

Debounce and throttle implementations own their timers and define leading/trailing behavior, keying, flush-on-shutdown,
and cancellation.

## Error handling and keyed concurrency

Translate external errors at the adapter boundary. Preserve cancellation. Recover only at a supervision boundary with an
explicit continue/restart policy.

For keyed work, preserve ordering within each key while allowing different keys to run concurrently. Keep queueing,
replacement, or coalescing semantics in one named owner. Bound the number of active keys and clean up idle key state.

## Tests

Use finite slices or iterators for finite fixtures and a test-owned channel/source when the test drives events
interactively. Bound open consumers by cancellation or an expected count before waiting. Use explicit readiness
channels, barriers, or hooks rather than sleeps. Apply [`go-testing.md`](go-testing.md) completely.

## Completion check

The source shape matches delivery semantics; ordering and concurrency are explicit; every potentially infinite source
remains incremental; buffers have bounded-growth and overflow policies; every goroutine has an owner, cancellation,
error path, and join; channel closure ownership is unambiguous; long-lived consumers are supervised; keyed state is
bounded; and errors and cancellation reach a boundary with an explicit policy.
