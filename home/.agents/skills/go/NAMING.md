# Go Naming Conventions

Go names are part of the API. Prefer names that make the code clear at the call site and predictable across the package. Use the repository's existing domain vocabulary when it is sound.

## Naming process

Apply these steps to every name you add or change:

1. **Establish scope.** Identify what the name represents, where it is used, and whether it is part of the package's exported API. Done when the name's role, scope, and visibility are clear.
2. **Choose the form.** Apply Go's spelling, casing, and initialism conventions. Done when the name looks like a natural Go name rather than a translation from another language.
3. **Test the call site.** Read the name where it is declared and where it is used. Remove type noise, package chatter, and ambiguity. Done when a reader can infer the value's role without inspecting unrelated code.
4. **Check the boundary.** For packages, files, methods, interfaces, and exported identifiers, check the applicable rules below. Done when every applicable rule has been considered.

A naming review is complete only when every changed name has passed these checks and each deliberate exception has a stated reason.

## Identifier form

### Language constraints

Go identifiers:

- begin with a letter or `_`, then contain letters, Unicode digits, or `_`;
- are case-sensitive; and
- cannot be Go keywords such as `func`, `map`, `range`, or `type`.

These are compiler constraints, not style advice. Go also permits Unicode letters, but ASCII is the normal choice for identifiers: use `resumeCount`, not `résuméCount` or `π`.

### Casing

Use mixedCaps. The initial letter controls visibility:

```go
var userID string       // unexported
var DefaultTimeout time.Duration // exported
```

Use `userID`, `parseURL`, `HTTPClient`, and `apiKey`—not `userId`, `parseUrl`, `HttpClient`, or `API_key`. Apply the same initialism spelling in exported and unexported names; only the first letter changes for visibility.

Use mixedCaps for constants too. Go does not use `SCREAMING_SNAKE_CASE` for constants:

```go
const maxRetries = 3
const DefaultPageSize = 50
```

### Scope and length

**Scope** determines name length. A short name is clear in a tight scope; a value used across a package needs a descriptive name.

```go
for i, p := range people {
    sum += p.Age
    count++
}

average := sum / count
```

Here `i` and `p` are local to a small loop, while `sum`, `count`, and `average` describe values used across the function. Names such as `i`, `p`, `ok`, and `err` are idiomatic only when their meaning is immediate. Name longer-lived values for what they represent rather than using `data`, `info`, `thing`, or `tmp`.

Common short forms such as `ctx`, `req`, `resp`, `cfg`, and `buf` are useful when their types and surrounding code make them unambiguous. Prefer the full word when the abbreviation is not established or the scope is broad.

### Meaning over representation

Name a value after its role, not its type:

```go
count   int
results []Result
payload []byte
```

Use a type suffix only when two representations must coexist and the distinction matters, such as `userID` and `userIDText`. Prefer a semantic distinction such as `raw`, `text`, or `encoded` when that is more precise than the Go type.

Keep names distinct from predeclared identifiers and built-ins such as `int`, `any`, `len`, `clear`, `min`, and `max`. They can technically be shadowed, but doing so makes code harder to read. Also choose local names that do not shadow imported package names at a call site.

## Exported names

Capitalization is a visibility decision, not decoration. Export only what callers need from the package; unexported names are easier to change. A `main` package normally needs no exported identifiers unless a tool such as reflection requires one.

Exported names should read naturally after the package qualifier. A caller should write `customer.Address`, not need to decode a redundant name such as `customer.CustomerAddress`.

## Package names

Use a short, lower-case ASCII package name with no separators. Concatenate multiple words: `ordermanager`, not `orderManager` or `order_manager`.

Name a package after its focused domain or capability. A package should make its contents predictable:

```go
package orders
package slug
package validation
```

A package named `common`, `util`, `utils`, `helpers`, `types`, or `interfaces` hides ownership and invites unrelated code to accumulate. Choose a narrower package name instead.

Keep package names distinct from commonly imported packages when a clear alternative exists, so callers do not need aliases throughout the codebase. Reserve directories with Go-defined meanings—`internal`, `vendor`, and `testdata`—for those meanings; do not use them as ordinary package directories.

## File names

Use lower-case, concise `.go` file names. Prefer one word; for multiple words, concatenate them or use underscores consistently within the repository. Reserve underscores for intentional Go suffixes when possible:

- a leading `.` or `_` makes a file invisible to Go tooling;
- `_test.go` marks test files; and
- OS and architecture suffixes select files for that target.

Use these special names only when the corresponding behavior is intended. Keep a test's production code in a normal `.go` file and its tests in `_test.go`.

## API and method names

Read exported names at the call site and remove **chatter**—words already supplied by the package or receiver:

```go
customer.New()       // not customer.NewCustomer()
customer.Orders()    // not customer.CustomerOrders()

func (t *Token) Validate() error { ... } // not ValidateToken()
```

Use `New` when a package has one obvious primary construction operation. Use `NewThing` when a package constructs several distinct things or the shorter name would be ambiguous. A type and package with the same name are acceptable when the domain meaning is clear, as in `time.Time` and `regexp.Regexp`.

Methods normally omit `Get` from getters. Use `Set` for setters:

```go
type Customer struct {
    address string
}

func (c *Customer) Address() string {
    return c.address
}

func (c *Customer) SetAddress(addr string) {
    c.address = addr
}
```

Prefer direct field access when that is the intended API; add accessors when an unexported field needs a controlled boundary or behavior.

Name boolean values so their use reads naturally: `Enabled`, `Ready`, `HasItems`, or `CanRetry`. Choose the form that describes the domain rather than mechanically adding `Is`.

Use conventional error names: sentinel errors begin with `Err` (`ErrNotFound`), and exported error types normally end in `Error` (`ParseError`).

## Method receivers

Use a short receiver name, usually one to three letters or a clear abbreviation of the type. Use the same receiver name on every method of that type:

```go
type Order struct {
    Items int
}

func (o *Order) Validate() bool {
    return o.Items > 0
}
```

Receiver names are local, so `o` is clearer here than `order`. Give each type its own consistent abbreviation. Use domain abbreviations rather than generic `self`, `this`, or `me`.

## Interfaces

Name an interface for the behavior its consumer needs, not for the concrete type that implements it. A one-method interface conventionally uses the method name plus `-er`:

```go
type Speaker interface {
    Speak() string
}

type Authorizer interface {
    Authorize(context.Context, string) error
}
```

Use a domain noun when it is clearer. Keep the interface name concise and omit suffixes such as `Interface` or `Contract`.

## Deliberate exceptions

Conventions serve clarity; they are not a reason to obscure an external contract. Matching an external system's spelling can be appropriate for generated code, protocol boundaries, or synchronization code. Keep the exception at that boundary, preserve idiomatic names in the rest of the Go API, and record why the exception improves clarity.
