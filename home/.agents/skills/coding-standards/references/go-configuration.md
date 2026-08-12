# Go configuration

This reference covers environment variables, flags, files, and typed startup configuration. For ownership, startup failures, and resource lifecycle, also apply [`configuration-and-resources.md`](configuration-and-resources.md).

Read raw configuration at the composition root, parse it once into a typed `Config`, validate relationships between fields, and pass typed sub-configurations to constructors.

```go
type Config struct {
    DataDirectory AbsolutePath
    APIKey        Secret
    Model         Optional[string]
    FeatureEnabled bool
}

func LoadConfig(lookup func(string) (string, bool)) (Config, error) {
    // Read, parse, default, then validate as one startup operation.
}
```

## Parsing rules

- Use `os.LookupEnv` when missing and explicitly empty have different meanings.
- Parse booleans, integers, durations, URLs, and paths with standard-library parsers or domain constructors.
- Wrap credentials in the project's secret/redaction type immediately.
- Represent semantic absence explicitly.
- Apply defaults only to missing values; malformed supplied values fail.
- Validate cross-field constraints after field parsing and before constructing resources.
- Aggregate independent configuration errors only when showing them together improves startup diagnosis without exposing secrets.

## Sources and precedence

Use the repository's established config library when present; otherwise prefer a small explicit loader over a reflection-heavy framework. Define source precedence once at the composition root, for example flags over environment over file over defaults. Keep names and precedence searchable and tested. A fallback applies only to absence unless every parse failure truthfully selects it.

Avoid reading environment variables in leaf packages. Constructors receive typed values. Tests may inject a lookup function or explicit source map into the loader; application tests that do not exercise parsing construct `Config` directly through the same validation path.

Expose only constructor forms required by actual callers. Do not create parallel `FromEnv`, `FromFlags`, and `FromMap` APIs when one source abstraction plus one parser suffices.

## Completion check

Every runtime value is parsed into a typed configuration; credentials are redacted; defaults distinguish missing from malformed values; cross-field constraints are validated before resource acquisition; source replacement, fallback, and precedence are explicit and tested; leaf packages do not read ambient configuration; and each configuration constructor has a real caller.
