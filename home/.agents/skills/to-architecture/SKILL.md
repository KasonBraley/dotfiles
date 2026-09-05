---
name: to-architecture
description: Design one implementation architecture for a spec and publish the approved design to its issue-tracker ticket.
disable-model-invocation: true
---

# To Architecture

Turn an accepted spec into one concrete implementation architecture. The design guides implementing agents so module placement, responsibilities, interfaces, and seams are deliberate rather than improvised. Aim for testability and AI-navigability through deep modules.

This skill extends the spec ticket with an architecture comment. It does not edit the ticket body, create tickets, change labels, or write files to the repository.

## Process

### 1. Load the spec

Resolve the spec ticket from the user's reference or the current conversation. If neither identifies it, ask for the ticket reference.

Read the full ticket body and comments using the workflow in `docs/agents/issue-tracker.md`. Use the accepted requirements from the ticket body, any authoritative agent brief, and subsequent accepted clarifications; explicit user corrections take priority. Identify a material unresolved contradiction rather than assuming the oldest text wins. When revising an architecture, identify the existing architecture comment from its `## Implementation architecture` heading and content rather than creating a competing one.

If `docs/agents/issue-tracker.md` is absent, use the supplied ticket reference and available tracker tooling. When the spec is already in context, continue designing even if tracker access is unavailable; prepare the proposal before asking for any missing publication details.

### 2. Explore the affected code

Read [`codebase-design`](../codebase-design/SKILL.md) for shared vocabulary, distinguishing a module contract from a language interface type. Read applicable project standards; for Go, read [`coding-standards`](../coding-standards/SKILL.md) in design mode before proposing boundaries.

Read `CONTEXT.md` and the ADRs relevant to the spec when they exist. Use the glossary's domain language to name modules and good seams.

Then use a sub-agent to explore the affected codebase when available; otherwise perform this evidence pass directly and disclose the fallback. Supply the spec, relevant domain/ADR context, and resolved paths to the design and standards references. Tell it to read the supplied design references, trace code paths, contracts, dependencies, and tests touched by every material requirement, and return a concise evidence report covering:

- Requirement-to-module and file-path mapping
- Current interaction flow, state ownership, side effects, and error handling
- Existing interfaces, seams, adapters, and test surfaces
- Relevant test locations and prior art
- Architectural gaps and the scoped friction below, with supporting code references

The evidence pass gathers facts rather than choosing the final architecture. Keep exploration scoped to what is needed to fit this spec into the system; nearby friction matters only when it affects that design. Resolve missing or conflicting evidence before designing the proposal.

Within that scope, look for architectural friction that the feature would preserve or worsen:

- Understanding one domain concept requires bouncing between many small modules
- A module is shallow because its interface is nearly as complex as its implementation
- Logic was extracted only for testability while bugs remain in how callers coordinate it
- Coupled modules leak knowledge across their seams
- Important behavior is untested or difficult to test through the current interface

Complete this step when every material requirement in the spec has a known place in the current system or an identified architectural gap.

### 3. Design one proposal

Choose the architecture that best fits the spec and the existing system. Depending on the evidence, the proposal may deepen or change existing modules, add new modules, or do both.

For every proposed module change, establish:

- The module's responsibility and why it belongs there
- Its interface, including important invariants and error behavior
- The seam at which callers and tests use it
- Its dependencies and any real adapters
- Ownership of state, validation, side effects, and failures
- Its place in the end-to-end interaction or data flow
- The relevant existing or intended file path

Apply the deletion test and earned-seam principle from `codebase-design` to existing and proposed modules. Prefer depth, locality, and leverage; distinguish translation/ownership boundaries from substitution interfaces. Respect existing ADRs; identify and explain any conflict the spec makes unavoidable.

Select tests using project policy, falling back to [`testing.md`](../coding-standards/references/testing.md). When replacing tests during structural changes, require the coverage mapping in [`DEEPENING.md`](../codebase-design/DEEPENING.md#testing-strategy-preserve-behavior-coverage).

Include structural prefactoring required to reach the design, stated as a target architectural change.

Consider alternatives while reasoning, but present one coherent recommendation. If a material tradeoff cannot be resolved from the spec and codebase, prepare the rest of the proposal and present a recommended choice with its consequences for the user to decide.

If the user wants to explore alternative interfaces, use [`DESIGN-IT-TWICE.md`](../codebase-design/DESIGN-IT-TWICE.md), compare the alternatives, and still bring one recommendation forward for approval.

Complete this step when every material spec requirement is assigned to a module and observable through a stated test surface.

### 4. Get approval

Present the concrete proposal in the conversation. If approval is still needed, ask for it here and revise as directed. Reuse prior approval; an explicit request to choose and publish the architecture delegates that decision unless a material unresolved requirement prevents it.

Publish only the settled design within the task's authorization. Keep exploratory alternatives in the conversation.

### 5. Publish the architecture comment

Publish the approved design as a comment on the spec ticket using the configured issue-tracker workflow. If an existing comment contains the `## Implementation architecture` section, update it when the tracker supports comment editing; otherwise publish a replacement that explicitly supersedes the earlier architecture comment.

Use this structure:

```markdown
## Implementation architecture

### Design summary
<The chosen architecture, why it fits the spec and existing system, and how it improves locality, leverage, testability, and AI-navigability.>

### Modules and interfaces
<Existing modules to change or deepen and new modules to add. Include relevant paths, responsibilities, interfaces, seams, dependencies, and adapters.>

### Interaction flow
<How control, data, state, errors, and side effects move through the modules.>

### Testing architecture
<The interfaces that form the test surfaces and relevant existing test locations or prior art.>

### Required structural changes
<Prefactoring or migration required by the design, or "None". Describe the architectural target state.>

### Spec coverage
<Map every material requirement or coherent requirement group to the module behavior that satisfies it.>

### Constraints and conflicts
<Relevant ADR constraints, unavoidable conflicts, or "None".>
```

File paths are location anchors, not an exhaustive edit list. Keep the comment precise about ownership and interfaces while leaving private helpers, algorithms, line-level edits, and other low-level implementation choices to the implementing agent.

Finish with the spec ticket reference and published comment link. If publication was not requested or remains blocked, return the complete proposal and the specific remaining step.
