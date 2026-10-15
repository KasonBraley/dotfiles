# Provenance

This extension is built on `@earendil-works/pi-durable` 1.1.0 (MIT, Earendil Works), installed from npm and pinned in
`package-lock.json`. Its `chord` dependency is pinned to the same release as Pi 1.1.0.

The worker design follows Pi Durable's persistent background subagent example,
[`test/examples/23-subagent-background.ts`](https://github.com/earendil-works/pi/blob/ce950d78f424dcaf9f5d6a03ce80ab141130eb1d/packages/durable/test/examples/23-subagent-background.ts)
at revision `ce950d78f424dcaf9f5d6a03ce80ab141130eb1d`: a background anchor task owns each worker conversation, and a
background reporter task delivers each message and records its answer. Local changes:

- The parent is the Pi coding agent rather than a durable conversation. Reporters write to a durable outbox document;
  the Pi extension delivers outbox entries as `subagent-result` messages and GPT-Live events, then acknowledges them.
- Stopping a worker also aborts its reporters that have not submitted yet, so a queued message cannot start new work
  after the stop.
- Worker status, pending counts, tools, model and working directory are stored in the same document; cost comes from
  each worker's `pi.usage` document.
- Workers use Pi's model registry through a small `Models` adapter, Pi Durable's `CodingTools`, and a prompt section
  with the repository's context files and skills.
- Storage is SQLite per parent Pi session, guarded by `proper-lockfile` like Pi's experimental durable coding agent.

The earlier tmux implementation vendored from `badlogic/pi-subagent` was removed together with its CLI wrapper.
