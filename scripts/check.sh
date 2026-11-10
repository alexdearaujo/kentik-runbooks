#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

failed=0
fail() {
  echo "FAIL: $1"
  failed=1
}

npx --yes markdownlint-cli2 '*.md' '.github/**/*.md' || failed=1

for file in *.md; do
  case "$file" in
    README.md | CONTRIBUTING.md | AGENTS.md | CLAUDE.md) continue ;;
  esac
  head -n 1 "$file" | grep -q '^# ' || fail "$file: the first line must be a '# ' title"
  grep -q '^\*\*Trigger:\*\*' "$file" || fail "$file: no '**Trigger:**' line"
  if grep -q '{{' "$file" && ! grep -q 'CUSTOMIZE BEFORE USE' "$file"; then
    fail "$file: has a {{PLACEHOLDER}} but no 'CUSTOMIZE BEFORE USE' comment"
  fi
  grep -qF "[$file]($file)" README.md || fail "$file: not in the README runbooks table"
done

if [[ $failed -ne 0 ]]; then
  exit 1
fi
echo "All checks passed."
