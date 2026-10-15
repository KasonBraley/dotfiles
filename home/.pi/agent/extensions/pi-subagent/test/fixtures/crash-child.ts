import { WorkerPool, transcriptLines } from "../../workers.ts";
import { call, fauxModels, lastText, MODEL, waitFor } from "../support.ts";

const [directory, cwd] = process.argv.slice(2);
if (!directory || !cwd) throw new Error("Usage: crash-child <directory> <cwd>");
const models = fauxModels(request => {
  const last = lastText(request);
  if (last.role === "user") return call("bash", { command: "sleep 5; echo finished-too-late" });
  return new Promise(() => {});
});
const pool = await WorkerPool.open({ directory, models, defaultCwd: cwd, deliver() {}, lockRetries: 0 });
await pool.spawn({ name: "survivor", task: "Run the slow command and report its output.", model: MODEL, thinkingLevel: "off", cwd, tools: ["bash"] });
const view = await pool.view("survivor");
await waitFor(() => transcriptLines(view.value).some(line => line.startsWith("⚙ bash")), "The worker never started its tool call.");
await new Promise(resolve => setTimeout(resolve, 400));
process.stdout.write("killing\n");
process.kill(process.pid, "SIGKILL");
