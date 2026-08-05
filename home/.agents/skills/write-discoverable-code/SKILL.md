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

Coding agents discover Go code by searching for strings, reading small windows around the
hits, and following compiler and test output. These rules make a concept resolvable in one
search instead of five while preserving idiomatic Go.

## 1. Names are search queries

- **Let package and receiver names provide context.** Exported names should read naturally
  at the call site: `webhook.ParseEvent`, not `webhook.ParseWebhookEvent`; `order.Validate()`,
  not `order.ValidateOrder()`. Add domain words when the package or receiver does not already
  supply them: `ParseWebhookEvent` is appropriate in a broader `events` package.
- **Let scope determine name length.** Short names such as `i`, `p`, `ok`, and `err` work in
  tight scopes. Package-level declarations and values used across a long function need names
  that survive outside their immediate context. Prefer `retryDelay` to `d` when a search hit
  does not show the declaration.
- **Give generic package-level verbs their object.** Prefer `SanitizeEmailHTML` to `Sanitize`
  when the package contains several kinds of content. Methods may remain concise when the
  receiver supplies the object.
- **Follow Go spelling so searches converge.** Use `userID`, `HTTPClient`, and `parseURL`, not
  `userId`, `HttpClient`, or `parseUrl`. Use the same initialism spelling in exported and
  unexported names.
- **One definition site per symbol.** Move shared behavior to one concept-named package or
  file and call it from everywhere else. When moving a function, delete the original in the
  same change.
- **One concept, one spelling.** Pick `organizationID` or `orgID` and use it consistently.
  Every synonym splits future searches. Reuse the repository's existing domain vocabulary
  instead of introducing a near-synonym.
- **Rename when behavior, audience, or visibility changes.** A stale name is misinformation.
  If an unexported helper becomes API, give its exported form an API-quality name and doc
  comment in the same change.
- **Give packages focused, searchable names.** Avoid ownership-free packages such as
  `util`, `common`, `helpers`, `types`, and `interfaces`. Put behavior in the package that
  owns the concept, and keep package names short enough to read well as qualifiers.
- **Name files after the concept they contain.** Prefer `retry_policy.go` or `webhook.go` to
  `utils.go`. Do not repeat context already clear from the package directory. Follow the
  repository's existing convention for multiword filenames and preserve Go suffixes such as
  `_test.go`, `_linux.go`, and `_amd64.go`.

## 2. Types make concepts searchable and mistakes visible

- **Define domain types for primitive identifiers.** Distinct types make signatures
  searchable and prevent argument transposition:

  ```go
  type UserID string
  type OrganizationID string

  func TransferOwnership(userID UserID, organizationID OrganizationID) error
  ```

- **Use parameter structs when several arguments share a representation.** A
  `TransferOwnershipRequest` with named fields is easier to search and harder to call
  incorrectly than a run of strings or booleans.
- **Represent capabilities in parameter types.** A privileged operation should require the
  scoped store or service it is allowed to use, rather than a raw `*sql.DB` plus a comment.
  Define small interfaces in the consuming package only when multiple implementations or a
  test seam require one.
- **Give domain states distinct names.** Prefer `PendingOrder` and `PaidOrder`, with explicit
  transitions between them, to a struct whose pointer and boolean fields encode undocumented
  combinations. When distinct state types would add more machinery than safety, use a named
  state type, named constants, and validation at the boundary.
- **Name types for compiler output.** `OrganizationStore` and `WebhookSignatureError` explain
  themselves when a build fails; `Ctx2` and `Data` do not. Keep `any` at genuinely dynamic
  boundaries so the compiler can describe mistakes everywhere else.
- **Use conventional error names.** Sentinel errors start with `Err`, such as `ErrNotFound`;
  exported error types end with `Error`, such as `ParseError`. This makes both source searches
  and `errors.Is` or `errors.As` call sites predictable.

## 3. Say it where the search lands

- **Put a one-line doc comment on every export.** Start with the exported name, as Go tooling
  expects, and state the sharpest constraint the declaration cannot show: units, ownership,
  ordering, timezone, or cancellation behavior.
- **Include the plain-language search phrase.** CamelCase does not match a spaced phrase.
  For example:

  ```go
  // SessionExpired reports whether the user session has expired at checkTime.
  func SessionExpired(session Session, checkTime time.Time) bool
  ```

  This lets searches for both `SessionExpired` and "session has expired" reach the definition.
- **Make call sites understandable without chasing definitions.** Package-qualified names,
  parameter types, return types, and nearby comments should explain the operation. Avoid dot
  imports and aliases that hide the package supplying a symbol.
- **Keep protocol strings whole.** Write complete event names, metric names, flag names, and
  error codes as literals or named constants. Building `"github." + entity + "." + action`
  makes `github.pull_request.merged` absent from the source tree.
- **Start errors with stable, searchable operation text.** Put dynamic values after the
  literal prefix and wrap causes with `%w` when callers need to inspect them:

  ```go
  return fmt.Errorf("verify webhook signature for delivery %s: %w", deliveryID, err)
  ```

- **Keep log messages stable.** Put request IDs and other dynamic values in structured
  attributes rather than interpolating them into the message. A production message should
  grep directly to its source.
- **Give each concept one package home.** Keep orchestration as a readable sequence of calls
  into focused code. Split a file when it answers several unrelated questions, but keep tiny
  helpers beside the concept they serve; a file per function fragments one answer across
  multiple reads.
- **Keep tests beside the code.** Put behavior in the corresponding `_test.go` file in the
  same package directory. Give test functions and subtests domain-specific names so failing
  output is itself a useful search query.
- **Mark dead ends with Go's deprecation form.** Put `Deprecated:` at the start of the
  declaration's doc paragraph and name the replacement, for example
  `// Deprecated: Use VerifySignature instead.`

## Quick checklist before committing

1. Does each new exported name read naturally with its package qualifier or receiver?
2. Can one search for each new concept find its implementation, tests, and documentation?
3. Would swapping same-representation arguments fail to compile or be prevented by named fields?
4. Is the key constraint the signature cannot express written at the declaration?
5. Do protocol, error, and log strings exist as stable searchable text in the source?
6. Did changed behavior, ownership, or visibility receive an accurate name?
7. When code moved, is the old definition gone and any deprecated path clearly marked?
