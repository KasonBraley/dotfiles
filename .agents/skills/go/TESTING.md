# Go Testing Reference

Write tests as ordinary Go. Prefer the standard `testing` package, focused helpers, and explicit seams over framework-heavy suites or generated mocks.

## Test shape

Use table-driven tests when several cases share setup and assertions; use direct tests when a table obscures the behavior. Name cases for behavior, and call `t.Run` when its isolation or output helps.

```go
func TestParsePort(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    int
        wantErr bool
    }{
        {name: "valid", input: "8080", want: 8080},
        {name: "non-numeric", input: "abc", wantErr: true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParsePort(tt.input)
            if (err != nil) != tt.wantErr {
                t.Fatalf("ParsePort(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
            }
            if got != tt.want {
                t.Errorf("ParsePort(%q) = %d, want %d", tt.input, got, tt.want)
            }
        })
    }
}
```

Mark assertion and setup helpers with `t.Helper()`. Prefer `t.Cleanup` for test-owned cleanup. Include enough input in failures to diagnose the case without reproducing it.

## Seams and test data

Define the smallest interface at the code under test and use a hand-written fake or stub. A fake should model only behavior relevant to the test. Prefer a temporary real filesystem via `t.TempDir()` unless an in-memory filesystem is itself the required seam; follow an existing repository abstraction rather than introducing one solely for a test.

Put complex fixtures and golden files under `testdata`. Make golden updates an explicit opt-in and review their diffs. Use `go-cmp` only when the repository already uses it or its readable structural diff justifies the dependency; otherwise compare directly.

## Modern testing APIs

Use only APIs supported by the module's Go version. Relevant modern APIs include `t.Context`, `t.Chdir`, `b.Loop`, and `testing/synctest`; consult `use-modern-go` before emitting them.

For concurrent tests, synchronize on observable events. Use channels, wait groups, or `testing/synctest` where supported. A sleep is suitable only when elapsed time is itself the behavior under test, not as a guess that another goroutine has run.

## Verification

Run the smallest test that proves the behavior while iterating, then the affected package tests. Expand to `go test ./...`, repository linting, and `go vet ./...` when their scope and runtime are appropriate. Use `go test -race` for changed shared-memory concurrency when the environment supports it.

A test change is complete when it fails for the intended regression before the fix when practicable, passes afterward, and exercises relevant success, error, and cancellation boundaries.
