# Skill mechanics

The skill-specific branch of [`writing-for-agents`](SKILL.md): what changes when the document is a skill — frontmatter, the invocation choice, and router skills. Everything else about writing it is the universal reference in `SKILL.md`.

## Invocation

Two choices, trading the two loads:

- A **model-invoked** skill keeps a `description`, so the agent can fire it autonomously — and other skills can reach it. You can still type its name: model-invocation always _includes_ user reach; a description only ever adds agent discovery, never removes the human's. The description is the skill's top-level context pointer, forced to stay loaded at all times — permanent context load in exchange for discoverability. A model-invoked skill whose content is all reference is also one home for shared reference: another skill can invoke it, so reference needed by several skills lives in one place. Mechanics: omit `disable-model-invocation`, and write a model-facing description carrying the trigger branches (the pointer-writing rules in `SKILL.md` apply in full).
- A **user-invoked** skill is intended for explicit user requests rather than automatic discovery. Set `disable-model-invocation: true` where supported and keep a human-facing one-line `description`. Preserve equivalent invocation policy in agent metadata when present. Discovery and invocation behavior depend on the consumer; the flag does not make the file unreadable. An explicit link can provide reference material without authorizing that skill's full workflow.

Pick model-invocation only when the agent must reach the skill on its own, or another skill must. If it only ever fires by hand, make it user-invoked and pay no context load.

Put shared reference in one authoritative file with explicit links from its consumers. Prefer a plain reference file when it has no independent invocation purpose. Loading reference material does not authorize running a separate user-invoked workflow.

## Splitting by invocation

The invocation cut of splitting (the sequence cut lives in `SKILL.md`): split off a model-invoked skill when you have a distinct leading word that should trigger it on its own — a trigger word you actually use in your prompts — or another skill must reach it. You pay context load for the new always-loaded description, so that independent reach has to be worth it.

## Router skills

When user-invoked skills multiply past what you can remember, that piled-up cognitive load is cured by a **router skill**: one user-invoked skill that names the others and when to reach for each, so the human has one skill to remember instead of many. State whether the router recommends a next command or carries out a workflow the user has requested. Use explicit file links and honor invocation restrictions supported by the consumer; avoid inventing a permission gate merely because a file is not automatically discovered.
