---
name: to-spec
description: Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just
  synthesis of what you've already discussed.
disable-model-invocation: true
---

Synthesize a spec from the current conversation and codebase understanding. Reuse settled decisions and record
unresolved requirements explicitly rather than starting an interview or inventing scope.

Read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md` when present. Otherwise use the destination and
conventions established by the user or repository. Missing tracker setup does not block drafting; ask only for a
still-unknown publication target or required access after preparing the spec.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain
   glossary vocabulary throughout the spec, and respect any ADRs in the area you're touching.

2. Select test seams using project coverage policy, falling back to
   [`testing.md`](../coding-standards/references/testing.md).
    Prefer existing seams; use a broader one only when the behavior includes wiring, protocol, persistence, or lifecycle
    that a narrower seam cannot establish.
    Map material requirements and expected failures to their test surfaces rather than targeting a particular number of
    seams.

    Use settled requirements to choose the seams. Record any material unresolved choice in the draft; complete
    independent sections before asking for a decision.
    For Go architectural constraints, read [`coding-standards`](../coding-standards/SKILL.md) in design mode.

3. Write the spec using the template below and publish it when authorized. For a draft-only request or unavailable
   tracker, save it under the repo's spec convention, falling back to `.scratch/<feature-slug>/spec.md`, and report the
   path. Apply `ready-for-agent` only when material requirements are settled; otherwise report the open decisions
   without claiming the spec is implementation-ready.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A numbered list covering each distinct user need in scope, without padding or duplicate stories. Each user story should
be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about
   my spending
</user-story-example>

Cover the agreed actors, workflows, and material edge cases. Keep speculative features out of the spec.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine,
reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype.
Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- Behavior and expected failures to verify at each selected seam
- Existing coverage to reuse and any meaningful new tests
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
