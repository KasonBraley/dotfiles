# Go diagnostic evidence

Use these Go-specific tools within the `diagnosing-bugs` phases. That skill owns the diagnosis workflow; this reference only identifies Go evidence and commands.

## Prove what runs

Treat the toolchain as evidence, not the first suspect. A persistent failure often means the fix missed the executed path, another call site remains, build constraints selected different files, generated code is stale, or the diagnosis is incomplete.

Start with the repository's actual build or test command. Identify the module, workspace, package, binary, environment, build tags, and source files involved. Useful commands include:

- `go env GOMOD GOWORK GOFLAGS GOOS GOARCH CGO_ENABLED` for active module, workspace, flags, and target;
- `go list -f '{{.ImportPath}} {{.GoFiles}} {{.IgnoredGoFiles}} {{.TestGoFiles}} {{.XTestGoFiles}}'` for selected and ignored source;
- `go list -deps` when module or dependency selection may explain the behavior;
- `go version -m <binary>` when the executed binary may not contain the expected build.

Account for generated files, vendoring, workspace replacements, build tags, and platform-specific files when they can alter the executed path.

**Complete when:** the code, dependencies, build settings, and artifact exercised by the feedback loop are known.

## Tighten Go feedback

Use a focused `go test -run` command when a test reaches the symptom. Add `-count=1` when cached success could hide changed conditions. For intermittent failures, vary one relevant dimension at a time: repetition with `-count`, race instrumentation with `-race`, scheduling with `GOMAXPROCS`, test selection, build tags, or environment.

## Measure Go performance

Compare benchmarks under equivalent conditions. Capture the profile closest to the observed bottleneck: CPU, heap or allocations, block, mutex, execution trace, or the relevant runtime metrics. Inspect profiles with pprof before optimizing.

## Clear caches last

Clear build, test, module, or application caches only after evidence identifies corrupted or stale cache state. Cache cleaning does not establish which files, tags, generated artifacts, dependencies, or binary are active.
