---
name: coding-standards
description: Correct-by-construction Go standards. Use when designing, implementing, or reviewing Go code, or when another skill needs the user's coding standards.
---

# Go Coding Standards

Build **correct by construction**: parse data into meaningful types, make expected failures explicit, keep side effects behind cohesive services, and test through real interfaces.

## Mode and authority

Select the mode from the task; loading this skill does not authorize edits:

- **Design:** establish constraints, trace behavior, and propose contracts and verification. Stop before implementation.
- **Implementation:** design, implement, verify, and address review findings within the requested scope.
- **Review:** inspect the selected revision, relevant callers, contracts, and verification evidence. Report findings; leave source, tests, index, and commits unchanged. Report anything not verified.

Mandatory task and repository instructions govern. Respect project standards and accepted architectural decisions; these personal standards supply defaults where the project is silent. Heuristics such as code smells yield to those rules. Surface a safety problem or irreconcilable conflict rather than silently overriding a requirement. Keep unrelated behavior unchanged; contain incompatible legacy patterns at the nearest existing edge unless migration is requested.

## 1. Establish the local rules

Read applicable `AGENTS.md` files, project standards, tool configuration, architecture decisions, and the changed area's conventions. For Go version and API selection, use the source rule in [`references/go.md`](references/go.md).

**Complete when:** the scope, mode, governing sources, supported versions, and any conflicts are known.

## 2. Trace behavior and select references

Trace each changed caller-visible operation from input through decisions and side effects to its observable result. Include relevant unchanged callers and dependencies. Classify concerns as domain behavior, application policy, technology mechanics, or composition/resource wiring.

Maintain one scoped checklist: **behavior → owner → applicable rules → verification or blocker**. Read each applicable reference completely when first needed, following matching branch pointers. Reuse loaded references while their content remains unchanged; reread changed references, revisit relevant sections when evidence is unclear, and load additional branches when scope changes.

- [`references/go.md`](references/go.md) — whenever Go code is designed, changed, or reviewed.
- [`references/errors.md`](references/errors.md) — failures or ordinary absence.
- [`references/sensitive-data-and-observability.md`](references/sensitive-data-and-observability.md) — secrets, personal data, logs, traces, metrics, or error reporting.
- [`references/modules-services-and-adapters.md`](references/modules-services-and-adapters.md) — domain rules, side-effect coordination, dependencies, or package/service design.
- [`references/persistence.md`](references/persistence.md) — databases, durable caches, ORM models, or persisted records.
- [`references/workflows-transactions-and-idempotency.md`](references/workflows-transactions-and-idempotency.md) — transactions, retries, redelivery, resumption, delays, or duplicate execution.
- [`references/testing.md`](references/testing.md) — behavior, public types, tests, or test implementations.
- [`references/go-safety.md`](references/go-safety.md) — types, signatures, pointers, mutable values, conversions, generics, concurrency, or compiler settings.
- [`references/imports-exports-and-files.md`](references/imports-exports-and-files.md) — imports, exports, helper placement, or file organization.
- [`references/comments-and-docs.md`](references/comments-and-docs.md) — exported symbols, comments, documentation, or rendered errors.

Reference completion checks contribute to this checklist; they are not separate workflow restarts. For non-Go work, use project/language standards; another skill may explicitly reuse a language-neutral reference such as the testing policy without running this Go workflow.

**Complete when:** each changed contract, failure, dependency, state transition, representation, and test surface is accounted for in the checklist.

## 3. Design from public contracts inward

Establish caller-facing inputs, outputs, expected errors, and any earned consumer-owned interfaces from the request, code, and project documentation. Apply the ownership rules in [`references/modules-services-and-adapters.md`](references/modules-services-and-adapters.md). Check existing owners before adding an abstraction; use its deletion test rather than introducing layers by default.

Record alternatives for consequential decisions: a new lasting boundary, shared contract, provider strategy, or deliberate exception. Routine helpers and direct implementations need no rejection ledger. For ADRs, use the criteria in [`domain-modeling`](../domain-modeling/SKILL.md#offer-adrs-sparingly); only its active modeling workflow authorizes glossary changes.

**Complete when:** changed contracts and effect owners are explicit, abstractions hide meaningful complexity, and consequential trade-offs have a rationale. In review mode, assess the existing design rather than implementing a replacement.

## 4. Implement the changed behavior

Implementation mode only. Implement the traced paths, including expected failures, external translations, diagnostics, cancellation, and resource behavior. Preserve compatible telemetry and error-reporting hooks. The active implementation/test-first skill owns sequencing; these references own the constraints.

**Complete when:** the traced behavior is implemented through its owning contracts and is ready for verification.

## 5. Verify and report

Use [`references/testing.md`](references/testing.md) to check coverage. In implementation mode, format changed Go files and run required repository checks, adding focused test, vet, race, build, lint, or static-analysis commands only where coverage is missing. In review mode, inspect the evidence and run focused checks under the verification authority above without repairing the diff.

Check the revision against the scoped checklist. Fix findings in implementation mode; otherwise report them with rule, location, consequence, and evidence. Return material trade-offs, exceptions, blockers, and verification results—not a routine compliance ledger. Keep unresolved findings visible to the implementation workflow before commit.

**Complete when:** each applicable rule is checked, required coverage and commands have results or concrete blockers, and scope is preserved. Design mode instead finishes with an explicit verification plan; review mode distinguishes verified defects, judgement calls, and unverified risks.
