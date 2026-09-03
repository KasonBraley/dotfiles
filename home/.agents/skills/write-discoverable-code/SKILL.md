---
name: write-discoverable-code
description: |
  Rules for writing Go code that coding agents and humans can find and understand through
  plain-text search. Apply whenever writing or renaming Go packages, files, functions,
  methods, types, constants, errors, log messages, or doc comments.

  Agents often navigate with plain-text search rather than a language server, so every
  identifier is a search query and every search miss costs extra reads.
license: MIT
---

# Write discoverable Go

This skill owns how Go concepts are named and where searchable source text lands. The project's
coding standards own whether a package, file, type, interface, export, or comment is needed and
what behavioral contract it must satisfy.

Coding agents discover Go code by searching for strings, reading small windows around the hits,
and following compiler and test output. Make each concept resolvable in one search while preserving
idiomatic Go.

## Names are search queries

- **Let package and receiver names provide context.** Prefer `webhook.ParseEvent` to
  `webhook.ParseWebhookEvent` and `order.Validate()` to `order.ValidateOrder()`. Add the object to a
  package-level verb when its package contains several kinds of thing, such as `SanitizeEmailHTML`
  in a broad `content` package.
- **Let scope determine length.** Short names such as `i`, `p`, `ok`, and `err` fit tight scopes.
  Values used across a function or package need names that survive outside their immediate context.
- **Name values by role.** Prefer `results` or `payload` to representation-only or vague names such
  as `slice`, `data`, `info`, `thing`, and `tmp`. Add qualifiers such as `raw`, `text`, or `encoded`
  when multiple representations coexist.
- **Follow Go spelling so searches converge.** Use mixed caps and preserve initialisms:
  `userID`, `HTTPClient`, and `parseURL`, not `user_id`, `userId`, or `HttpClient`.
- **Use one spelling per concept.** Pick `organizationID` or `orgID` and use it consistently. Reuse
  established domain vocabulary rather than introducing a near-synonym.
- **Rename stale symbols.** When behavior, audience, or visibility changes, update the name and all
  callers in the same change.
- **Name packages for their owner.** Use short lowercase ASCII names that identify a focused domain
  or capability and read naturally as qualifiers. Avoid import collisions and ownership-free names
  such as `util`, `common`, `helpers`, `types`, and `interfaces`.
- **Name files for their subject.** Prefer concise lowercase names such as `retry_policy.go` or
  `webhook.go` to `utils.go`; omit context already supplied by the package directory and follow the
  repository's multiword style.

## Go API names

- Use `New` for a package's one obvious primary constructor and `NewThing` when it constructs
  several things.
- Omit `Get` from getters; use `Set` for setters.
- Name booleans so their use reads naturally, such as `Enabled`, `Ready`, `HasItems`, or `CanRetry`;
  prefer the domain phrase to mechanically adding `Is`.
- Use one short, stable receiver name for every method on a type; prefer a domain abbreviation to
  `self`, `this`, or `me`.
- Name an interface for the behavior its consumer needs. One-method interfaces conventionally use
  the method name plus `-er`; use a domain noun when clearer, omit `I`, `Interface`, or `Contract`,
  and avoid generic architecture suffixes unless they are established domain vocabulary.
- Use `ParseX` for untrusted or less-structured input, `NewX` for fallible construction from typed
  pieces, `MustX` only when invalidity is a programmer defect, and `IsX` for predicates.
- Prefix sentinel errors with `Err` and suffix error types with `Error`.
- Preserve externally required spelling in generated or protocol-facing code, contain the exception
  at that edge, and record why it is required.

## Say it where the search lands

- **Keep one definition site.** Move shared behavior to one concept-named package or file and delete
  the old definition in the same change.
- **Include the plain-language phrase in required documentation.** CamelCase does not match a spaced
  phrase, so `SessionExpired` documentation should also say “session has expired.”
- **Make call sites understandable without chasing definitions.** Package-qualified names,
  parameter types, return types, and nearby contract comments should identify the operation. Avoid
  dot imports and aliases that hide the package supplying a symbol.
- **Keep protocol strings whole.** Write complete event names, metric names, flag names, and error
  codes as literals or named constants rather than assembling away the string operators search for.
- **Start errors with stable operation text.** Put dynamic values after the literal prefix and wrap
  causes with `%w` when callers need to inspect them.
- **Keep log messages stable.** Put request IDs and other dynamic values in structured attributes so
  a production message searches directly to its source.
- **Name tests for domain behavior.** Test functions and subtests should make failing output a useful
  search query.

## Completion check

Every changed name reads clearly at its declaration and call sites; each concept has one spelling
and definition site; package and file names identify their subjects; externally required exceptions
stay at their edge; documentation includes useful plain-language search phrases; and protocol,
error, log, and test output searches back to its source.
