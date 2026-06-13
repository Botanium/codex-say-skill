#!/usr/bin/env bash
set -euo pipefail

repo_root="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.."
  pwd
)"

helper="$repo_root/skills/say/scripts/codex-say"

bash -n "$helper"
"$helper" --help | grep -q "auto on"
"$helper" --dry-run "hello" | grep -q "Would speak"
"$helper" --dry-run --speed 1x "hello" | grep -q "170 wpm"
"$helper" --dry-run --speed 1.5x "hello" | grep -q "255 wpm"
"$helper" --dry-run --speed 2x "hello" | grep -q "340 wpm"
"$helper" auto status >/dev/null

tmp_config_home="$(mktemp -d)"
XDG_CONFIG_HOME="$tmp_config_home" "$helper" default rate 210 | grep -q "210 wpm"
XDG_CONFIG_HOME="$tmp_config_home" "$helper" default status | grep -q "210 wpm"
XDG_CONFIG_HOME="$tmp_config_home" "$helper" --dry-run "hello" | grep -q "210 wpm"
XDG_CONFIG_HOME="$tmp_config_home" "$helper" --dry-run -r 180 "hello" | grep -q "180 wpm"
rm -rf "$tmp_config_home"

citation_sample="$(mktemp -t codex-say-citation-sample)"
cat > "$citation_sample" <<'EOF'
Useful answer.

<oai-mem-citation>
<citation_entries>
MEMORY.md:1-2|note=[internal]
</citation_entries>
<rollout_ids>
00000000-0000-0000-0000-000000000000
</rollout_ids>
</oai-mem-citation>

2 memory citations
EOF
"$helper" --dry-run -f "$citation_sample" | grep -q "Would speak 14 characters"
if "$helper" --dry-run -f "$citation_sample" | grep -qi "memory"; then
  echo "Memory citation text leaked into dry-run output" >&2
  exit 1
fi
rm -f "$citation_sample"

codeblock_sample="$(mktemp -t codex-say-codeblock-sample)"
cat > "$codeblock_sample" <<'EOF'
Intro.

```bash
codex-say default rate 210
```

Done.
EOF
"$helper" --dry-run -f "$codeblock_sample" | grep -q "Would speak 41 characters"
rm -f "$codeblock_sample"

hardcoded_home_pattern="$(printf '/%s/' 'Users')"
if grep -R "$hardcoded_home_pattern" "$repo_root/skills/say" >/dev/null; then
  echo "Found local hardcoded path in skill files" >&2
  exit 1
fi

echo "Smoke tests passed."
