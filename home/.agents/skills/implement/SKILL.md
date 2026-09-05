---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec, tickets, or conversation.

Before editing, record the `HEAD` SHA and current status, including the user's pre-existing edits and untracked paths.
Preserve unrelated work; retain enough pre-edit evidence to distinguish task changes in overlapping files.

Read applicable project standards before design. For Go, read [`coding-standards`](../coding-standards/SKILL.md) in
implementation mode. Use [`tdd`](../tdd/SKILL.md) when requested or when a meaningful failing test helps establish
changed behavior, selecting seams under the governing coverage policy. Existing coverage can suffice for low-impact
changes; avoid tests that only restate the edit. Linked files can be read directly when a skill-invocation tool is
unavailable.

Run focused checks during implementation and complete required repository verification. Reuse passing results for
unchanged work; broaden or repeat checks only for new edits, failures, or unresolved concerns.

Use [`code-review`](../code-review/SKILL.md) in **worktree** mode with the recorded pre-edit `HEAD` SHA, spec, task
paths, pre-existing-change exclusions, and verification evidence. Include task-owned untracked files. Reviewers report
findings without editing.

The implementing agent owns remediation: fix in-scope defects, record non-blocking suggestions or out-of-scope work as
deferred, and ask only when a blocking finding needs a user decision. Rerun affected checks and request review of
material revisions. Refactoring belongs here after the red → green slices. Finish once blocking findings are resolved or
an exception is authorized; unchanged work needs no additional review cycle.

Commit only the task's reviewed changes to the current branch when the governing task permits committing. Inspect the
staged diff before commit to confirm it matches the reviewed state; leave unrelated changes unstaged.

If operating on a ticket, follow the configured tracker workflow within the task's authorization:
- Before editing: read the ticket; assign it, move it to In Progress, and remove the handoff label when applicable.
- Before finishing: record acceptance-criterion results without weakening requirements, implementation notes, and
  verification; move it to Review/QA when appropriate.

Tracker access failures do not block local implementation when the requirements are already available. Report any
pending tracker updates.
