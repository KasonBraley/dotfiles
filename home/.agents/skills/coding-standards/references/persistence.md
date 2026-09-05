# Persistence

Read this reference when changed behavior reads or writes a database, durable or external cache, ORM model, or persisted
record.

Also read:

- [`modules-services-and-adapters.md`](modules-services-and-adapters.md) for persistence capability ownership, Adapter
  design, and public contracts;
- [`boundary-data.md`](boundary-data.md) when stored data is read or its representation changes;
- [`testing.md`](testing.md) when persistence behavior changes;
- [`workflows-transactions-and-idempotency.md`](workflows-transactions-and-idempotency.md) when transaction scope,
  retries, or duplicate execution may change.

Define each persistence boundary around a cohesive domain capability, with table layout private to its implementation.
Define its small interface in the consuming package only when an interface is needed.

Treat rows, ORM models, and serialized cache entries as boundary data. Keep queries, migrations, schema details, raw
records, driver types, and ORM mechanics inside the owning persistence package. Translate `sql.ErrNoRows` and driver
errors into the operation's absence/error semantics before returning. Preserve context cancellation and close rows,
statements, and transactions on every path. Check each `Scan` error and `Rows.Err()` after iteration; an interrupted
stream is not a successful partial result unless the contract explicitly models one.

Parameterize data values in queries. Dynamic identifiers and sort expressions require a closed allowlist or the driver's
identifier mechanism; placeholders for values do not quote SQL identifiers. Keep untrusted text out of SQL syntax.

State the concurrency guarantee for read-modify-write behavior. A transaction alone does not prevent lost updates or
duplicate execution: choose appropriate isolation, row locks, unique constraints, or atomic version predicates, and
verify affected-row/conflict outcomes. Test those guarantees against the relevant database engine.

For schema changes, account for existing data and mixed application versions. Use compatible expand/backfill/contract
steps when deployments overlap; bound backfill work and assess locks and index creation. Test migration from the
previous supported schema with representative data, and state the recovery/roll-forward plan before destructive changes.

Use transactions only for atomic datastore work and pass a transaction-scoped query capability explicitly rather than
hiding it in context. Keep network calls and long-running work outside database transactions. Avoid leaking `*sql.DB`,
`*sql.Tx`, ORM models, or generated query types into application/domain APIs.

## Completion check

Every changed persistence operation belongs to one cohesive domain capability; table layout, queries, migrations, raw
records, driver/ORM mechanics, and transaction handles remain private to the persistence owner; every stored-data read
satisfies the parsing check; absence and driver failures are translated deliberately; query values are parameterized,
iteration errors are checked, and resources close on every path; concurrency guarantees and migration compatibility are
verified; transaction scope contains only atomic datastore work; and every linked reference whose trigger applies has
passed or has a concrete reported exception.
