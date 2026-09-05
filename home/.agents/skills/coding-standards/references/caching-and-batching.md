# Caching, memoization, and request deduplication

Use the standard library or the repository's established cache package when its keyed memoization, TTL, capacity,
lifecycle, and eviction semantics fit. Do not hand-roll TTL pruning, in-flight deduplication, or LRU behavior without a
concrete mismatch and tests.

## Core rules

- Every cache has an owner, bounded growth policy, key semantics, value ownership policy, and invalidation strategy.
- Build a process-wide or service-wide cache once in its owning constructor and share the handle.
- Protect mutable maps with one owner goroutine or explicit synchronization.
- Copy mutable keys or values when retaining caller-owned slices, maps, or buffers would violate ownership.
- Use `golang.org/x/sync/singleflight` when the pinned dependency is allowed and only concurrent miss deduplication is
  needed; it is not a result cache.
- A single immutable derived value may use `sync.OnceValue` when supported by the repository's Go version and failures
  do not require retry. Use explicit synchronization when failed initialization should be retried.
- Resource caches own cleanup for every eviction and final shutdown.

## Isolation and shared-flight lifetime

A key includes every dimension that can change the authorized result: tenant, principal or permission scope where
relevant, representation/version, and policy inputs. Alternatively cache permission-independent data and authorize
separately on every access. Apply the same isolation rule to `singleflight` and batches. Test equal object IDs across
different tenants or permissions; caching must not bypass authorization or preserve access beyond the intended
revocation policy.

Shared-flight work has an explicit lifetime owner. Decide whether cancellation of one waiter cancels only its wait or
the shared operation. Avoid accidentally tying all waiters to the first request's context. When work should survive an
individual waiter, use a service-owned bounded context with shutdown cancellation and let each waiter stop waiting
independently; join/clean up the shared work. Test a canceled first waiter while another still needs the result.

## Result-aware TTL

Choose TTL by result semantics. Give transient failures and degraded fallbacks no cache lifetime so the caller receives
the result while the next lookup can try again. A short negative-cache TTL may protect an upstream from repeated stable
failures such as not-found results. Never cache context cancellation or deadline errors as data.

```go
type cacheEntry[V any] struct {
    value     V
    err       error
    expiresAt time.Time
}
```

Store errors only when their classification is stable, safe to share between callers, and intentionally negative-cached.
Preserve `errors.Is`/`errors.As` semantics.

## Acquire expensive clients once

Construct or authenticate clients in the owning service constructor, then close over the client in the lookup function.
Each miss pays only for the provider operation. When service construction changes, also read
[`services.md`](services.md).

## Request batching

Batch pending requests when one backend call can answer multiple distinct keys, such as SQL `IN (...)` or a provider
batch endpoint. Bound batch size, wait time, memory, and per-item result mapping. Return one result for every requested
key, including explicit missing and per-item failure outcomes.

For per-item endpoints, use bounded worker concurrency or `errgroup` according to failure policy; optional caching
handles deduplication across requests.

Selection guide:

- same key repeatedly over time → cache;
- same key concurrently in one burst → `singleflight`, optionally behind a cache;
- many distinct keys and a batch endpoint → request batcher;
- many distinct keys with per-item endpoint only → bounded concurrency, optionally through a cache.

## Completion check

For every cache or batching path, the primitive matches the key pattern and backend; capacity, TTL, invalidation,
ownership, copying, and cleanup are intentional; stable dependencies are acquired once; concurrent miss deduplication
does not masquerade as caching; cancellation is not cached; keys preserve authorization isolation and shared work has
deliberate cancellation ownership; each batch maps every key to an outcome; and all goroutines and timers have shutdown
owners.
