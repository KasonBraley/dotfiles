import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { mkdir, mkdtemp, rm, symlink } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { test } from "node:test";
import { fileURLToPath } from "node:url";
import { type Report, WorkerPool } from "../workers.ts";
import { answer, fauxModels, waitFor } from "./support.ts";

const installed = spawnSync("pi", ["--version"], { encoding: "utf8" });

test("the installed Pi binary loads the extension and a worker started in one process finishes in the next", { skip: installed.status !== 0, timeout: 120_000 }, async () => {
  const directory = await mkdtemp(join(tmpdir(), "pi-durable-host-"));
  const agentDir = join(directory, "agent");
  const sessionId = "019a0000-0000-7000-8000-00000000d00d";
  const packageDir = dirname(fileURLToPath(new URL("../index.ts", import.meta.url)));
  try {
    await mkdir(join(agentDir, "extensions"), { recursive: true });
    await symlink(packageDir, join(agentDir, "extensions", "pi-subagent"), "dir");
    await symlink(fileURLToPath(new URL("./fixtures/offline-provider.ts", import.meta.url)), join(agentDir, "extensions", "offline-provider.ts"));
    const run = (prompt: string, extra: Record<string, string>, session: string[]) => spawnSync("pi", [
      ...session, "--session-dir", join(directory, "sessions"), "--provider", "subagent-fixture", "--model", "fixture", "--thinking", "off",
      "--tools", "read,subagent", "--no-skills", "--no-context-files", "--no-prompt-templates", "--offline", "-p", prompt,
    ], { cwd: directory, encoding: "utf8", timeout: 60_000, env: { ...process.env, PI_CODING_AGENT_DIR: agentDir, ...extra } });
    const disabled = run("Investigate alpha", {}, ["--session-id", sessionId]);
    assert.ok(!existsSync(join(agentDir, "durable-subagents", sessionId)), "subagents must be off by default");
    const sessionPath = () => readdirSync(join(directory, "sessions")).map(name => join(directory, "sessions", name)).find(name => name.includes(sessionId))!;
    assert.match(readFileSync(sessionPath(), "utf8"), /"toolName":"subagent".*"isError":true/, "the disabled tool must not run");
    const enable = run("/subagents on", {}, ["--session", sessionPath()]);
    assert.equal(enable.status, 0, enable.stderr);
    const first = run("Investigate alpha", { FIXTURE_WORKER_DELAY_MS: "1500" }, ["--session", sessionPath()]);
    assert.equal(first.status, 0, first.stderr);
    assert.match(first.stdout, /Launched alpha in the background/);
    const storage = join(agentDir, "durable-subagents", sessionId, "workers.sqlite");
    assert.ok(existsSync(storage), "durable worker storage was not created");
    const sessionFile = readdirSync(join(directory, "sessions")).map(name => join(directory, "sessions", name)).find(name => name.includes(sessionId));
    assert.ok(sessionFile);
    assert.doesNotMatch(readFileSync(sessionFile, "utf8"), /subagent-result/);
    const second = run("What is two plus two?", { FIXTURE_WORKER_DELAY_MS: "1500", FIXTURE_CHAT_DELAY_MS: "5000" }, ["--session", sessionFile]);
    assert.equal(second.status, 0, second.stderr);
    assert.match(second.stdout, /Four\./, second.stderr);
    assert.doesNotMatch(readFileSync(sessionFile, "utf8"), /subagent-result/, "print mode keeps results in the durable outbox");
    const held: Report[] = [];
    const pool = await WorkerPool.open({ directory: dirname(storage), models: fauxModels(() => answer("unused")), defaultCwd: directory, deliver: report => { held.push(report); } });
    try {
      await waitFor(() => held.length === 1, "The worker did not finish in the second Pi process");
      assert.equal(held[0]!.text, "Verified alpha worker result.");
      assert.equal((await pool.summaries())[0]?.status, "idle");
    } finally { await pool.close(); }
    assert.equal(spawnSync("pgrep", ["-f", "pi-subagent-"]).status, 1, "no tmux worker sessions should exist");
  } finally {
    await rm(directory, { recursive: true, force: true });
  }
});
