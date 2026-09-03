# Go debugging

Treat the toolchain as evidence, not the first suspect.
A persistent failure usually means the fix missed the executed code path, another call site remains, build tags selected different files, generated code is stale, or the diagnosis is incomplete.

Use this loop:

1. Reproduce with the narrowest deterministic command and preserve the exact output.
    Complete when the failure repeats or its intermittence is characterized.
2. Identify the package, test, binary, build tags, environment, and source files involved.
    Useful commands include `go env`, `go list -f '{{.GoFiles}}'`, `go list -deps`, and the repository's actual build command.
    Complete when the code being compiled and run is known.
3. Trace the failing path with a focused test, debugger, temporary logging, `t.Log`, race detector, trace, or profiles as appropriate.
    Complete when an observation distinguishes the leading hypotheses.
4. Fix the cause, remove temporary instrumentation, and rerun the reproducer plus affected package checks.
    Complete when the original failure is gone and a regression test covers the cause where practical.

For intermittent failures, vary one dimension at a time: repetition (`-count`), scheduling (`-race`, `GOMAXPROCS`), test selection, environment, or timing.
For performance regressions, compare benchmarks under equivalent conditions and inspect CPU, memory, block, mutex, or execution profiles with pprof before optimizing.

Clear caches only after evidence points to corrupted external state. Cache cleaning is not a substitute for confirming which files, tags, generated artifacts, and code paths are active.
