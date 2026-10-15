import type { AssistantMessage, JsonObject, Models, SimpleStreamOptions, TranscriptContext } from "@earendil-works/pi-ai";
import { createModels } from "@earendil-works/pi-ai/models";
import { fauxAssistantMessage, fauxProvider, fauxText, fauxToolCall } from "@earendil-works/pi-ai/providers/faux";
import type { Report } from "../workers.ts";

export const MODEL = { provider: "faux", modelId: "faux-1" };

export function lastText(request: TranscriptContext): { role: string; text: string } {
  const last = request.messages.findLast(message => message.role !== "system");
  if (!last) return { role: "none", text: "" };
  const content = typeof last.content === "string" ? [{ type: "text", text: last.content }] : last.content;
  return { role: last.role, text: content.flatMap(part => (part.type === "text" ? [part.text] : [])).join("") };
}

export function until(signal: AbortSignal | undefined, gate: Promise<void>): Promise<void> {
  return new Promise((resolve, reject) => {
    if (signal?.aborted) return reject(new Error("aborted"));
    signal?.addEventListener("abort", () => reject(new Error("aborted")), { once: true });
    void gate.then(resolve);
  });
}

export type Route = (request: TranscriptContext, options: SimpleStreamOptions | undefined) => AssistantMessage | Promise<AssistantMessage>;

export function fauxModels(route: Route): Models {
  const faux = fauxProvider();
  const models = createModels();
  models.setProvider(faux.provider);
  faux.setResponses(Array.from({ length: 200 }, () => (request: TranscriptContext, options: SimpleStreamOptions | undefined) => route(request, options)));
  return models;
}

export const answer = (text: string) => fauxAssistantMessage([fauxText(text)]);
export const call = (name: string, args: JsonObject) => fauxAssistantMessage([fauxToolCall(name, args)], { stopReason: "toolUse" });

export async function waitFor(predicate: () => boolean | Promise<boolean>, message: string, timeout = 20_000): Promise<void> {
  const deadline = Date.now() + timeout;
  while (!(await predicate())) {
    if (Date.now() > deadline) throw new Error(message);
    await new Promise(resolve => setTimeout(resolve, 20));
  }
}

export function inbox() {
  const reports: Report[] = [];
  return { reports, deliver: (report: Report) => { reports.push(report); } };
}
