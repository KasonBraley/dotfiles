# Durable background subagents for Pi and GPT-Live

Background workers built on [Pi Durable](https://github.com/earendil-works/pi/tree/main/packages/durable). Each worker
is a durable conversation in a harness that runs **inside the current Pi process**. There is no tmux, no child Pi
process, and no CLI. See [PROVENANCE.md](PROVENANCE.md) for the upstream pattern this follows.

## Use

Subagents are **off by default**. Turn them on for the current session with `/subagents on`, off with
`/subagents off`, or toggle with `/subagents`. The choice is saved in that session, so resuming it keeps the setting;
new sessions start off. While off, the `subagent` tool is hidden from the model, GPT-Live keeps its original
single-session behavior, and no worker storage is created. Workers already running when you turn it off still finish
and report.

After `/reload` and `/subagents on`, use `/voice` as before:

> Investigate the authentication flow without modifying files.

While that worker runs:

> Also review the test coverage independently.

The current Pi session is the orchestrator. The `subagent` tool returns immediately after `spawn`; small questions stay
in the parent. Every new independent request starts another worker while earlier ones continue. Each verified final
answer is added to the parent session as a `subagent-result` message and spoken during GPT-Live, without starting another
parent model turn. `/voice-stop` ends only voice.

| Tool action | Effect |
| --- | --- |
| `spawn` | Start a named worker with a self-contained `task`, optional `cwd` and `tools` |
| `send` | Steer a busy worker, or queue with `followUp: true`; an idle worker starts a new turn with its history |
| `stop` | Abort that worker's current work and queued messages; edits are not undone; the worker stays usable |
| `list` | Status, model, tools, working directory and accumulated cost per worker |
| `remove` | Forget an idle worker's name; its transcript stays in storage |

`/review [scope]` starts three review workers at once, at `medium` thinking, with `read` and `bash` only:
`review-sol` (`openai-codex/gpt-6.1-sol`), `review-astra` (`openai-codex/gpt-6-astra`) and `review-opus`
(`anthropic/claude-opus-5-5`). Without a scope they review the branch since its merge base plus uncommitted changes.
When the `coderabbit` CLI is on `PATH`, `/review` also starts `review-coderabbit`. It is a durable command task, not a
conversation. It runs `coderabbit review --agent --deep --base <default branch> --include-untracked` (`--deep` only on
CLI 0.8.0+), so it reviews the branch's commits since the base plus staged, unstaged and not-yet-added files. It also passes `--config` with the repository's discovered `.coderabbit.yaml` and its `AGENTS.md`/`CLAUDE.md`,
because explicit `--config` files replace CodeRabbit's own config discovery. A repo that only has
`.coderabbit.config.ts` gets no `--config`. The NDJSON findings become one severity-ordered report, delivered like the
other workers, without model tokens.

CodeRabbit ignores the free-text scope; pass its own flags after `--`, for example
`/review the auth changes -- --uncommitted --dir src`. Any scope flag you pass (`--committed`, `--uncommitted`,
`--include-untracked`) replaces the scope default; `-- --uncommitted --include-untracked` reviews only uncommitted and new files.
`--base`, `--base-commit`, `--deep` and `--config` likewise replace their defaults. `--api-key`, `--remote`, `--show-prompts`, `--usage` and `--agent` are refused.
`--use-credits` is passed only when you type it; otherwise a credit prompt is reported as a failure. So are a nonzero
exit, an `error` event and unreviewed files.

Reviews take 7–30 minutes. A run is stopped after 10 minutes without output or heartbeat, or after 90 minutes total,
and reports its partial findings. If Pi quits mid-review, the CLI is killed and the review reruns when the session
reopens; CodeRabbit may reuse its earlier server review, or the rerun may count as another review. `stop` kills it. It
cannot be steered or watched.

All reviewers are created in one durable commit, so either all start or none do. Running `/review` again replaces
idle reviewers and refuses while one is still working. It works without `/subagents on`; the reviewer list lives in
[review.ts](review.ts) and the CodeRabbit runner in [coderabbit.ts](coderabbit.ts).

`/subagent` opens a live transcript of one worker. In the viewer, `s` steers, `f` queues a follow-up, `x` stops and
`Esc` closes. A status line below the editor shows working and failed workers.

## What Pi Durable provides here

- **One process, many conversations.** The harness scheduler runs every worker's model requests and tool calls as
  durable tasks, concurrently with each other and with the parent Pi session.
- **Durable storage per parent session.** Workers live in
  `<agent-dir>/durable-subagents/<parent-session-id>/workers.sqlite` (`PI_CODING_AGENT_DIR` or `~/.pi/agent`). A lock
  keeps a second Pi process off the same storage; a lock left by a crash goes stale after about ten seconds.
- **Crash and restart recovery.** Every model request and tool call checkpoints before it moves on. `/reload`, quitting
  Pi, switching sessions, or a killed process stops the harness; reopening the same parent session continues each
  worker from its last checkpoint. A cut-off model request is sent again, so it can bill again. `read` reruns after an
  interruption; an interrupted `bash`, `edit` or `write` call is reported to the worker's model as interrupted instead
  of being repeated.
- **Exactly-once reporting.** A background reporter task per message submits it with a request ID, waits for the
  answer and records the report in a durable outbox document in the same commit that ends the task. The extension
  delivers outbox reports to Pi and then acknowledges them. Report IDs already present in the parent transcript are
  acknowledged without being repeated.
- **Ownership.** Workers are owned by background anchor tasks of a hidden root conversation, so they outlive the parent
  turn that started them and the parent's Esc does not stop them.
- **Usage.** Each worker conversation keeps its own usage document; `list` and `/subagent` show its cost.

In print and JSON modes, results stay in the durable outbox so they cannot replace the command's final output. They are
delivered the next time the session opens in the interactive terminal or RPC mode.

## Workers' context, tools and limits

- A worker gets a fresh conversation: the task you send it, the repository's context files, available skills and its
  working directory. It does not see the parent transcript.
- It uses the parent's current model, login and thinking level through Pi's model registry. No API key is added.
- Tools are Pi Durable's `read`, `bash`, `edit` and `write`, limited to those active in the parent. Pi extension
  tools such as `codemode` or web tools are not available to workers.
- Worker tool calls run in this process through Pi Durable's Node execution environment. They do **not** pass through Pi
  extension `tool_call` hooks, so a Pi permission extension would not see them. Pi itself has no per-call approvals by
  default; this setup currently has no permission extension installed.
- Workers share the checkout. Give parallel workers disjoint files, or separate `cwd` values.
- At most eight workers run at once and 32 are retained per parent session. Nested workers are impossible: workers do not
  have the `subagent` tool.
- Without a session file (`--no-session`), storage is a temporary directory removed when Pi quits.

## Install and validate

Requirements: Pi 1.1.0+ and Node 22.19+ (`node:sqlite`). Stow the `home` package as usual, then:

```bash
npm --prefix home/.pi/agent/extensions/pi-subagent ci --workspaces=false --ignore-scripts
npm --prefix home/.pi/agent/extensions/pi-subagent test --workspaces=false
npm --prefix home/.pi/agent/extensions/pi-voice test --workspaces=false
```

The suite makes no network calls. It covers concurrent workers in one process, steer/follow-up/stop/remove, lock
contention, close and reopen, held and deduplicated delivery, a worker killed with `SIGKILL` during a `bash` call
and resumed in a new process, a real Pi session driven by GPT-Live voice with fake audio transports, and the installed
`pi` binary starting a worker in one process that finishes in the next.
