# Imports, exported API, packages, and files

This reference owns dependency direction, export decisions, and source grouping. Naming and
searchability belong to the `write-discoverable-code` skill.

## Imports and exported API

Import the package that owns an abstraction. Use facade packages and re-exports only as intentional
public compatibility or package entrypoints; prefer direct ownership over forwarding aliases.

Use standard Go import grouping and let `gofmt` or `goimports` enforce formatting where available.
Avoid dot imports except in a framework-mandated test convention. Use aliases only to resolve
collisions or preserve a clearer established qualifier.

Use ordinary static imports. Resolve import cycles by correcting ownership and dependency direction,
not by service locators, globals, or runtime loading. Avoid shadowing an imported qualifier or a
predeclared identifier at its use site.

Export only caller-facing API. Keep implementation types and helpers unexported. Expose fields
directly when that is the intended contract; add accessors only when unexported state needs
controlled behavior. A `main` package normally needs no exports unless tooling such as reflection
requires them.

## Packages, files, and helpers

Start with one package until a boundary clarifies ownership, creates a reusable unit, or isolates an
independently testable concern. Keep domain and application policy with their owning packages.

A helper may move to a shared package when its meaning is generic and stable; a second consumer is
evidence, not a prerequisite. Prefer standard-library helpers over local collections or string
utility packages.

A file owns one cohesive concept or capability and may contain related operations and private
helpers. Keep tightly coupled artifacts together, split unrelated concepts, and keep tiny helpers
beside the concept they serve. Put a type's primary constructor immediately after its declaration
when practical, keep its methods together, then place remaining standalone functions after the
method block. Use cohesion rather than file-size limits.

Reserve `internal`, `vendor`, and `testdata` directories for their Go-defined meanings. Preserve Go
suffix behavior such as `_test.go`, `_linux.go`, and `_amd64.go`. Build tags and platform files
represent real compile-time variation and keep a common API where practical. Use `internal` to
enforce a deliberate import boundary rather than as a dumping ground.

## Completion check

Imports point directly to owners; aliases and facades serve intentional needs; dependency direction
is acyclic; exports expose only caller-facing behavior; package and internal boundaries are
deliberate; domain and application policy remain with their owners; and each changed file owns one
cohesive concept or capability.
