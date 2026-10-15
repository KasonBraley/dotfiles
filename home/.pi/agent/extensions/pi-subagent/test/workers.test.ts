import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import { fileURLToPath } from "node:url";
import type { TaskId } from "@earendil-works/pi-durable";
import { transcriptLines, WorkerPool } from "../workers.ts";
import { answer, call, fauxModels, inbox, lastText, MODEL, until, waitFor } from "./support.ts";

async function scratch(): Promise<string> {
  return mkdtemp(join(tmpdir(), "pi-durable-workers-"));
}

test("two workers run concurrently in one process and each verified answer is delivered exactly once", async () => {
  const directory = await scratch();
  let active = 0;
  let peak = 0;
  let release!: () => void;
  const gate = new Promise<void>(resolve => { release = resolve; });
  const models = fauxModels(async (request, options) => {
    const { text } = lastText(request);
    active++;
    peak = Math.max(peak, active);
    try {
      await until(options?.signal, gate);
      return answer(`Verified ${text.includes("alpha") ? "alpha" : "beta"} result.`);
    } finally { active--; }
  });
  const box = inbox();
  const pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: box.deliver });
  try {
    await pool.spawn({ name: "alpha", task: "Investigate alpha.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] });
    await pool.spawn({ name: "beta", task: "Investigate beta.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read", "bash"] });
    await waitFor(() => peak === 2, "Workers did not run concurrently");
    assert.deepEqual((await pool.summaries()).map(worker => [worker.name, worker.status, worker.tools]), [["alpha", "working", ["read"]], ["beta", "working", ["read", "bash"]]]);
    await assert.rejects(pool.spawn({ name: "alpha", task: "again", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] }), /already exists/);
    release();
    await pool.waitForReports();
    await waitFor(() => box.reports.length === 2, "Reports were not delivered");
    assert.deepEqual(box.reports.map(report => [report.name, report.text, report.failed]).sort(), [["alpha", "Verified alpha result.", false], ["beta", "Verified beta result.", false]]);
    assert.deepEqual((await pool.summaries()).map(worker => worker.status), ["idle", "idle"]);
    await new Promise(resolve => setTimeout(resolve, 100));
    assert.equal(box.reports.length, 2);
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});

test("steer, follow-up, stop and remove act on one named worker without affecting another", async () => {
  const directory = await scratch();
  const gates = new Map<string, () => void>();
  const models = fauxModels(async (request, options) => {
    const { text } = lastText(request);
    if (text.includes("long")) {
      await until(options?.signal, new Promise(resolve => gates.set("long", () => resolve())));
      return answer("Long work finished.");
    }
    if (text.includes("steady")) {
      await until(options?.signal, new Promise(resolve => gates.set("steady", () => resolve())));
      return answer("Steady finished.");
    }
    return answer(`Answered: ${text}`);
  });
  const box = inbox();
  const pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: box.deliver });
  try {
    await pool.spawn({ name: "long", task: "Do long work.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] });
    await pool.spawn({ name: "steady", task: "Do steady work.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] });
    await waitFor(() => gates.size === 2, "Workers did not start");
    assert.match(await pool.send("long", "Then summarize.", true), /Queued a follow-up/);
    assert.match(await pool.stop("long"), /not undone/);
    await waitFor(async () => (await pool.summaries()).find(worker => worker.name === "long")?.status === "stopped", "Stop did not settle");
    assert.equal((await pool.summaries()).find(worker => worker.name === "steady")?.status, "working");
    assert.equal(box.reports.length, 0);
    assert.match(await pool.send("long", "What is left?", false), /Prompted long/);
    await waitFor(() => box.reports.some(report => report.text === "Answered: What is left?"), "Stopped worker did not accept new work");
    await assert.rejects(pool.remove("steady"), /still working/);
    gates.get("steady")!();
    await pool.waitForReports();
    assert.ok(box.reports.some(report => report.name === "steady" && report.text === "Steady finished."));
    assert.match(await pool.remove("steady"), /Removed steady/);
    assert.deepEqual((await pool.summaries()).map(worker => worker.name), ["long"]);
    assert.ok(transcriptLines((await pool.view("long")).value).some(line => line.includes("What is left?")));
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});

test("a second process cannot open the same worker storage, and a closed pool resumes unfinished work", async () => {
  const directory = await scratch();
  let respond = false;
  const first = fauxModels(async (_request, options) => {
    await until(options?.signal, new Promise(() => {}));
    return answer("never");
  });
  const box = inbox();
  let pool = await WorkerPool.open({ directory, models: first, defaultCwd: directory, deliver: box.deliver });
  try {
    await pool.spawn({ name: "durable", task: "Survive a reload.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] });
    await assert.rejects(WorkerPool.open({ directory, models: first, defaultCwd: directory, deliver() {}, lockRetries: 0 }), /another Pi process/);
    await new Promise(resolve => setTimeout(resolve, 100));
    await pool.close();
    respond = true;
    pool = await WorkerPool.open({ directory, models: fauxModels(() => answer(respond ? "Finished after reopening." : "early")), defaultCwd: directory, deliver: box.deliver });
    await pool.waitForReports();
    await waitFor(() => box.reports.length === 1, "Resumed work was not reported");
    assert.equal(box.reports[0]!.text, "Finished after reopening.");
    await pool.close();
    pool = await WorkerPool.open({ directory, models: fauxModels(() => answer("unused")), defaultCwd: directory, deliver: box.deliver });
    await new Promise(resolve => setTimeout(resolve, 150));
    assert.equal(box.reports.length, 1);
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});

test("undeliverable results stay in the durable outbox, and results already in the parent transcript are acknowledged without repeating", async () => {
  const directory = await scratch();
  const models = fauxModels(() => answer("Held result."));
  const offered: TaskId[] = [];
  let pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: report => { offered.push(report.id); return false; } });
  try {
    await pool.spawn({ name: "held", task: "Finish quickly.", model: MODEL, thinkingLevel: "off", cwd: directory, tools: ["read"] });
    await pool.waitForReports();
    await waitFor(() => offered.length >= 1, "Result was not offered");
    await pool.close();
    const later = inbox();
    pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: later.deliver });
    await waitFor(() => later.reports.length === 1, "Held result was not delivered later");
    assert.equal(later.reports[0]!.text, "Held result.");
    assert.equal(later.reports[0]!.id, offered[0]);
    await pool.close();
    pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: report => { offered.push(report.id); return false; } });
    await pool.send("held", "Once more.", false);
    await pool.waitForReports();
    await waitFor(() => offered.length >= 2, "Second result was not offered");
    await pool.close();
    const repeated = inbox();
    pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: repeated.deliver, delivered: new Set([offered.at(-1)!]) });
    await new Promise(resolve => setTimeout(resolve, 150));
    await pool.close();
    pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: repeated.deliver });
    await new Promise(resolve => setTimeout(resolve, 150));
    assert.equal(repeated.reports.length, 0);
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});

test("a worker killed with SIGKILL mid tool call resumes in a new process and reports once", { timeout: 60_000 }, async () => {
  const directory = await scratch();
  const fixture = fileURLToPath(new URL("./fixtures/crash-child.ts", import.meta.url));
  const child = spawnSync(process.execPath, ["--import", "tsx", fixture, join(directory, "store"), directory], { encoding: "utf8", timeout: 30_000 });
  assert.equal(child.signal, "SIGKILL", child.stderr);
  assert.match(child.stdout, /killing/);
  const seen: string[] = [];
  const box = inbox();
  const pool = await WorkerPool.open({
    directory: join(directory, "store"), defaultCwd: directory, deliver: box.deliver,
    models: fauxModels(request => {
      const last = lastText(request);
      seen.push(last.role);
      return last.role === "toolResult" ? answer(`Recovered after interruption: ${last.text}`) : call("bash", { command: "echo unexpected" });
    }),
  });
  try {
    await pool.waitForReports();
    await waitFor(() => box.reports.length === 1, "The crashed worker was not resumed");
    assert.match(box.reports[0]!.text, /^Recovered after interruption:/);
    assert.ok(!box.reports[0]!.text.includes("finished-too-late"));
    assert.deepEqual(seen, ["toolResult"]);
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});
