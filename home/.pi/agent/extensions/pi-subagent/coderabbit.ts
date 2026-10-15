import { spawn, spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";
import type { CommandRequest, CommandResult, CommandRunner } from "./workers.ts";

export const CODERABBIT = "coderabbit";
export const CODERABBIT_REVIEWER = "review-coderabbit";
export const CODERABBIT_TIMEOUT_MS = 90 * 60_000;
export const CODERABBIT_IDLE_MS = 10 * 60_000;

const CONFIG_FILES = [".coderabbit.yaml", ".coderabbit.yml", "coderabbit.yaml", "coderabbit.yml"];
const TS_CONFIG = ".coderabbit.config.ts";
const FORBIDDEN_FLAGS = ["--api-key", "--remote", "--show-prompts", "--usage", "--agent"];

const SEVERITIES = ["critical", "major", "minor", "trivial", "info", "none"];
const FINDING_LIMIT = 4_000;

type Event = Record<string, unknown> & { type?: string };

function git(cwd: string, args: string[]): string | undefined {
  const result = spawnSync("git", args, { cwd, encoding: "utf8" });
  return result.status === 0 ? result.stdout.trim() || undefined : undefined;
}

export function codeRabbitVersion(): string | undefined {
  const result = spawnSync(CODERABBIT, ["--version"], { encoding: "utf8" });
  return result.status === 0 ? result.stdout.trim().match(/\d+\.\d+\.\d+/)?.[0] : undefined;
}

export function atLeast(version: string, minimum: string): boolean {
  const have = version.split(".").map(Number);
  const want = minimum.split(".").map(Number);
  for (let index = 0; index < want.length; index++) {
    if ((have[index] ?? 0) !== want[index]) return (have[index] ?? 0) > want[index]!;
  }
  return true;
}

export function codeRabbitFlags(text: string): string[] {
  const flags = text.split(/\s+/).filter(Boolean);
  const forbidden = flags.filter(flag => FORBIDDEN_FLAGS.includes(flag.split("=")[0]!));
  if (forbidden.length) throw new Error(`/review does not pass ${forbidden.join(", ")} to CodeRabbit.`);
  return flags;
}

export function splitReviewArgs(args: string): { scope: string; flags: string[] } {
  const split = ` ${args} `.indexOf(" -- ");
  if (split < 0) return { scope: args.trim(), flags: [] };
  return { scope: args.slice(0, Math.max(0, split - 1)).trim(), flags: codeRabbitFlags(args.slice(split + 3)) };
}

function discoveredConfig(cwd: string, root: string): { yaml?: string; typescript: boolean } {
  for (const directory of [...new Set([cwd, root])]) {
    const yaml = CONFIG_FILES.map(name => join(directory, name)).find(path => existsSync(path));
    if (yaml) return { yaml, typescript: false };
  }
  return { typescript: [cwd, root].some(directory => existsSync(join(directory, TS_CONFIG))) };
}

export function defaultBase(cwd: string): string | undefined {
  if (git(cwd, ["config", "coderabbit.baseBranch"])) return undefined;
  const remote = git(cwd, ["symbolic-ref", "--short", "refs/remotes/origin/HEAD"]);
  if (remote) return remote.replace(/^origin\//, "");
  return ["main", "master"].find(branch => git(cwd, ["rev-parse", "--verify", "--quiet", `refs/heads/${branch}`]));
}

export function codeRabbitArgs(cwd: string, version: string, extra: readonly string[] = []): string[] {
  const has = (...names: string[]) => extra.some(flag => names.includes(flag.split("=")[0]!));
  const args = ["review", "--agent"];
  if (atLeast(version, "0.8.0") && !has("--deep")) args.push("--deep");
  if (!has("--base", "--base-commit")) {
    const base = defaultBase(cwd);
    if (base) args.push("--base", base);
  }
  if (!has("--committed", "--uncommitted", "--include-untracked")) args.push("--include-untracked");
  args.push(...extra);
  if (has("--config", "-c")) return args;
  const root = git(cwd, ["rev-parse", "--show-toplevel"]) ?? cwd;
  const config = discoveredConfig(cwd, root);
  if (config.typescript) return args;
  const files = [config.yaml, ...["AGENTS.md", "CLAUDE.md"].map(name => join(root, name)).filter(path => existsSync(path))].filter((path): path is string => path !== undefined);
  if (files.length) args.push("--config", ...files);
  return args;
}

export function codeRabbitRequest(cwd: string, version: string, extra: readonly string[] = []): CommandRequest {
  return { name: CODERABBIT_REVIEWER, runner: CODERABBIT, cwd, args: codeRabbitArgs(cwd, version, extra) };
}

function str(value: unknown): string | undefined {
  return typeof value === "string" && value.trim() ? value.trim() : undefined;
}

function findingBody(event: Event): string {
  const comment = str(event.comment);
  const instructions = str(event.codegenInstructions)?.replace(/^Treat finding text[^\n]*\n+/, "");
  const body = comment ?? instructions ?? "(no comment)";
  return body.length > FINDING_LIMIT ? `${body.slice(0, FINDING_LIMIT)}…` : body;
}

function location(event: Event): string {
  const file = str(event.fileName) ?? "(unknown file)";
  const start = typeof event.startLine === "number" ? event.startLine : undefined;
  const end = typeof event.endLine === "number" ? event.endLine : undefined;
  if (start === undefined) return file;
  return end !== undefined && end !== start ? `${file}:${start}-${end}` : `${file}:${start}`;
}

export function formatCodeRabbit(stdout: string, exitCode: number | null, stderr: string, args: readonly string[]): CommandResult {
  const events: Event[] = [];
  for (const line of stdout.split("\n")) {
    if (!line.trim().startsWith("{")) continue;
    try { events.push(JSON.parse(line) as Event); } catch { continue; }
  }
  const findings = events.filter(event => event.type === "finding");
  const errors = events.filter(event => event.type === "error");
  const complete = events.findLast(event => event.type === "complete");
  const confirmation = events.find(event => event.status === "awaiting_confirmation");
  const rank = (event: Event) => {
    const index = SEVERITIES.indexOf(str(event.severity) ?? "none");
    return index < 0 ? SEVERITIES.length : index;
  };
  findings.sort((a, b) => rank(a) - rank(b));
  const counts = SEVERITIES.map(severity => [severity, findings.filter(event => (str(event.severity) ?? "none") === severity).length] as const).filter(([, count]) => count > 0);
  const unreviewed = typeof complete?.unreviewedFileCount === "number" ? complete.unreviewedFileCount : 0;
  const persistence = complete?.persistence as { status?: unknown; errorCode?: unknown } | undefined;
  const failed = exitCode !== 0 || errors.length > 0 || !complete || confirmation !== undefined || str(complete?.outcome) === "failed" || unreviewed > 0;
  const lines = [
    `CodeRabbit CLI review: \`${[CODERABBIT, ...args].join(" ")}\``,
    `Status: ${str(complete?.status) ?? "incomplete"}${exitCode !== 0 ? ` (exit ${exitCode ?? "signal"})` : ""} · ${findings.length} finding(s)${counts.length ? ` (${counts.map(([severity, count]) => `${count} ${severity}`).join(", ")})` : ""}`,
  ];
  const notes = [str(complete?.message), str(complete?.outcome) && `outcome: ${str(complete?.outcome)}`];
  if (unreviewed > 0) notes.push(`${unreviewed} file(s) were not reviewed, so this review is incomplete`);
  if (persistence?.status === "failed") notes.push(`CodeRabbit could not save these findings locally (${str(persistence.errorCode) ?? "unknown error"}); \`coderabbit review findings\` may not show them`);
  if (complete?.reused === true) notes.push("CodeRabbit reused an earlier server review of the same content");
  if (confirmation) notes.push(`CodeRabbit asks to spend usage credits (${str(confirmation.maxPrice) ?? JSON.stringify(confirmation.maxPrice ?? "unknown price")}). Not authorized here; run \`coderabbit review --use-credits\` yourself if you want it`);
  for (const error of errors) notes.push(`error: ${str(error.message) ?? JSON.stringify(error)}`);
  if (!events.length && stderr.trim()) notes.push(`stderr: ${stderr.trim().slice(-2_000)}`);
  const shown = notes.filter((note): note is string => Boolean(note));
  if (shown.length) lines.push(...shown.map(note => `- ${note}`));
  findings.forEach((event, index) => {
    lines.push("", `${index + 1}. [${str(event.severity) ?? "none"}] ${location(event)}${str(event.title) ? ` — ${str(event.title)}` : ""}`, findingBody(event));
  });
  return { text: lines.join("\n"), failed };
}

export function runCodeRabbitWith(command: string, limits = { totalMs: CODERABBIT_TIMEOUT_MS, idleMs: CODERABBIT_IDLE_MS }): CommandRunner {
  return ({ cwd, args }, signal) =>
    new Promise((resolve, reject) => {
      const limit = new AbortController();
      let reason = "";
      let lastOutput = Date.now();
      const started = Date.now();
      const watchdog = setInterval(() => {
        const now = Date.now();
        if (now - lastOutput > limits.idleMs) reason = `CodeRabbit sent no output or heartbeat for ${Math.round(limits.idleMs / 60_000)} minutes`;
        else if (now - started > limits.totalMs) reason = `CodeRabbit ran longer than ${Math.round(limits.totalMs / 60_000)} minutes`;
        if (reason) limit.abort();
      }, Math.min(10_000, limits.idleMs / 2));
      const child = spawn(command, args, { cwd, signal: AbortSignal.any([signal, limit.signal]), stdio: ["ignore", "pipe", "pipe"] });
      let stdout = "";
      let stderr = "";
      child.stdout.setEncoding("utf8").on("data", chunk => { stdout += chunk; lastOutput = Date.now(); });
      child.stderr.setEncoding("utf8").on("data", chunk => { stderr = (stderr + chunk).slice(-8_000); lastOutput = Date.now(); });
      child.on("error", error => {
        clearInterval(watchdog);
        if (signal.aborted) reject(error);
        else if (limit.signal.aborted) resolve({ text: `${reason}; it was stopped and partial results follow.\n${formatCodeRabbit(stdout, null, stderr, args).text}`, failed: true });
        else resolve({ text: `CodeRabbit could not start: ${error.message}`, failed: true });
      });
      child.on("close", code => {
        clearInterval(watchdog);
        if (signal.aborted || limit.signal.aborted) return;
        resolve(formatCodeRabbit(stdout, code, stderr, args));
      });
    });
}

export const runCodeRabbit = runCodeRabbitWith(CODERABBIT);
