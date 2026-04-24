#!/bin/bash
# Pre-commit hook: oxlint (errors only) + oxfmt check on staged JS/TS/YAML files

JS_TS_FILES=$(git diff --cached --name-only --diff-filter=d -- '*.ts' '*.tsx' '*.js' '*.jsx')
ALL_FILES=$(git diff --cached --name-only --diff-filter=d -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.yml' '*.yaml' '*.json')

EXIT=0

if [ -n "$JS_TS_FILES" ]; then
  echo "$JS_TS_FILES" | xargs oxlint --quiet || EXIT=1
fi

if [ -n "$ALL_FILES" ]; then
  echo "$ALL_FILES" | xargs oxfmt --fix || EXIT=1
fi

exit $EXIT
