---
name: babysit-pr
description: Get a PR ready to merge. Use when asked to babysit, watch or follow a PR.
---

# Babysit PR

Carry the requested PR task through to completion. Follow the user's scope and repository rules; explicit user
instructions take precedence over this skill's defaults. A request to inspect, review, or edit this skill is not a
request to operate on a PR.

## Scope and authority

Use the PR explicitly identified by the user; otherwise discover the current branch's remote PR. Ask which PR only if
that lookup leaves no clear target. Preserve unrelated working-tree changes and use an isolated checkout when needed.

For a request to get the PR ready to merge, proceed with necessary local fixes, validation, commits, pushes, review
replies, justified thread resolutions, re-review requests, and bounded CI reruns. Reuse that authorization across
iterations. If the user
asks only to monitor or review, report findings within that scope. Merging, deploying, force-pushing, bypassing checks,
and changing repository policy require separate authorization.

Settle routine details from the code, PR, and prior conversation. Ask a focused question only when an unresolved choice
materially affects correctness, scope, or a consequential action. First complete independent authorized work and prepare
a concrete proposal. If a skill causes a pause or departure from the request, link the exact skill/reference,
quote the instruction, and distinguish its requirement from your interpretation.

## Work loop

1. Inspect the PR's open/merged/closed state first on every iteration and before remote writes. If merged or closed,
   stop fixes and polling, and report that outcome. Otherwise inspect its head, target branch, mergeability, CI, and
   review state. For bot findings, full comment
   retrieval, fix/skip decisions, thread handling, and polling, follow
   [references/bot-triage.md](references/bot-triage.md). Use its completion criteria for the bot portion of this task.
2. Investigate failing checks and valid review findings against current code. For early failed-job diagnosis, failure
   classification, and bounded reruns, follow [references/ci-triage.md](references/ci-triage.md). Check review feedback
   before choosing a rerun: an upcoming fix commit takes priority over retrying CI on the old head. Fix branch-related
   issues locally. Resolve merge conflicts using repository conventions. For in-progress conflicts, follow
   [resolving-merge-conflicts](../resolving-merge-conflicts/SKILL.md). Investigate unknown mergeability before counting
   the PR as conflict-free.
3. Run checks appropriate to every fix and complete required repository checks. Add meaningful regression coverage for
   behavioral bugs when feasible; skip tests that merely mirror low-impact edits. Once checks pass, broaden or repeat
   local verification only for new edits, failures, or unresolved concerns.
4. Inspect the diff, commit only task changes, and push to the confirmed PR branch. Record the new remote head. Handle
   review replies and resolutions through the reference, then wait for CI and bot review on that head.
5. Repeat for new failures or findings. Continue independent work while checks or reviews run. If the head changes,
   reassess affected decisions and checks. Finish only when the completion criteria below hold or a concrete blocker
   prevents further progress, or the PR is merged/closed. A slow but progressing check is a reason to wait, not declare
   completion.

## Completion and report

Before reporting ready, refresh the remote state and establish that:

- The PR has no merge conflicts with its current target branch.
- CI is green for the latest head, with all required checks satisfied.
- Bot review meets the reference's completion criteria, with justified dispositions for every finding.

If access, policy, a material decision, or stalled external work blocks completion, state the exact remaining condition
and what is needed to proceed. Preserve useful progress and distinguish verified results from missing evidence.

Finish concisely: readiness, merged/closed outcome, or blocker first, then fixes and verification, retry cycles used,
material skipped findings with reasons, and a
short description of what the PR does. Use links to commits or findings where useful; keep the full triage ledger out of
the final reply unless requested. During polling, report meaningful changes rather than narrating every unchanged check.
