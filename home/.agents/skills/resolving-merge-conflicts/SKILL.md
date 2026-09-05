---
name: resolving-merge-conflicts
description: "Use when you need to resolve an in-progress git merge/rebase conflict."
---

1. **See the current state** of the merge/rebase. Read `git status`, history, and conflicting files. Record pre-existing
   edits and staged paths so unrelated work is preserved.

2. **Find the primary sources** for each conflict. Understand deeply why each change was made, and what the original
   intent was. Read the commit messages, check the PRs, check original issues/tickets.

3. **Resolve each hunk.** Preserve both intents where possible. Where incompatible, use the merge's stated goal and note
   the trade-off. Ask only when the intended behavior cannot be determined; continue independent resolutions. Do not
   invent new behavior or abort unless the user directs it.

4. Run **focused checks** for the resolutions and complete required repository checks. Fix breakage caused by the merge
   within the task's scope; report unrelated failures.

5. **Finish the authorized operation.** Stage resolved paths explicitly and inspect the full staged diff, including
   pre-existing staged changes. Commit or continue the merge/rebase when completing it is authorized; otherwise leave
   reviewed resolutions ready. Continue an authorized rebase through its remaining commits. Keep unrelated edits out of
   commits and never push unless authorized.
