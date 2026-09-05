# Deepening

How to deepen a cluster of shallow modules safely, given its dependencies. Assumes the vocabulary in [SKILL.md](SKILL.md) — **module**, **interface**, **seam**, **adapter**.

## Dependency categories

When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested across its seam.

### 1. In-process

Pure computation, in-memory state, no I/O. Merge only when it improves cohesion and locality; retain independently valuable domain modules. Test each owned behavior at the cheapest sufficient public seam. No technology adapter is needed merely for in-process calls.

### 2. Local-substitutable

Dependencies with local test stand-ins, such as an in-memory filesystem or a local database. Select the stand-in by fidelity to the contract, not availability alone. For query, schema, locking, or transaction semantics, test against the relevant database engine. Keep internal dependency seams private unless callers genuinely need to supply the dependency.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Keep policy with its owner and transport translation in an adapter. Use a concrete client unless substitution earns a consumer-owned **port** (dependency interface). Select real transport tests or faithful in-memory implementations according to the behavior under test.

When substitution is justified, a recommendation can say: *"Define a consumer-owned port, with an HTTP adapter for production and a faithful in-memory implementation for policy tests; verify protocol behavior separately."*

### 4. True external

Third-party services (Stripe, Twilio, etc.) you don't control. Keep their SDK/protocol private to the owning implementation. Use a controllable local endpoint for protocol tests and the simplest truthful double for application policy. For Go doubles and shared fidelity contracts, use [`go-testing-patterns.md`](../coding-standards/references/go-testing-patterns.md#test-doubles). Third-party ownership alone does not mandate a mock framework or a new port.

## Seam discipline

- Apply **earned seams** from [SKILL.md](SKILL.md#principles). Distinguish useful translation/ownership from substitution; introducing a port requires a current consumer need.
- **Internal seams vs external seams.** A deep module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface. Don't expose internal seams through the interface just because tests use them.

## Testing strategy: preserve behavior coverage

Use project coverage policy, falling back to [`testing.md`](../coding-standards/references/testing.md), for both new and surviving tests. Its **preserve coverage during restructuring** rule owns the behavior-by-behavior mapping required before deletion. Deepening is not an exception to that rule.

Keep the mapping with the refactoring's verification evidence. Tests at the deepened module's contract establish orchestration; focused domain tests can still be the cheapest sufficient seam for invariants and failures.

**Complete when:** the coverage-preservation check passes and the remaining tests pass.
