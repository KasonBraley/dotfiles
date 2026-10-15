import type { ModelRef } from "@earendil-works/pi-durable";
import type { SpawnRequest } from "./workers.ts";

export interface Reviewer {
  name: string;
  model: ModelRef;
}

export const REVIEWERS: readonly Reviewer[] = [
  { name: "review-sol", model: { provider: "openai-codex", modelId: "gpt-6.1-sol" } },
  { name: "review-astra", model: { provider: "openai-codex", modelId: "gpt-6-astra" } },
  { name: "review-opus", model: { provider: "anthropic", modelId: "claude-opus-5-5" } },
];

export const REVIEW_THINKING_LEVEL = "medium";
export const REVIEW_TOOLS = ["read", "bash"];

const DEFAULT_SCOPE = [
  "The current branch's committed changes since its merge base with the default branch, plus staged and unstaged working-tree changes.",
  "Find the default branch with `git symbolic-ref --short refs/remotes/origin/HEAD`, falling back to `main` or `master`.",
  "If the branch is the default branch, review only the staged and unstaged changes.",
].join(" ");

export function reviewTask(scope: string, cwd: string): string {
  return [
    `Review code changes in ${cwd} as one of three independent reviewers. The other reviewers use different models and review the same scope; the user will compare all three reports.`,
    "",
    `Scope: ${scope.trim() || DEFAULT_SCOPE}`,
    "",
    "Rules:",
    "- This is a read-only review. Do not modify files, the git index, refs, or stashes. Use bash only for read-only commands such as git diff, git log, git show, rg and test or lint commands that write nothing to the checkout.",
    "- If the code-review skill is listed in your available skills, read its SKILL.md and follow its workflow.",
    "- Read the surrounding code, not only the diff. Verify every finding against the code before reporting it.",
    "- Ignore style preferences that the repository's own instructions do not require.",
    "",
    "Answer with:",
    "1. Findings ordered by severity (blocker, major, minor, nit). For each: file:line, the problem, the evidence, and a concrete fix.",
    "2. What you checked, including commands you ran.",
    "3. Anything you could not verify.",
    "If you find no problems, say so plainly.",
  ].join("\n");
}

export function reviewRequests(scope: string, cwd: string, tools: readonly string[]): SpawnRequest[] {
  const task = reviewTask(scope, cwd);
  return REVIEWERS.map(reviewer => ({
    name: reviewer.name,
    task,
    model: reviewer.model,
    thinkingLevel: REVIEW_THINKING_LEVEL,
    cwd,
    tools: [...tools],
    instructions: `You are background review worker "${reviewer.name}" running ${reviewer.model.provider}/${reviewer.model.modelId}. You review; you never edit.`,
  }));
}
