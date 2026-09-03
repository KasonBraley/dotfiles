# Packages, services, and adapters

## Roles

**Domain package**, **Application Service**, **Adapter**, and **composition root** name responsibilities, not required folders or suffixes.

Classify code by what would make it change:

- Business meaning, invariant, calculation, or legal state transition: **Domain package**.
- Application policy, authorization, or side-effect sequence: **Application Service**.
- Protocol, framework, database, runtime, or third-party API: **Adapter**.
- Construction or wiring: **composition root**.

The normal flow is:

```txt
external input -> inbound Adapter -> Application Service -> Domain package
                                           |
                                           +-> consumer-owned capability
                                           |     -> outbound Adapter -> external system
                                           |
                                           +-> private concrete client -> external system
```

Domain packages form the functional core. Application Services and Adapters form the imperative shell. An inbound Adapter may call a domain operation directly when it is pure and requires only parsed input.

For each changed operation:

1. Trace it from ingress to every side effect and observable result.
2. Put intrinsic meanings, calculations, and transitions in domain packages.
3. Put application policy and side-effect ordering in an Application Service.
4. Choose a private concrete client or outbound Adapter by applying the deletion test below.
5. Wire concrete implementations at the composition root.

## Domain packages

A domain package is pure, type-driven, and centered on one domain concept or tightly related family. Use one for a real distinction, invariant, calculation, decision, or lifecycle.

It may own types, parsers, constructors, predicates, transitions, calculations, formatting, domain representations, and test generators. It returns refined values, expresses expected failures as errors, and remains independent of I/O, frameworks, persistence, ambient time, randomness, and mutable global state.

Inputs and outputs are domain values rather than protocol or persistence records. Pure permission decisions over parsed values may live here. Use plain functions and immutable or encapsulated structs. Keep fields private when exporting them would bypass invariants; make the zero value useful only when truthful.

## Application Services

An Application Service owns one cohesive operation or capability. Use one when behavior coordinates authorization, domain decisions, persistence, external calls, transactions, messages, time, IDs, telemetry, or multiple entrypoints.

Design a meaningful service from the consuming API first.
Define the smallest interface in the consumer only when multiple implementations or a test seam require it; otherwise depend on a concrete type.
Read [`services.md`](services.md) when a service, interface, constructor, or dependency changes.

An Application Service:

- accepts and returns application/domain types with documented expected errors;
- depends on the smallest cohesive capabilities owning needed behavior;
- receives services, configuration, clocks, randomness, and similar capabilities explicitly;
- accepts `context.Context` first for request-scoped work;
- owns which side effects occur, under what policy, and in what order;
- keeps public contracts independent of framework, ORM, vendor SDK, and runtime types.

Operation-specific authorization evidence and scoped handles remain explicit inputs. A function dependency is appropriate when one higher-order behavior is the complete capability.

A service may expose multiple related methods when they share one owner and reason to change. Build broader services by composing smaller capabilities only after those seams earn their place. Keep sequence and decision points visible without accumulating protocol mechanics or pass-through packages.

## Adapters and concrete clients

An inbound Adapter parses an external request, event, or command; invokes an Application Service or eligible pure domain operation; and renders the external protocol.

An outbound Adapter implements a consumer-owned capability using concrete technology. It owns protocol translation, framework lifecycle, external failure classification, safe diagnostics, and short-lived technical retries that preserve capability meaning.

One concrete external client may remain private inside the service owning its use while a separate Adapter would only forward. Its owner translates client failures before they cross the public API. Extract an Adapter when it hides meaningful translation or mechanics, is reused, or supports real implementation variation.

Before creating an Adapter or service:

1. Check existing services, clients, and Adapters.
2. Use an existing concrete client directly when a new Adapter would only forward and remains private.
3. Reuse an existing cohesive Adapter through its capability contract.
4. Extend an Adapter when the method fits its owner and reason to change.
5. Create one when it hides meaningful mechanics, serves multiple owners, or supports real variation.

Create an ADR for a lasting architectural boundary, shared pattern, provider strategy, or deliberate exception. For each new service or Adapter, record which existing owners were checked and why reuse or extension did not fit.

## Authentication and authorization

- inbound Adapters verify boundary credentials and produce a parsed `Principal`, `Session`, or `CommandActor`;
- domain packages define pure permission decisions over parsed values;
- Application Services gather context and enforce those decisions while carrying out operations;
- Adapters translate missing credentials and denied operations into protocol outcomes.

## Completion check

Every changed operation is traced: each concern has one owner; domain packages remain pure; authorization follows the allocation above; each service uses a concrete dependency or consumer-owned interface justified by current need; orchestration keeps policy visible while delegating owned calculations and mechanics; framework, persistence, runtime, and vendor details stop at their Adapter or private implementation; each abstraction passes the deletion test and existing-owner check; and each entrypoint parses protocol input, invokes the owning operation, and renders the protocol result.
