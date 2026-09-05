# Go configuration

This reference owns runtime configuration loading, source precedence, parsing, defaults, and cross-field validation.
Load raw sources once at the composition root, produce a typed `Config` before acquiring resources, and pass typed
sub-configurations to constructors.

## Parsing rules

- Use `os.LookupEnv` when missing and explicitly empty have different meanings.
- Parse booleans, integers, durations, URLs, and paths with standard-library parsers or domain constructors.
- Wrap credentials in the project's secret/redaction type immediately.
- Represent semantic absence explicitly.
- Apply defaults only to missing values; malformed supplied values fail.
- Validate cross-field constraints after field parsing and before constructing resources.
- Aggregate independent errors only when presenting them together improves startup diagnosis without exposing secrets.

## Sources and precedence

Use the repository's established config library when present; otherwise prefer a small explicit loader over a
reflection-heavy framework. Define and test source precedence once, for example flags over environment over file over
defaults. A fallback applies only to absence unless every parse failure truthfully selects it.

Leaf packages receive typed values rather than reading ambient configuration. Tests may inject a lookup function or
explicit source map into the loader; tests outside parsing construct configuration through the same validation path.

Expose only constructor forms required by actual callers. Use one source abstraction and parser rather than parallel
`FromEnv`, `FromFlags`, and `FromMap` APIs.

## Completion check

Every runtime value is parsed once into typed configuration; credentials are redacted; defaults distinguish missing from
malformed values; cross-field constraints are validated before resource acquisition; source replacement, fallback, and
precedence are explicit and tested; leaf packages do not read ambient configuration; and each configuration constructor
has a real caller.
