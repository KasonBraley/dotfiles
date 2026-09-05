# Review smell baseline

These are Fowler-inspired heuristics, not automatic rewrites. Project rules and concrete contract/ownership evidence
take priority. Label a finding as a possible smell and explain the actual maintenance or correctness cost before
recommending a change.

- **Mysterious Name:** the name hides meaning at its declaration or call sites. Use established domain vocabulary.
- **Duplicated Code:** repeated logic shares one meaning and reason to change. Extract only when the shared owner is
  real; similar syntax alone is insufficient.
- **Feature Envy:** behavior depends on another owner's data and rules. Consider moving it to that owner.
- **Data Clumps:** values repeatedly travel together as one concept. Consider a meaningful input or value type.
- **Primitive Obsession:** a primitive permits meaningful mix-ups or invalid states. Consider a parsed domain type.
- **Repeated Switches:** repeated dispatch duplicates policy. Consider one owning decision function; use polymorphism
  only when actual variation warrants it.
- **Shotgun Surgery:** one conceptual change requires scattered knowledge. Look for an owner that can concentrate it.
- **Divergent Change:** one module changes for unrelated reasons. Consider separating responsibilities.
- **Speculative Generality:** unused abstractions, parameters, or hooks anticipate unsupported needs. Prefer the direct
  implementation.
- **Message Chains:** callers navigate details they should not know. Consider a cohesive operation at the owner.
- **Middle Man:** forwarding adds no translation, policy, compatibility, or ownership. Apply the deletion test.
- **Refused Bequest:** an implementation rejects most of its inherited contract. Consider composition or a smaller
  consumer contract.
- **Tautological Tests:** expected results are derived from the implementation itself. Seek an independent oracle or a
  meaningful invariant.

A smell recommendation must preserve behavior coverage. For test removal during deepening, use the coverage mapping in
[`DEEPENING.md`](../../codebase-design/DEEPENING.md#testing-strategy-preserve-behavior-coverage).
