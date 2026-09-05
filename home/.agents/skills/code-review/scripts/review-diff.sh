#!/usr/bin/env bash
# Emit only the tracked patch; the review workflow owns untracked-file selection.
set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: bash %s branch|staged|worktree <base-commit>\n' "$0" >&2
    exit 2
fi

mode=$1
case "$mode" in
    branch|staged|worktree) ;;
    *) printf 'Unknown review mode: %s\n' "$mode" >&2; exit 2 ;;
esac

base=$(git rev-parse --verify --end-of-options "${2}^{commit}")
head=$(git rev-parse --verify HEAD)

case "$mode" in
    branch)
        comparison=$(git merge-base "$base" "$head")
        git diff --no-ext-diff --no-textconv --no-color "$comparison" "$head" --
        ;;
    staged)
        git diff --no-ext-diff --no-textconv --no-color --cached "$base" --
        ;;
    worktree)
        git diff --no-ext-diff --no-textconv --no-color "$base" --
        ;;
esac
