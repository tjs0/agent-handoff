#!/usr/bin/env bash
# Static checks: manifests agree on name and version, each skill's frontmatter
# names its directory, no em or en dashes, and each agent's own validator
# passes when that agent is installed.
set -uo pipefail
cd "$(dirname "$(readlink -f "$0")")/.."
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

manifests=(.claude-plugin/plugin.json .codex-plugin/plugin.json .antigravity-plugin/plugin.json)
version="$(jq -r .version .claude-plugin/plugin.json)"
for m in "${manifests[@]}" .claude-plugin/marketplace.json .agents/plugins/marketplace.json; do
  jq empty "$m" 2>/dev/null || err "$m is not valid JSON"
done
for m in "${manifests[@]}"; do
  [ "$(jq -r .name "$m")" = agent-handoff ] || err "$m: name is not agent-handoff"
  [ "$(jq -r .version "$m")" = "$version" ] || err "$m: version differs from $version"
done
[ "$(jq -r '.plugins[0].version' .claude-plugin/marketplace.json)" = "$version" ] \
  || err ".claude-plugin/marketplace.json: version differs from $version"

for d in skills/*/; do
  n="$(basename "$d")"
  [ "$(sed -n 's/^name: //p' "$d/SKILL.md" | head -1)" = "$n" ] || err "$d: frontmatter name is not $n"
  grep -q '^description: Use only when the user invokes' "$d/SKILL.md" \
    || err "$d: description must say it is user-invoked (Codex shows it to the model)"
  grep -q '^disable-model-invocation: true' "$d/SKILL.md" || err "$d: missing disable-model-invocation"
done

if grep -rnP '\x{2014}|\x{2013}' --exclude-dir=.git . >&2; then err "em or en dash found"; fi

if command -v claude >/dev/null; then
  claude plugin validate --strict .claude-plugin/plugin.json >/dev/null || err "claude plugin validate (plugin)"
  claude plugin validate --strict .claude-plugin/marketplace.json >/dev/null || err "claude plugin validate (marketplace)"
fi
if command -v agy >/dev/null; then
  agy plugin validate . >/dev/null 2>&1 || err "agy plugin validate"
fi

[ "$fail" -eq 0 ] && echo "ok"
exit "$fail"
