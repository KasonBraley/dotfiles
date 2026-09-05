---
name: diagnosing-bugs
description: Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this",
  or reports something broken/throwing/failing/slow.
---

# Diagnosing Bugs

Use this evidence-driven loop for hard bugs and performance regressions. For a straightforward defect, inspect the
cause, make the authorized fix, and run the smallest meaningful check. Scale the phases to the uncertainty; briefly
explain any material verification limit.

When the failing system is Go, read [`references/go-diagnostics.md`](references/go-diagnostics.md) before building the
feedback loop and use its Go-specific evidence and tools within the phases below.

When exploring the codebase, read `CONTEXT.md` (if it exists) to get a clear mental model of the relevant modules, and
check ADRs in the area you're touching.

## Redact

This skill has you show commands, outputs and captured artifacts. **Redact every secret first** — write `<REDACTED>` in
its place. Build loops against env vars, so the credential stays in the environment rather than in what you show.
Captured artifacts carry auth headers: quote only the lines that carry the signal.

If redaction removes necessary evidence, seek a safe derived observation or local probe first. Ask only for the specific
missing evidence; keep credentials out of the conversation.

## Phase 1 — Build a feedback loop

Prefer a fast, repeatable signal that fails on the user's symptom. Read code, logs, configuration, and history as needed
to build it. Use the cheapest available probe that distinguishes a broken result from a correct one; stop optimizing the
harness once it supports the investigation.

### Ways to construct one — try them in roughly this order

1. **Failing test** at whatever seam reaches the bug — unit, integration, e2e.
2. **Curl / HTTP script** against a running dev server.
3. **CLI invocation** with a fixture input, diffing stdout against a known-good snapshot.
4. **Headless browser script** (Playwright / Puppeteer) — drives the UI, asserts on DOM/console/network.  Read
   [`screenshot`](../screenshot/SKILL.md) when only screenshots are needed and not full tests.
5. **Replay a captured trace.** Save a real network request / payload / event log to disk; replay it through the code
   path in isolation.
6. **Throwaway harness.** Spin up a minimal subset of the system (one service, mocked deps) that exercises the bug code
   path with a single function call.
7. **Property / fuzz loop.** For intermittent wrong output, use a bounded run with reproducible seeds and look for the
   specific failure mode.
8. **Bisection harness.** If the bug appeared between two known states (commit, dataset, version), automate "boot at
   state X, check, repeat" so you can `git bisect run` it.
9. **Differential loop.** Run the same input through old-version vs new-version (or two configs) and diff outputs.
10. **HITL bash script.** Last resort. If a human must click, drive _them_ with `scripts/hitl-loop.template.sh` so the
    loop is still structured. Captured output feeds back to you.

### Tighten the loop

Treat the loop as a product. Once you have _a_ loop, **tighten** it:

- Can I make it faster? (Cache setup, skip unrelated init, narrow the test scope.)
- Can I make the signal sharper? (Assert on the specific symptom, not "didn't crash".)
- Can I make it more deterministic? (Pin time, seed RNG, isolate filesystem, freeze network.)

Prefer faster, more deterministic feedback when the improvement costs less than the investigation it saves. A slow but
faithful integration repro is still useful evidence.

### Non-deterministic bugs

Measure the reproduction rate over a bounded number of attempts. Increase it with targeted repetition, stress, or
controlled scheduling when useful. Record attempts, failures, and conditions; a rare failure remains useful evidence,
and one green run does not prove a fix.

### When a runnable repro is unavailable

State what you tried and what remains unverified. Continue static tracing, log analysis, and clearly labelled hypotheses
where they can narrow the cause. Prepare a targeted probe or candidate fix when evidence supports it, distinguishing a
suspected cause from a verified one. Ask for the smallest missing input: access to the reproducing environment, a
redacted artifact, or authorization for specific production instrumentation. Keep working on independent evidence while
that input is pending.

### Completion criterion

Identify the command or observation that can catch the user's symptom and record its result if runnable. State its
limits: reproduction rate, runtime, or required human interaction. Move on once it can guide the investigation, or
continue with the explicit evidence gap described above. Never claim to have reproduced a bug from static reasoning
alone.

## Phase 2 — Reproduce + minimise

Run the loop. Watch it go red — the bug appears.

Confirm:

- [ ] The loop produces the failure mode the **user** described — not a different failure that happens to be nearby.
  Wrong bug = wrong fix.
- [ ] The failure is reproducible across multiple runs (or, for non-deterministic bugs, reproducible at a high enough
  rate to debug against).
- [ ] You have captured the exact symptom (error message, wrong output, slow timing) so later phases can verify the fix
  actually addresses it.

### Minimise

Once it's red, shrink the repro to the **smallest scenario that still goes red**. Cut inputs, callers, config, data, and
steps **one at a time**, re-running the loop after each cut — keep only what's load-bearing for the failure.

Why bother: a minimal repro shrinks the hypothesis space in Phase 3 (fewer moving parts left to suspect) and becomes the
clean regression test in Phase 5.

Minimize until the repro distinguishes plausible causes and is practical to rerun. A mathematically minimal repro is
unnecessary; keep the original scenario for final verification.

## Phase 3 — Hypothesise

Rank the plausible causes supported by the evidence. Compare alternatives when the cause is uncertain; a directly
established defect needs no invented hypotheses to fill a quota.

Each hypothesis must be **falsifiable**: state the prediction it makes.

> Format: "If <X> is the cause, then <changing Y> will make the bug disappear / <changing Z> will make it worse."

If you cannot state the prediction, the hypothesis is a vibe — discard or sharpen it.

For a substantial investigation, give a brief progress update with the leading hypotheses and next probe, then proceed.
Reuse any evidence or ruled-out causes the user has supplied.

## Phase 4 — Instrument

Each probe must map to a specific prediction from Phase 3. **Change one variable at a time.**

Tool preference:

1. **Debugger / REPL inspection** if the env supports it. One breakpoint beats ten logs.
2. **Targeted logs** at the boundaries that distinguish hypotheses.
3. Never "log everything and grep".

**Tag every debug log** with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup at the end becomes a single grep. Untagged
logs survive; tagged logs die.

**Perf branch.** For performance regressions, logs are usually wrong. Instead: establish a baseline measurement (timing
harness, `performance.now()`, profiler, query plan), then bisect. Measure first, fix second.

## Phase 5 — Fix + regression test

Prefer a regression test **before the fix** when it independently establishes the bug and a **correct seam** exists.
Reuse a test already demonstrating the failure; for low-impact edits where a test would merely mirror the
implementation, use a focused behavioral or configuration check and report it.

A correct seam is one where the test exercises the **real bug pattern** as it occurs at the call site. If the only
available seam is too shallow (single-caller test when the bug needs multiple callers, unit test that can't replicate
the chain that triggered the bug), a regression test there gives false confidence.

**If no correct seam exists, that itself is the finding.** Note it. The codebase architecture is preventing the bug from
being locked down. Flag this for the next phase.

If a correct seam exists:

1. Turn the minimised repro into a failing test at that seam.
2. Watch it fail.
3. Apply the fix.
4. Watch it pass.
5. Re-run the Phase 1 feedback loop against the original (un-minimised) scenario.

## Phase 6 — Cleanup + post-mortem

Required before declaring done:

- [ ] Original repro passes after the final relevant edit, or the verification limit is reported; reuse Phase 5's result
  if the code and conditions are unchanged
- [ ] Regression coverage or the selected focused check passes, or its absence is documented
- [ ] All `[DEBUG-...]` instrumentation removed (`grep` the prefix)
- [ ] Throwaway prototypes deleted (or moved to a clearly-marked debug location)
- [ ] State the cause and evidence in the final result, and in a commit / PR message if that artifact is authorized

Consider what would have prevented the bug. If concrete architectural friction remains, briefly recommend a follow-up
architecture review with the evidence. Start that separate workflow only when requested; finish the current fix first.
