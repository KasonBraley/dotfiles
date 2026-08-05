# Errors and Concurrency Reference

## Error vocabulary

Errors should read as a chain of operations:

```go
data, err := os.ReadFile(path)
if err != nil {
    return fmt.Errorf("loading config %s: %w", path, err)
}
```

- Return an error unchanged when the caller already has the missing context.
- Add a short operation phrase at package or subsystem boundaries.
- Avoid repeating details supplied by the inner error.
- Use `%w` when callers may intentionally inspect the cause; wrapping makes that cause part of the API.
- Translate storage, transport, and third-party failures into package-owned sentinel or typed errors when callers should depend on domain vocabulary.
- Branch with `errors.Is` and `errors.As`, never error strings.
- Log at the boundary that decides the error is terminal. Lower layers return context rather than logging and returning the same failure.
- Combine independent cleanup failures with `errors.Join` when each cause should remain inspectable.

Treat `context.Canceled` and `context.DeadlineExceeded` as control-flow outcomes at request boundaries and map them to the protocol's appropriate result.

## Context

Pass `context.Context` first, propagate it through blocking calls, and derive cancellation as close as possible to the operation it bounds. The function that creates a cancel function owns calling it. Store durable configuration in structs; keep request lifetime in parameters.

Use `context.WithoutCancel` only for work intentionally detached from cancellation while retaining values. Detached work still needs an owner, deadline, shutdown path, and error handling.

## Choosing synchronization

Choose by ownership:

- Use a mutex when multiple goroutines protect small shared state.
- Use a channel when transferring ownership, streaming values, or coordinating events.
- Use atomics for small lock-free state only when their memory semantics remain obvious.
- Use `errgroup.WithContext` for a set of concurrent operations that fail together.

For bounded fan-out, prefer `errgroup.Group.SetLimit` to a permanent worker pool:

```go
g, ctx := errgroup.WithContext(ctx)
g.SetLimit(limit)
for _, url := range urls {
    g.Go(func() error { return fetch(ctx, url) })
}
if err := g.Wait(); err != nil {
    return fmt.Errorf("fetching URLs: %w", err)
}
```

Use the loop-capture form appropriate to the module's Go version.

## Goroutine ownership

Before starting a goroutine, identify:

1. who waits for or cancels it;
2. what closes each channel;
3. how it exits on success, failure, and cancellation; and
4. where its error goes.

A goroutine that reports through a channel should not be stranded when the receiver exits. Prefer `errgroup`; otherwise size or coordinate the channel so the sender can finish. The producer owns closing a channel. Never close a channel merely to signal that a consumer is done; cancel its context instead.

For shutdown and cleanup, wait for owned goroutines. Test cancellation and early-return paths, not only successful completion.
