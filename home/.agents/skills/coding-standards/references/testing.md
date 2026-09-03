# Testing

## Cover behavior at the cheapest sufficient public seam

Every changed caller-visible behavior has coverage through the **cheapest sufficient public seam**: the lowest-cost public seam that can exercise it faithfully. Move outward only when a narrower seam cannot establish the behavior because wiring, protocol translation, persistence, lifecycle, or system integration is part of the contract.

Choose the level by what owns the behavior:

1. focused, property, or fuzz tests for domain rules, invariants, transitions, and pure calculations;
2. integration tests for collaboration through real interfaces, adapters, persistence, protocols, and resource lifecycles;
3. end-to-end or acceptance tests for valuable user journeys whose contract includes application wiring or whole-system behavior.

Do not repeat the same assertion at every level. Reserve end-to-end tests for valuable journeys rather than adding one for every feature. Cover expected failures at the closest public seam that can reproduce them faithfully. Report a concrete blocker when unreliable third parties or unreasonable setup, runtime, or cost prevent coverage at the required seam.

## Completion check

Every changed caller-visible behavior is covered at the cheapest sufficient public seam or has a reported concrete blocker.
Each expected error path is covered at the closest public seam that can reproduce it faithfully or has a blocker.
Valuable journeys whose contracts include application wiring or whole-system behavior have end-to-end or acceptance coverage.
The same assertion is not duplicated across levels without a distinct purpose; and every matching testing reference has passed its scoped completion check.
