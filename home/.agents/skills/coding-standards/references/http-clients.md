# HTTP clients

Default to `net/http` for outgoing HTTP in application and provider code. Reuse a long-lived configured `http.Client`; do not create one per request.

## Boundary shape

Each HTTP boundary operation owns the complete protocol interaction:

- construct the request with `http.NewRequestWithContext`;
- attach authentication and headers;
- execute through an injected or owned client;
- classify status before decoding a success body;
- bound and close the response body on every path;
- decode the response into an application or domain type;
- translate transport, status, and decode failures into classified application errors;
- apply the operation's retry and rate-limit policy.

Place protocol mechanics in an outbound adapter or private concrete client. Application services own application policy. Keep database transaction scopes limited to database work. Read [`modules-services-and-adapters.md`](modules-services-and-adapters.md) for adapter decisions and [`workflows-transactions-and-idempotency.md`](workflows-transactions-and-idempotency.md) when an operation can repeat.

## Client and transport ownership

Configure timeouts deliberately. A request-scoped context owns the total operation budget; `http.Client.Timeout`, transport dial/TLS/header timeouts, and idle connection settings bound lower-level phases where needed. Reuse transports to preserve connection pooling. Callers close response bodies, and drain a bounded amount only when connection reuse and payload policy justify it.

Keep a narrow executor interface in the consuming package only when tests or transport variation need it:

```go
type HTTPDoer interface {
    Do(*http.Request) (*http.Response, error)
}
```

Prefer a real `httptest.Server` for protocol tests over mocking `Do` when request paths, headers, status, encoding, cancellation, or connection behavior matter.

## Status and decoding

Classify status before decoding a success representation. Bound response bodies with `io.LimitReader` or an equivalent before reading untrusted payloads into memory. Configure JSON decoding deliberately: reject unknown fields when the contract is closed and forward compatibility does not require them; reject trailing data; preserve provider error evidence only as safe bounded fields.

```go
req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
if err != nil {
    return User{}, fmt.Errorf("get provider user: build request: %w", err)
}

resp, err := client.Do(req)
if err != nil {
    return User{}, &ProviderTransportError{Operation: "get user", Cause: err}
}
defer resp.Body.Close()

if resp.StatusCode != http.StatusOK {
    return User{}, classifyProviderStatus(resp)
}

var wire providerUserResponse
if err := decodeJSON(resp.Body, &wire); err != nil {
    return User{}, &ProviderDecodeError{Operation: "get user", Cause: err}
}
return wire.toDomain()
```

## Retry and rate limits

Retry only when the operation's idempotency guarantee makes repetition safe. Retry transport failures and selected transient statuses only after considering whether request bytes were sent. Respect bounded `Retry-After` values when trustworthy. Use exponential backoff with jitter, a maximum attempt count or deadline, and context-aware waits. Close each attempt's body before retrying. Preserve the final classified failure.

Choose one retry owner: transport-level mechanics for universally safe requests, or operation-level policy when retry depends on method semantics, provider payloads, or idempotency keys. Read [`scheduling-and-retry.md`](scheduling-and-retry.md).

Use a rate limiter for proactive pacing when the provider contract requires it. The limiter has an explicit key, capacity, refill policy, context cancellation, and owner.

## Completion check

Every outgoing operation uses a reused configured `http.Client`; request construction, authentication, cancellation, status classification, bounded body handling, decoding, failure translation, and safe diagnostics have clear owners; status is classified before success decoding; bodies close on every path; database transactions contain only database work; protocol behavior has `httptest` coverage where applicable; and every retry or rate-limit policy has explicit ownership and a proven idempotency guarantee.
