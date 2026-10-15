import type { AssistantMessage } from "@earendil-works/pi-ai";
import { createAssistantMessageEventStream } from "@earendil-works/pi-ai/compat";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function text(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content.map(part => (part?.type === "text" ? part.text : "")).join("\n");
}

export default function offlineProvider(pi: ExtensionAPI): void {
  pi.registerProvider("subagent-fixture", {
    api: "openai-completions", apiKey: "fixture", baseUrl: "https://fixture.invalid",
    models: [{ id: "fixture", name: "fixture", reasoning: false, input: ["text"], contextWindow: 32768, maxTokens: 1024, cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 } }],
    streamSimple(model, context, options) {
      const stream = createAssistantMessageEventStream();
      const messages = context.messages.filter(message => message.role !== "system");
      const last = messages.at(-1);
      const prompt = text(messages.findLast(message => message.role === "user")?.content);
      const worker = prompt.startsWith("Fixture ");
      const task = prompt.match(/\b(alpha|beta|gamma)\b/)?.[1] ?? "unknown";
      let stopReason: AssistantMessage["stopReason"] = "stop";
      let content: AssistantMessage["content"];
      if (worker) content = [{ type: "text", text: `Verified ${task} worker result.` }];
      else if (prompt.includes("two plus two")) content = [{ type: "text", text: "Four." }];
      else if (last?.role === "toolResult") content = [{ type: "text", text: `Launched ${task} in the background; it has not finished yet.` }];
      else {
        stopReason = "toolUse";
        content = [{ type: "toolCall", id: `launch-${task}-${Date.now()}`, name: "subagent", arguments: { action: "spawn", name: task, task: `Fixture ${task}: provide the verified ${task} result without accessing files.`, tools: "read" } }];
      }
      const message: AssistantMessage = {
        role: "assistant", api: model.api, provider: model.provider, model: model.id, content, stopReason, timestamp: Date.now(),
        usage: { input: 10, output: 5, cacheRead: 0, cacheWrite: 0, totalTokens: 15, cost: { input: 0.001, output: 0.001, cacheRead: 0, cacheWrite: 0, total: 0.002 } },
      };
      const delay = worker ? Number(process.env.FIXTURE_WORKER_DELAY_MS ?? 1500) : prompt.includes("two plus two") ? Number(process.env.FIXTURE_CHAT_DELAY_MS ?? 10) : 10;
      const timer = setTimeout(() => { stream.push({ type: "done", reason: stopReason as "stop", message }); stream.end(message); }, delay);
      options?.signal?.addEventListener("abort", () => {
        clearTimeout(timer);
        const aborted: AssistantMessage = { ...message, content: [], stopReason: "aborted", errorMessage: "aborted" };
        stream.push({ type: "error", reason: "aborted", error: aborted });
        stream.end(aborted);
      }, { once: true });
      return stream;
    },
  });
}
