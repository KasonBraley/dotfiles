---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Before editing, record the `HEAD` SHA and current status, including the user's pre-existing edits and untracked paths. Preserve unrelated work; retain enough pre-edit evidence to distinguish task changes in overlapping files.

Read applicable project standards before design. For Go, read [`coding-standards`](../coding-standards/SKILL.md) in implementation mode. Use [`tdd`](../tdd/SKILL.md) where possible, selecting seams under the governing coverage policy. Linked files can be read directly when a skill-invocation tool is unavailable.

Run focused checks during implementation and the required full verification at the end.

Use [`code-review`](../code-review/SKILL.md) in **worktree** mode with the recorded pre-edit `HEAD` SHA, spec, task paths, pre-existing-change exclusions, and verification evidence. Include task-owned untracked files. Reviewers report findings without editing.

The implementing agent owns remediation: address findings or agree explicit deferrals with the user, rerun affected checks, and request review of material revisions. Refactoring belongs here after the red → green slices. Repeat until blocking findings are resolved or the user accepts a documented exception.

Commit only the task's reviewed changes to the current branch when the governing task permits committing. Inspect the staged diff before commit to confirm it matches the reviewed state; leave unrelated changes unstaged.

If operating on a ticket:
- Before editing: read ticket, assign, move to In Progress, remove handoff label.
- Before finishing: update acceptance criteria, implementation notes, verification, comment, then move to Review/QA.
