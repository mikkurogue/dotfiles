#!/bin/bash
# Pre-commit hook: cargo clippy + cargo fmt check on staged Rust files

RS_FILES=$(git diff --cached --name-only --diff-filter=d -- '*.rs')

if [ -z "$RS_FILES" ]; then
  exit 0
fi

EXIT=0

cargo fmt -- --check || EXIT=1
cargo clippy -- -D warnings || EXIT=1

exit $EXIT
