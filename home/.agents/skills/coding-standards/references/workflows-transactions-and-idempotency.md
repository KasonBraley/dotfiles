# Workflows, transactions, and idempotency

Use an ordinary call when an operation requires no atomic state change. Use a database transaction when changes within one datastore must commit or roll back together.

Use a saga or durable workflow when progress must survive process loss or redelivery, or the operation requires long delays, compensation, resumability, timers, human approval, cross-service coordination, or multiple transaction boundaries.

Retry ownership and durability follow operation authority, side-effect safety, and required lifetime. Project and domain design determine the concrete arrangement. Propagate `context.Context` through one live attempt, but do not persist contexts; persist explicit workflow state, deadlines, and identifiers.

Close database transactions before network calls or long-running work. Use `defer` rollback immediately after beginning a transaction, commit explicitly, and preserve commit/rollback failures according to repository policy.

Require an explicit idempotency strategy when an operation has a real duplicate-execution path through retries, redelivery, workflow resumption, concurrent submission, or repeated external requests. Choose the strategy at the owner of duplication and record it in design:

- an idempotency key when a caller provides stable identity for repeated requests;
- a natural unique constraint when duplicates violate an existing invariant;
- a deduplication record when a redelivered event has stable identity;
- a state-machine transition guard when current state controls mutation;
- a transactional outbox when state change and publication intent must be atomic;
- a transactional inbox when message deduplication and resulting state change must commit atomically.

For every retried side effect, state the guarantee making repetition safe. Make concurrent duplicate handling atomic; a check followed by insert without a transaction or unique constraint is not deduplication. Persist the result associated with an idempotency key when repeated callers must receive the same outcome.

## Completion check

Every changed operation is assigned to an ordinary call, database transaction, or durable workflow; each transaction rolls back safely and closes before network or long-running work; retry ownership and durability match authority, side-effect safety, and lifetime; persisted workflow state excludes contexts and process-local values; every retried side effect has a stated repeated-execution guarantee; and every duplicate path has an atomic recorded idempotency strategy at its owner.
