# Sensitive data and observability

Use the repository's established tracing, logging, metrics, and error-reporting hooks. Prefer `log/slog` when the repository has no established structured logger and the supported Go version includes it. Preserve active trace context by passing `context.Context` across changed requests, jobs, workflows, application services, Adapters, and external calls.

Annotate diagnostics with structured fields such as:

- opaque domain IDs approved for diagnostic use;
- stable operation names;
- dependency/provider names;
- state names;
- retry counts;
- classified error types;
- bounded summaries derived from allowlisted fields.

These are candidate log/trace fields, not automatically metric labels. Metric labels use bounded dimensions such as route templates, operation names, status classes, and known providers. Keep request/user/object IDs, raw URLs, error text, and other unbounded values out of labels; use approved logs/traces or exemplars for correlation. Bound label combinations as well as each individual dimension.

Treat personal data as private by default. Record only the minimum fields explicitly allowed by repository policy or established convention, after required minimization or sanitization.

Represent tokens, API keys, passwords, credentials, and other secrets with an encapsulated `Secret` or domain-specific secret type whose `String`, `GoString`, text-marshaling, and structured-logging behavior redact by default. Construct it at the boundary, preserve the wrapper through application code, and reveal only in the final-I/O adapter requiring raw bytes. Prefer an existing project secret type over adding one.

Never pass a secret as a plain `string` to generic formatting, logging, errors, metrics, snapshots, or tracing. Avoid storing raw request/response bodies. Errors retain only approved bounded evidence.

Wrap errors with safe operation context, but avoid logging and returning the same error at every layer. Log once at the boundary owning the operational outcome unless a lower layer records a distinct retry/attempt event. Keep trace/span status and error classification consistent.

## Completion check

Every changed credential is wrapped from input through the final-I/O owner; every diagnostic field is approved, minimized personal data, or redacted secret data; each changed failure carries applicable safe context—operation, identifier, provider, error classification, and retry state; duplicate logging is avoided; metric label cardinality is bounded; existing observability hooks remain connected; and `context.Context` carries trace and cancellation state across every changed boundary where established.
