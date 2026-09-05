---
name: code-review
description: "Review committed, staged, or working-tree changes along two axes: documented standards and the originating spec. Use for branch/PR reviews, work-in-progress reviews, or review since a fixed point."
---

# Code Review

Review the same pinned change scope along two independent axes:

- **Standards:** does the change follow the governing rules and preserve correctness?
- **Spec:** does it implement the requested behavior without unrelated scope?

Review is **read-only**. Leave source, tests, index, and commits unchanged. Report repairs for the implementing agent; loading a standards skill does not authorize its implementation steps. Inspect relevant unchanged callers, dependencies, and tests as well as the diff. Run checks only when permitted and report missing verification.

Use parallel subagents when available. Without them, run two separate passes and disclose that their contexts were not isolated.

## 1. Pin the scope

Read `git status --short` before selecting changes. Reuse the baseline and scope supplied by the implementing agent. Otherwise identify the user's intended mode and fixed point; ask when ambiguous. Resolve the base to a commit SHA and record the current `HEAD` SHA before review.

| Mode | Comparison | Included |
| --- | --- | --- |
| `branch` | merge-base of the supplied base and `HEAD` → `HEAD` | Committed branch changes only |
| `staged` | supplied base (normally `HEAD`) → index | Index state relative to base; with `HEAD`, staged changes only |
| `worktree` | supplied base → current working tree | Committed changes since that base plus the net staged/unstaged state of tracked files |

For working-tree implementation review, use the pre-edit `HEAD` baseline. If the user wants branch changes plus work in progress, explicitly resolve the branch's merge-base as the working-tree base. Working-tree mode reviews the final file state, not an intermediate staged version; use staged mode when that intermediate snapshot is the target.

Capture the tracked patch once using [`scripts/review-diff.sh`](scripts/review-diff.sh):

```sh
bash "$skill_dir/scripts/review-diff.sh" "$mode" "$base_sha" > "$review_dir/tracked.diff"
```

Resolve `skill_dir` to this skill's directory and create `review_dir` as a private OS temporary directory. Run the helper from the repository root. It validates refs, uses the selected comparison, and disables external diff/text conversion programs. Record the resolved comparison and relevant commit list (`git log <comparison-base>..<head-sha> --oneline`) alongside the patch.

Read full source at the selected snapshot: `git show <head-sha>:<path>` for branch mode, `git show :<path>` for staged mode, and current files for worktree mode. Apply that rule to unchanged callers and standards/spec files too, except mandatory active instructions still govern. Dirty working files are not evidence of a historical or staged implementation. Resolve unmerged index entries before reviewing a final-state scope, or explicitly agree a conflict-review scope with the user.

For **worktree** mode, also inventory untracked files with `git ls-files --others --exclude-standard -z`. Inspect names first, select files belonging to the task, and snapshot their safe contents for both reviewers; inspect symlinks as links rather than following them outside the repository. Keep credentials and private artifacts out of snapshots and reports. Untracked files are absent from `git diff` and must be explicitly included or listed as excluded with a reason. A new-file-only change is not an empty review.

Preserve the user's unrelated dirty work: list exclusions rather than staging, cleaning, or resetting it. When task edits overlap pre-existing edits, use the supplied pre-edit patch or ask how to attribute them. Fail early on an invalid base. If the selected patch and included untracked inventory are both empty, report "no changes in selected scope" rather than a clean bill of health.

**Complete when:** both axes have the same scope manifest, captured patch, included new files, exclusions, comparison SHA(s), and verification evidence. If source/index/HEAD changes during review, refresh the affected snapshot and findings before concluding.

## 2. Identify the spec

Prefer the explicit spec/ticket/path supplied with the task. Otherwise look for issue references in commits, then matching spec files under the repository's established locations. Use `docs/agents/issue-tracker.md` when fetching tracker material; if unavailable, ask for the spec or tracker instructions rather than making local review depend on setup.

If no spec is available, ask whether to proceed standards-only. On approval, skip the Spec pass and report "no spec available".

## 3. Identify the standards

Read applicable repository instructions, project standards, and accepted architectural decisions. Those govern over personal defaults and smell heuristics. For changed Go code, the Standards axis requires the following skills; call the Skill tool for each of them:

- coding-standards, in **review mode**; follow its applicable reference pointers
- write-discoverable-code
- use-modern-go

For other languages use their project standards rather than loading Go rules.

Read [`references/smells.md`](references/smells.md) for the heuristic baseline. A smell is a labelled judgement call, not a mandatory refactor. Suppress it when project rules or concrete ownership/contract evidence justify the shape. Avoid duplicating diagnostics already confirmed by tooling; an unrun tool is not evidence that its checks passed.

## 4. Run both passes

Give each reviewer the scope manifest, snapshot locations, and permission to inspect relevant surrounding code. Both reviewers remain read-only and must identify evidence gaps. Supply resolved source paths rather than only skill names; if a reviewer cannot access them, supply the relevant contents.

**Standards brief:**

- Read the governing sources and applicable standards in review mode.
- Trace affected contracts through callers and dependencies, not just changed hunks.
- Report actionable violations with location, rule source, consequence, and evidence. Separate defects from heuristic suggestions.
- Read the smell baseline and apply only relevant heuristics.
- Report verification performed, failed, or unavailable.

**Spec brief:**

- Read the full supplied spec and material accepted clarifications.
- Map requirements to implementation and tests, following relevant unchanged code.
- Report missing/partial requirements, incorrect behavior, and unrelated scope. Cite the requirement and affected code for each finding.
- Distinguish actual gaps from missing evidence; do not infer correctness from the absence of a changed line.

Keep findings concise but complete. For a large review, summarize in the conversation and put the complete findings in a private temporary report; never silently drop findings to meet a word cap.

## 5. Aggregate and hand back

Present `## Standards` and `## Spec` separately. Within each axis rank actionable findings by severity, keeping heuristics distinct. Deduplicate within an axis; cross-reference related findings across axes without hiding either result.

Finish with counts and the worst issue within each axis, scope/exclusions, and verification limits. Say "no findings" only for what was actually reviewed. Hand repairs back to the implementing agent, who addresses or explicitly defers findings, reruns checks, and requests review of material revisions before commit.
