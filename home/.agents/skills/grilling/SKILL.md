---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user about unresolved decisions needed for the stated goal. Map this as a **design tree**: each material decision branches into the decisions that depend on it. Reuse answers already given and leave unrelated branches out of scope.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Find available facts yourself. Delegate independent lookups when collaboration tools can help; otherwise inspect directly. Only questions depending on a pending lookup wait for it; ask the rest of the frontier now. Put material unresolved decisions to the user, with recommendations, and wait for their answers. If the user asks you to decide, make and state reasonable assumptions instead of continuing the interview.

The session is done when the in-scope frontier is empty or the user ends it. Summarize decisions and any remaining assumptions. A request to interview does not itself authorize implementation; proceed when implementation is also requested and no material decision remains. Avoid a separate “shared understanding” confirmation after the user has already settled the decisions.
