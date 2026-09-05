---
name: codebase-design
description: Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary.
---

# Codebase Design

Design **deep modules**: a lot of behaviour behind a small interface, placed at a clean seam, testable through that interface. Use this language and these principles wherever code is being designed or restructured. The aim is leverage for callers, locality for maintainers, and testability for everyone.

## Glossary

Use consistent concepts while preserving the project's domain and technology vocabulary. A service can be a module, an HTTP API can expose a module contract, and a trust boundary need not be a substitution seam. Name the specific responsibility rather than banning useful words.

**Module** — anything with a caller-facing contract and an implementation. Deliberately scale-agnostic: a function, class, package, application service, or tier-spanning slice.

**Module contract** (or **interface** in this document) — everything a caller must know: types, invariants, ordering constraints, error modes, configuration, ownership, and performance characteristics. A **Go interface type** is only a language mechanism for expressing a method set; a module can have a contract without declaring one.

**Implementation** — the code satisfying a module contract. Several concrete implementations may satisfy the same contract; that variation can justify a substitution seam.

**Depth** — leverage at the interface: the amount of behaviour a caller (or test) can exercise per unit of interface they have to learn. A module is **deep** when a large amount of behaviour sits behind a small interface, **shallow** when the interface is nearly as complex as the implementation.

**Seam** — a place where callers or tests enter a module contract or substitute a dependency. State whether the topic is an observation surface or a substitution point; neither requires exposing private internals.

**Technology adapter** (or **adapter**) — an implementation that translates a protocol, representation, or technology into the contract its consumer needs. An inbound adapter translates external input into an application call; an outbound adapter translates an application capability into external I/O. Translation can earn its place with one provider.

**Application service** — a module owning application policy and side-effect sequencing. Domain calculations can remain pure modules inside it. For Go-specific allocation and interface decisions, read [`modules-services-and-adapters.md`](../coding-standards/references/modules-services-and-adapters.md).

**Leverage** — what callers get from depth: more capability per unit of interface they learn. One implementation pays back across N call sites and M tests.

**Locality** — what maintainers get from depth: change, bugs, knowledge, and verification concentrate in one place rather than spreading across callers. Fix once, fixed everywhere.

## Deep vs shallow

**Deep module** = small interface + lots of implementation:

```
┌─────────────────────┐
│   Small Interface   │  ← Few methods, simple params
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Complex logic hidden
│                     │
└─────────────────────┘
```

**Shallow module** = large interface + little implementation (avoid):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← Just passes through
└─────────────────────────────────┘
```

When designing an interface, ask:

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?

## Principles

- **Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small, mockable, swappable parts — they just aren't part of the interface. A module can have **internal seams** (private to its implementation, used by its own tests) as well as the **external seam** at its interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam. If you want to test *past* the interface, the module is probably the wrong shape.
- **Earned seams.** A boundary earns its place by hiding meaningful translation, policy, ownership, or variation. Two implementations are evidence for substitution, not a prerequisite for a boundary. A Go interface type needs a current consumer requirement; a concrete dependency can already hide complexity. Apply the deletion test instead of counting adapters.

## Designing for testability

Good interfaces make testing natural:

1. **Accept stable runtime dependencies at the composition boundary.** Keep acquisition out of per-call policy; an owning constructor can still create a private concrete client.

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Return results, don't produce side effects.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Small surface area.** Minimize caller knowledge and setup, not behavior coverage. Fewer methods do not mean fewer invariants or failure paths to test.

Select test levels using project policy, falling back to [`testing.md`](../coding-standards/references/testing.md). This glossary does not require testing everything through the outermost interface.

## Relationships

- A **Module** has exactly one **Interface** (the surface it presents to callers and tests).
- **Depth** is a property of a **Module**, measured against its **Interface**.
- A **Seam** is where a **Module**'s **Interface** lives.
- An **Adapter** sits at a **Seam** and satisfies the **Interface**.
- **Depth** produces **Leverage** for callers and **Locality** for maintainers.

## Rejected framings

- **Depth as ratio of implementation-lines to interface-lines** (Ousterhout): rewards padding the implementation. We use depth-as-leverage instead.
- **"Interface" as the TypeScript `interface` keyword or a class's public methods**: too narrow — interface here includes every fact a caller must know.
- **Conflating boundaries**: identify whether a boundary concerns trust, domain ownership, technology translation, observation, or substitution.

## Going deeper

- **Deepening a cluster given its dependencies** — see [DEEPENING.md](DEEPENING.md): dependency categories, seam discipline, and replace-don't-layer testing.
- **Exploring alternative interfaces** — see [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): spin up parallel sub-agents to design the interface several radically different ways, then compare on depth, locality, and seam placement.
