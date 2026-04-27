#!/bin/bash

set -e

# Resolve repo root
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Check if data-model source models are modified and if so run the compiler
CHANGED_FILES=$(git diff --cached --name-only)
if echo "$CHANGED_FILES" | grep -qE 'packages/data-model/src/models/(carbon-analytics|nox-analytics|transport-analytics|otm-carbon-analytics)\.ts'; then
  echo "Running data-model compiler..."
  "$REPO_ROOT/tools/data-model-compiler/run.sh"
fi

# Static files that should always be checked
STATIC_FILES=(
  "packages/cubejs-definitions/src/cubejs-schema-static/cubes.ts"
  "packages/cubejs-definitions/src/cubejs-schema-static-generated/cubes.ts"
)

# Directories where generated files live
GENERATED_DIRS=(
  "packages/data-model/src/generated"
)

# Collect all target files (static + generated)
TARGET_FILES=()

for file in "${STATIC_FILES[@]}"; do
  TARGET_FILES+=("$file")
done

for dir in "${GENERATED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    for file in "$dir"/*; do
      [ -f "$file" ] && TARGET_FILES+=("$file")
    done
  fi
done

# Filter to only files that have changes (staged or unstaged)
DIRTY_FILES=()
for TARGET_FILE in "${TARGET_FILES[@]}"; do
  [ ! -f "$TARGET_FILE" ] && continue
  if ! git diff --quiet -- "$TARGET_FILE" || ! git diff --cached --quiet -- "$TARGET_FILE"; then
    DIRTY_FILES+=("$TARGET_FILE")
  fi
done

# If there are dirty generated/static files, lint and format them, then auto-stage
if [ ${#DIRTY_FILES[@]} -gt 0 ]; then
  # Separate JS/TS files for oxlint
  JS_TS_DIRTY=()
  for f in "${DIRTY_FILES[@]}"; do
    case "$f" in
      *.ts|*.tsx|*.js|*.jsx) JS_TS_DIRTY+=("$f") ;;
    esac
  done

  if [ ${#JS_TS_DIRTY[@]} -gt 0 ]; then
    echo "Linting generated files..."
    oxlint --quiet "${JS_TS_DIRTY[@]}" || exit 1
  fi

  echo "Formatting generated files..."
  oxfmt --write "${DIRTY_FILES[@]}" || exit 1

  echo "Auto-staging generated files..."
  git add "${DIRTY_FILES[@]}"
fi

exit 0
