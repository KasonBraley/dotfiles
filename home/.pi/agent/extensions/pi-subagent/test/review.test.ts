import assert from "node:assert/strict";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import { REVIEWERS, reviewRequests } from "../review.ts";
import { WorkerPool } from "../workers.ts";
import { answer, fauxModels, inbox, lastText, MODEL, until, waitFor } from "./support.ts";

test("review requests start sol, astra and opus at medium effort with read-only tools and the given scope", () => {
  const requests = reviewRequests("the staged diff", "/repo", ["read", "bash"]);
  assert.deepEqual(requests.map(request => [request.name, `${request.model.provider}/${request.model.modelId}`, request.thinkingLevel, request.tools]), [
    ["review-sol", "openai-codex/gpt-6.1-sol", "medium", ["read", "bash"]],
    ["review-astra", "openai-codex/gpt-6-astra", "medium", ["read", "bash"]],
    ["review-opus", "anthropic/claude-opus-5-5", "medium", ["read", "bash"]],
  ]);
  assert.match(requests[0]!.task, /Scope: the staged diff/);
  assert.match(reviewRequests("", "/repo", ["read"])[0]!.task, /merge base with the default branch/);
});

test("launch starts every reviewer in one commit, refuses while one is working, and replaces idle ones", async () => {
  const directory = await mkdtemp(join(tmpdir(), "pi-durable-review-"));
  let release!: () => void;
  let gate = new Promise<void>(resolve => { release = resolve; });
  let started = 0;
  const models = fauxModels(async (request, options) => {
    started++;
    await until(options?.signal, gate);
    return answer(`Reviewed: ${lastText(request).text.slice(0, 20)}`);
  });
  const box = inbox();
  const pool = await WorkerPool.open({ directory, models, defaultCwd: directory, deliver: box.deliver });
  const requests = () => reviewRequests("", directory, ["read"]).map(request => ({ ...request, model: MODEL, thinkingLevel: "off" }));
  try {
    await pool.launch({ agents: requests() }, { replaceIdle: true });
    await waitFor(() => started === REVIEWERS.length, "Reviewers did not run concurrently");
    await assert.rejects(pool.launch({ agents: requests() }, { replaceIdle: true }), /still working/);
    await assert.rejects(pool.launch({ agents: requests() }), /already exists/);
    release();
    await pool.waitForReports();
    await waitFor(() => box.reports.length === REVIEWERS.length, "Reviews were not delivered");
    gate = new Promise<void>(resolve => { release = resolve; });
    const before = (await pool.summaries()).map(worker => worker.conversationId);
    await pool.launch({ agents: requests() }, { replaceIdle: true });
    const after = await pool.summaries();
    assert.deepEqual(after.map(worker => [worker.name, worker.status]), REVIEWERS.map(reviewer => [reviewer.name, "working"]));
    assert.ok(after.every(worker => !before.includes(worker.conversationId)), "replaced reviewers must get fresh conversations");
    release();
    await pool.waitForReports();
    await waitFor(() => box.reports.length === REVIEWERS.length * 2, "Second reviews were not delivered");
  } finally {
    await pool.close();
    await rm(directory, { recursive: true, force: true });
  }
});
