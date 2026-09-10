# CI triage

Use when a PR check fails or a rerun is being considered. Follow the [parent workflow](../SKILL.md) for scope,
local fixes, verification, pushes, and completion. These rules adapt the useful CI mechanics from
[Codex's PR babysitter][upstream]; they do not extend monitoring beyond this skill's ready-to-merge goal.

## Diagnose as soon as a job fails

Use the confirmed PR's base repository as `repo`. Identify the workflow run from the failed check and verify its
`headSha` belongs to the current PR evaluation before acting. Some PR workflows evaluate a synthetic merge commit;
verify that association rather than treating every SHA mismatch as unrelated. Read-only inspection:

```bash
gh run view "$run_id" --repo "$repo" --json jobs,name,workflowName,conclusion,status,url,headSha
gh api --paginate --slurp "repos/$repo/actions/runs/$run_id/jobs?per_page=100"
```

If an individual job has failed while sibling jobs are running, fetch that job's logs immediately. Do not wait for the
whole workflow to finish before diagnosing. Set `job_id` from the jobs response and save logs outside the repository:

```bash
job_log=$(mktemp)
gh api "repos/$repo/actions/jobs/$job_id/logs" > "$job_log"
```

Read the saved output completely enough to identify the failure; an unavailable log is missing evidence, not proof of a
flake. After the overall run finishes, `gh run view "$run_id" --repo "$repo" --log-failed` is another option.
For checks hosted outside GitHub Actions, use the check's provider and logs; Actions rerun commands do not apply.

Classify from logs and current code:

- **Branch-related:** a compile, test, lint, typecheck, snapshot, or config failure caused by this PR. Fix it through
  the parent workflow. A failing check alone does not establish that the branch caused it.
- **Likely transient/unrelated:** evidence points to network/registry outages, runner provisioning, service limits, or a
  known intermittent failure unrelated to this PR. Consider a bounded rerun; preserve unrelated code and CI policy.
- **Unclear or persistent external failure:** inspect available job logs and relevant code before choosing a remedy.
  Continue independent work and report a concrete blocker if evidence or an external recovery is still needed.

## Rerun only when it avoids wasted work

Before a rerun, re-fetch PR state, current head, published review feedback, and the run's current attempt/status. If an
accepted review or CI fix will produce a new commit now, finish and push it first; skip rerunning the superseded head.
If the change is explicitly deferred, a rerun of the current head can still be useful. Diagnose failed jobs in parallel
with ongoing work, but wait for the selected workflow run to finish before rerunning it.

For an authorized, plausibly transient failure, rerun failed jobs only:

```bash
# Write operation: run_id must still be a failed run for the current PR evaluation.
gh run rerun "$run_id" --repo "$repo" --failed
```

Keep a retry ledger outside the repo alongside task state, keyed by base repository, PR number, and PR head SHA. Record
run IDs/attempts, failure classification, retry timestamps, and cycles used. Default to at most **three retry cycles per
head SHA**, honoring any user or repository limit. A cycle is one batch of selected failed runs; record each successful
rerun immediately so partial batches or session restarts do not lose the budget. Reconcile uncertain command outcomes
against remote run attempts before retrying. Polling, watcher restarts, and reopening the task do not reset counters;
a new PR head gets its own budget.

After a rerun, resume polling and wait for that attempt before retrying. Honor provider backoff or outage notices.
If transient failures persist after the budget, report the logs, retries, and required external recovery; do not
turn an unrelated outage into a code change. Budget exhaustion limits reruns, not investigation or valid
branch fixes. Keep retry history when summarizing a blocker or handing off the task.
