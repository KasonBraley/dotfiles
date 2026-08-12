# Imports, exported API, packages, and files

## Imports and exported API

Import the package that owns an abstraction. Use facade packages and re-exports only as intentional public compatibility or package entrypoints; prefer direct ownership over forwarding aliases.

Use standard Go import grouping and let `gofmt`/`goimports` enforce formatting where available. Avoid dot imports except in a framework-mandated test convention. Use aliases only to resolve collisions or preserve a clearer established package qualifier. Keep aliases stable and domain-meaningful.

Use ordinary static imports. Resolve import cycles by correcting ownership and dependency direction, not by service locators, globals, or runtime loading.

Export only what callers should use. Keep implementation types and helpers unexported and test behavior through public interfaces. When changed behavior makes an exported name inaccurate or changes its audience, rename it in the same change and update every caller. Follow Go initialism spelling: `ID`, `HTTP`, `URL`, `API`.

## Packages, files, and helpers

Give each package a focused, searchable owner. Avoid ownership-free packages such as `util`, `common`, `helpers`, `types`, and `interfaces`. Define interfaces in consuming packages. Package names are short, lowercase, and read naturally as qualifiers without stutter: `user.ParseID`, not `user.ParseUserID`.

Give each file a searchable subject identifying what it owns:

```txt
email_address.go
billing_period.go
retry_policy.go
user_store_postgres.go
```

Preserve Go suffix conventions such as `_test.go`, `_linux.go`, and `_amd64.go`. Follow the repository's established multiword filename style.

A shared generic helper package has an explicit stable subject. A helper may move there when its meaning is generic and stable; a second consumer is evidence, not a prerequisite. Keep domain and application policy with owning packages. Prefer standard-library helpers over local collections or string utility packages.

A file owns one cohesive concept or capability and may contain related operations and private helpers. Split unrelated concepts; keep tiny helpers beside the concept they serve. Use cohesion and discoverability rather than file-size limits.

Avoid `internal` as a dumping ground; use it to enforce a deliberate import boundary. Avoid package-level mutable variables. Build tags and platform files describe real compile-time variation and keep a common API where practical.

## Completion check

Imports point directly to owners and package qualifiers make operations self-describing; aliases and facades serve intentional needs; import cycles are resolved through ownership; exports expose only caller-facing behavior and stale names change with behavior or audience; interfaces live with consumers; packages and files have focused searchable subjects; Go naming and suffix conventions hold; internal boundaries are deliberate; domain and application policy remain with their owners; and each changed file owns one cohesive concept or capability.
