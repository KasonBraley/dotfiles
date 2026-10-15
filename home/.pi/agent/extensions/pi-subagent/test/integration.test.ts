import assert from "node:assert/strict";
import { existsSync } from "node:fs";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";
import { createAgentSession, DefaultResourceLoader, ModelRuntime, SessionManager, SettingsManager, type ExtensionUIContext } from "@earendil-works/pi-coding-agent";
import voiceExtension from "../../pi-voice/index.ts";
import type { CallDependencies } from "../../pi-voice/live/call.ts";
import type { Channel, LiveEvent } from "../../pi-voice/live/protocol.ts";
import subagentExtension from "../index.ts";
import offlineProvider from "./fixtures/offline-provider.ts";
import { waitFor } from "./support.ts";

test("real Pi voice orchestrates in-process durable workers, stays conversational, and resumes work after the parent session closes", { timeout: 60_000 }, async () => {
  const directory = await mkdtemp(join(tmpdir(), "pi-durable-integration-"));
  const agentDir = join(directory, "agent");
  const originalAgentDir = process.env.PI_CODING_AGENT_DIR;
  process.env.PI_CODING_AGENT_DIR = agentDir;
  let emit: (event: LiveEvent) => void = () => {};
  const replies: { text: string; channel: Channel; id?: string }[] = [];
  const errors: string[] = [];
  const dependencies: CallDependencies = {
    async authenticate() { return { token: "fixture-token", accountID: "fixture-account" }; },
    async audio() { return { async start() { return "v=0\r\n"; }, async answer() {}, mute() {}, clear() {}, async close() {} }; },
    async create() { return { sdp: "v=0\r\n", callID: "rtc_test" }; },
    async connect(input) { emit = input.onEvent; return { append(text, channel, id) { replies.push({ text, channel, id }); }, async close() { return true; } }; },
  };
  const settingsManager = SettingsManager.inMemory({ compaction: { enabled: false }, retry: { enabled: false } });
  const resourceLoader = new DefaultResourceLoader({
    cwd: directory, agentDir, settingsManager,
    noExtensions: true, noSkills: true, noPromptTemplates: true, noThemes: true, noContextFiles: true,
    extensionFactories: [offlineProvider, subagentExtension, pi => voiceExtension(pi, () => dependencies)],
  });
  const results = () => session!.messages.filter(message => message.role === "custom" && message.customType === "subagent-result");
  const spoken = () => replies.filter(reply => /Background worker .* finished:/.test(reply.text));
  let session: Awaited<ReturnType<typeof createAgentSession>>["session"] | undefined;
  try {
    await resourceLoader.reload();
    const runtime = await ModelRuntime.create({ authPath: join(agentDir, "auth.json"), modelsPath: null, refreshOnCreate: false });
    const manager = SessionManager.create(directory, join(directory, "sessions"));
    ({ session } = await createAgentSession({ cwd: directory, agentDir, modelRuntime: runtime, resourceLoader, settingsManager, sessionManager: manager, tools: ["read", "subagent"] }));
    const model = runtime.getModel("subagent-fixture", "fixture");
    assert.ok(model);
    await session.setModel(model);
    session.setThinkingLevel("off");
    await session.bindExtensions({
      mode: "tui",
      uiContext: { notify() {}, setStatus() {}, setWidget() {}, theme: { fg(_color: string, text: string) { return text; } } } as unknown as ExtensionUIContext,
      onError: error => errors.push(error.error),
    });
    const storage = join(agentDir, "durable-subagents", manager.getSessionId());
    assert.ok(!session.getActiveToolNames().includes("subagent"), "subagents must be off by default");
    assert.ok(!existsSync(storage), "disabled subagents must not create storage");
    await session.prompt("/subagents on");
    assert.ok(session.getActiveToolNames().includes("subagent"));
    await session.prompt("/voice");
    emit({ kind: "delegation", id: "voice-alpha", text: "Investigate alpha" });
    await waitFor(() => replies.some(reply => reply.id === "voice-alpha" && reply.channel === "speakable"), "First launch was not acknowledged");
    emit({ kind: "delegation", id: "voice-beta", text: "Also investigate beta independently" });
    await waitFor(() => replies.some(reply => reply.id === "voice-beta" && reply.channel === "speakable"), "Second launch was not acknowledged");
    assert.equal(spoken().length, 0);
    emit({ kind: "delegation", id: "voice-chat", text: "What is two plus two?" });
    await waitFor(() => replies.some(reply => reply.id === "voice-chat" && reply.text === "Four."), "Parent did not remain conversational");
    assert.equal(spoken().length, 0, "Workers should still be running while the parent answers");
    assert.ok(existsSync(join(storage, "workers.sqlite")));
    await waitFor(() => spoken().length === 2, "Worker results did not reach voice");
    for (const name of ["alpha", "beta"]) {
      const result = spoken().find(reply => reply.text.includes(`worker ${name} (`));
      assert.ok(result, `${name} was not spoken`);
      assert.equal(result.id, undefined);
      assert.match(result.text, new RegExp(`Verified ${name} worker result`));
    }
    assert.equal(results().length, 2);
    await session.prompt("/voice-stop");
    await session.prompt("/subagents off");
    assert.ok(!session.getActiveToolNames().includes("subagent"));
    await session.prompt("/subagents on");

    await session.prompt("Investigate gamma");
    const runner = session.extensionRunner;
    await runner.emit({ type: "session_shutdown", reason: "quit" });
    await new Promise(resolve => setTimeout(resolve, 2000));
    assert.equal(results().length, 2, "A closed parent session must not receive results");
    await runner.emit({ type: "session_start", reason: "resume" });
    assert.ok(session.getActiveToolNames().includes("subagent"), "the toggle must persist in the session");
    await waitFor(() => results().length === 3, "Gamma did not resume after the parent session reopened");
    assert.match(JSON.stringify(results().at(-1)), /Verified gamma worker result/);
    await runner.emit({ type: "session_shutdown", reason: "reload" });
    await runner.emit({ type: "session_start", reason: "reload" });
    await new Promise(resolve => setTimeout(resolve, 500));
    assert.equal(results().length, 3, "Reload must not repeat delivered results");
    const notices: string[] = [];
    let rendered: string[] = [];
    const viewer = runner.getCommand("subagent");
    assert.ok(viewer);
    await viewer.handler("", {
      mode: "tui",
      ui: {
        select: async (_title: string, items: string[]) => items.find(item => item.startsWith("gamma")),
        custom: async (factory: (...args: unknown[]) => Promise<{ render(width: number): string[]; handleInput(data: string): void }>) => {
          let chosen: unknown;
          const component = await factory({ requestRender() {} }, { fg: (_color: string, text: string) => text, bold: (text: string) => text }, {}, (value: unknown) => { chosen = value; });
          rendered = component.render(100);
          component.handleInput("x");
          return chosen;
        },
        notify: (message: string) => notices.push(message),
      },
    } as never);
    assert.ok(rendered.some(line => line.includes("Verified gamma worker result")), rendered.join("\n"));
    assert.ok(rendered.some(line => line.includes("› Fixture gamma")));
    assert.match(notices.at(-1) ?? "", /Stopped gamma/);
    assert.deepEqual(errors, []);
  } finally {
    if (session) {
      await session.extensionRunner.emit({ type: "session_shutdown", reason: "quit" });
      session.dispose();
    }
    if (originalAgentDir === undefined) delete process.env.PI_CODING_AGENT_DIR;
    else process.env.PI_CODING_AGENT_DIR = originalAgentDir;
    await rm(directory, { recursive: true, force: true });
  }
});
