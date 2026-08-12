# Testing

## Test through real interfaces

Every caller-visible feature has an end-to-end happy-path test through its real public entrypoint when the normal test environment can run it reliably.

Add end-to-end coverage for expected error paths the public entrypoint can exercise reliably. Cover remaining important failures at the closest real interface. Report why end-to-end coverage is impractical when unreliable third parties or unreasonable setup, runtime, or cost prevent it.

Prefer tests by confidence:

1. end-to-end tests through real public entrypoints;
2. integration tests through real interfaces;
3. focused/property/fuzz tests for pure domain packages;
4. unit tests for meaningful behavior rather than implementation details.

Replace dependencies through real consumer-owned interfaces and implementations:

- constructor-injected small interfaces;
- local database substitutes such as SQLite or containers when established;
- faithful in-memory implementations;
- recording or failing fakes for external capabilities;
- `httptest.Server`, `net.Pipe`, temporary files, and other standard-library harnesses.

Avoid monkey-patching, generated mocks that merely mirror interfaces, and tests coupled to private call order. Assert observable outcomes: returned values/errors, persisted state, emitted events, rendered responses, or records exposed by a recording implementation. Interaction assertions are appropriate only when the interaction is itself observable behavior.

## Property and fuzz tests

Assess property or fuzz testing for every changed invariant, transition, normalization, equivalence, ordering, idempotence, and roundtrip. Add fuzz tests when generated inputs cover meaningful cases beyond a short example list. Apply this especially to parsers, smart constructors, custom scalar types, state machines, serialization, and protocol decoders.

Use Go's native fuzzing support when the repository's Go version supports it. Seed the corpus with valid, boundary, malformed, and regression examples. Generated valid data passes through the same parsers, constructors, and invariants as production values. Keep reusable generators beside the owning domain package and deterministic from the supplied test or fuzz seed.

## Test implementations

A dependency interface represents real consumer need, ownership, or variability, not a desire to mock every collaborator.

- Keep a narrow one-off fake local to its test.
- Export a reusable static or recording implementation only when its complete behavior is useful across packages; otherwise keep it in internal test support or the owning package's external test package.
- Use established names such as `ManualClock` when conventional.
- Otherwise use the shortest truthful qualifier: `InMemoryCache`, `RecordingEmailSender`, `NoopEmailSender`, or `FailingEmailSender`.
- Use a real local substitute when queries, schema, serialization, transactions, or protocol behavior matter.
- Call an implementation in-memory only when it faithfully preserves the complete observable contract under test.

Keep production branches, exports, flags, and behavior determined by production needs. Test through an existing public interface or a faithful inert harness when no interface exists.

## Compile-time behavior

When generic inference, interface satisfaction, method sets, or API assignability is public behavior, add compile-time assertions or ordinary call sites without rescue conversions. Verify both accepted use and, where tooling supports it, rejected use through repository-established compile-fail tests.

## Completion check

Every changed caller-visible behavior has an end-to-end happy path or a reported concrete blocker; each expected error path is covered at the highest reliable real interface or has a blocker; every changed property above has been assessed and applicable fuzz/property tests are present; changed public type behavior has compile-time coverage where needed; tests cross real interfaces without private call-order coupling; generated data preserves production invariants; production surfaces remain determined by production needs; and every reusable test implementation truthfully matches its name and complete observable contract.
