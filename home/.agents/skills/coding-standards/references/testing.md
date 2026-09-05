# Testing

Use the project's explicit coverage policy where one exists; the following is the default shared by design, implementation, and review skills.

## Cover behavior at the cheapest sufficient public seam

Every changed caller-visible behavior has coverage through the **cheapest sufficient public seam**: the lowest-cost public seam that can exercise it faithfully. Move outward only when a narrower seam cannot establish the behavior because wiring, protocol translation, persistence, lifecycle, or system integration is part of the contract.

Choose the level by what owns the behavior:

1. focused, property, or fuzz tests for domain rules, invariants, transitions, and pure calculations;
2. integration tests for collaboration through real interfaces, adapters, persistence, protocols, and resource lifecycles;
3. end-to-end or acceptance tests for valuable user journeys whose contract includes application wiring or whole-system behavior.

Do not repeat the same assertion at every level. Reserve end-to-end tests for valuable journeys rather than adding one for every feature. Cover expected failures at the closest public seam that can reproduce them faithfully. Report a concrete blocker when unreliable third parties or unreasonable setup, runtime, or cost prevent coverage at the required seam.

## Sufficient verification

Existing coverage counts. Add tests when they provide independent confidence in changed behavior. Once required checks and focused verification pass, broaden or repeat them only for new edits, failures, or unresolved concerns.

## Preserve coverage during restructuring

Before deleting or replacing a test, map each contractual behavior it establishes—success, invariant, edge, failure, concurrency, or lifecycle—to a surviving or replacement assertion at a faithful seam. A new happy-path test does not establish that old failure coverage is redundant. Run replacement coverage before deletion; for a fixed bug, demonstrate sensitivity with the known bad case where practical.

Delete a test only when its behavior is covered elsewhere without a distinct purpose, its behavior was intentionally removed, or it asserts an implementation detail with no contract to preserve. Retain focused tests for independently meaningful domain behavior. Report uncovered required behavior as a blocker rather than declaring the test obsolete.

## Completion check

Every changed caller-visible behavior is covered at the cheapest sufficient public seam or has a reported concrete blocker.
Each expected error path is covered at the closest public seam that can reproduce it faithfully or has a blocker.
Valuable journeys whose contracts include application wiring or whole-system behavior have end-to-end or acceptance coverage.
The same assertion is not duplicated across levels without a distinct purpose. Removed assertions have a coverage mapping or an explicit reason that their behavior is no longer contractual. Matching testing references contribute their checks to the single scoped checklist.
