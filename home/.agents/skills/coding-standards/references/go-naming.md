# Go naming

Use the repository's established domain vocabulary when it is sound.
Also apply the ownership, package, file, export, and initialism rules in [`imports-exports-and-files.md`](imports-exports-and-files.md).

## Naming process

Apply these checks to every name added or changed:

1. Identify what the name represents, its scope, and whether it is exported.
2. Apply Go spelling, casing, and initialism conventions.
3. Read the declaration and its call sites; remove type noise, package chatter, and ambiguity.
4. Check every applicable package, file, method, receiver, interface, and exported-API rule below.

## Identifier form

Go identifiers begin with a letter or `_`, continue with letters, Unicode digits, or `_`, are case-sensitive, and cannot be keywords. These are compiler constraints, not style advice. Go permits Unicode letters, but identifiers normally use ASCII.

Use mixed caps for variables and constants, not underscores or screaming snake case:

```go
var userID string
const maxRetries = 3
const DefaultPageSize = 50
```

Scope determines useful name length. Short names such as `i`, `p`, `ok`, and `err` fit tight scopes where their meaning is immediate; values used across a function or package need descriptive names. Common forms such as `ctx`, `req`, `resp`, `cfg`, and `buf` are useful when their type and surroundings make them unambiguous. Prefer the full word when an abbreviation is not established or its scope is broad.

Name values by role rather than representation:

```go
count   int
results []Result
payload []byte
```

Use a type suffix only when two representations coexist and the distinction matters, such as `userID` and `userIDText`. Prefer precise semantic qualifiers such as `raw`, `text`, or `encoded` where they explain more than the Go type. Avoid vague names such as `data`, `info`, `thing`, and `tmp` outside a tiny self-explanatory scope.

Do not shadow predeclared identifiers such as `int`, `any`, `len`, `clear`, `min`, or `max`, or an imported package name at its call site.

## Exported, package, and file names

Capitalization determines visibility. Export only caller-facing API. A `main` package normally needs no exports unless tooling such as reflection requires them.

Exported names read naturally after their package qualifier. Remove stutter: prefer `customer.Address` to `customer.CustomerAddress`.

Package names are short lowercase ASCII without separators. Concatenate words only when necessary. Avoid names that collide with commonly imported packages when a clear alternative exists. Reserve `internal`, `vendor`, and `testdata` directories for their Go-defined meanings.

Use concise lowercase `.go` filenames and the repository's established multiword style. A leading `.` or `_` hides a file from Go tooling; `_test.go` marks tests; OS and architecture suffixes select build targets. Use each special form only for its intended behavior.

## Constructors, accessors, methods, and booleans

Read APIs at the call site and remove words already supplied by the package or receiver:

```go
customer.New()
customer.Orders()

func (t *Token) Validate() error
```

Use `New` for the package's one obvious primary construction operation. Use `NewThing` when the package constructs several things or `New` would be ambiguous. A type and package may share a name when the domain remains clear, as in `time.Time` and `regexp.Regexp`.

Methods normally omit `Get` from getters; use `Set` for setters. Prefer direct field access when that is the intended API, and add accessors only when unexported state needs controlled behavior.

Name booleans so use reads naturally, such as `Enabled`, `Ready`, `HasItems`, or `CanRetry`. Choose the domain phrase rather than mechanically adding `Is`.

## Method receivers

Use a short receiver name, usually one to three letters or a clear abbreviation of the type. Use the same receiver name for every method on that type. Prefer a domain abbreviation to `self`, `this`, or `me`.

## Interfaces

Name an interface for the behavior its consumer needs. A one-method interface conventionally uses the method name plus `-er`, such as `Speaker` or `Authorizer`; use a domain noun when clearer. Omit suffixes such as `Interface` and `Contract`.

## Deliberate exceptions

Clarity at an external contract can require its spelling in generated code, protocol boundaries, or synchronization code. Contain the exception at that boundary, keep the rest of the Go API idiomatic, and record why the exception improves clarity.

## Completion check

Every changed name has been checked at its declaration and call sites; form, scope, visibility, package qualification, file behavior, receiver consistency, and interface vocabulary are deliberate; and each exception has a stated boundary reason.
