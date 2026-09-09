#!/usr/bin/env bash
# run.sh - deterministic checks over the scripts, the report renderer and the docs.
#
# Usage:
#   ./tests/run.sh              # offline suite only. no registry traffic.
#   ./tests/run.sh --network    # adds the live RDAP controls. ~20 lookups.
#
# The offline suite is the one to run on every change. The network suite exists for one
# reason: to catch an RDAP server that answers 404 for a domain that is actually
# registered. That silently manufactures "available" results, which is the worst failure
# this tool can have, and no offline test can see it.
#
# Exit status is the number of failures.

set -uo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
NETWORK=0
[ "${1:-}" = "--network" ] && NETWORK=1

# never touch the user's real cache
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
export NAMING_SCOUT_CACHE="$TMP/cache"

PASS=0; FAIL=0
ok(){   PASS=$((PASS+1)); printf '  ok   %s\n' "$1"; }
bad(){  FAIL=$((FAIL+1)); printf '  FAIL %s\n' "$1"; [ -n "${2:-}" ] && printf '       %s\n' "$2"; }
grp(){  printf '\n%s\n' "$1"; }

# assert helpers ---------------------------------------------------------------
is(){ # is <label> <expected> <actual>
  [ "$2" = "$3" ] && ok "$1" || bad "$1" "expected '$2', got '$3'"; }
has(){ # has <label> <needle> <haystack-file>
  grep -qF -- "$2" "$3" && ok "$1" || bad "$1" "missing: $2"; }
hasnt(){
  grep -qF -- "$2" "$3" && bad "$1" "found what should be absent: $2" || ok "$1"; }

# ---------------------------------------------------------------- scripts
grp "scripts"
for f in "$ROOT"/scripts/*.sh; do
  n=$(basename "$f")
  bash -n "$f" 2>/dev/null && ok "$n parses" || bad "$n parses"
  [ -x "$f" ] && ok "$n is executable" || bad "$n is executable" "chmod +x $f"
  head -1 "$f" | grep -q '^#!' && ok "$n has a shebang" || bad "$n has a shebang"
  "$f" --help >/dev/null 2>&1 && ok "$n --help exits 0" || bad "$n --help exits 0"
done

# ---------------------------------------------------------------- variants
grp "variants.sh"
v="$TMP/v.txt"; "$ROOT/scripts/variants.sh" signalforge > "$v"
is "default set is non-empty" 1 "$([ -s "$v" ] && echo 1 || echo 0)"
is "output is deduplicated" "$(wc -l < "$v" | tr -d ' ')" "$(sort -u "$v" | wc -l | tr -d ' ')"
is "no blank lines" 0 "$(grep -c '^$' "$v" || true)"
is "every line is a legal DNS label" 0 \
   "$(LC_ALL=C grep -cE '[^a-z0-9-]|^-|-$|^.{64,}$' "$v" || true)"
has "keeps the original name" "signalforge" "$v"
has "article set covers the get- route" "getsignalforge" "$v"
t="$TMP/t.txt"; "$ROOT/scripts/variants.sh" --set translit dokan > "$t"
[ "$(wc -l < "$t" | tr -d ' ')" -gt 2 ] && ok "translit set expands a romanisation" \
  || bad "translit set expands a romanisation" "got $(wc -l < "$t") line(s)"

# ---------------------------------------------------------------- report
grp "report.sh"
"$ROOT/scripts/report.sh" --schema | sed -n '1,/^}$/p' | jq -e . >/dev/null 2>&1 \
  && ok "--schema emits parseable JSON" || bad "--schema emits parseable JSON"
jq -e . "$ROOT/examples/report-data.example.json" >/dev/null 2>&1 \
  && ok "example payload is valid JSON" || bad "example payload is valid JSON"

# the rejected array must survive into the page
ex="$TMP/r.json"
jq '.rejected=[{name:"Growthly",direction:"Suffix constructions",why_cut:"exhausted space"}]' \
  "$ROOT/examples/report-data.example.json" > "$ex"
out="$TMP/r.html"
"$ROOT/scripts/report.sh" "$ex" -o "$out" --no-open >/dev/null 2>&1 \
  && ok "renders the example payload" || bad "renders the example payload"
hasnt "template placeholder is replaced" "__NAMING_SCOUT_DATA__" "$out"
has "embeds the candidates" "Leadsman" "$out"
has "renders the cut list section" "Considered and cut" "$out"
has "carries the rejected rows" "Growthly" "$out"
grep -qE '(src|href)="https?://' "$out" \
  && bad "page is self-contained" "found an external src/href" || ok "page is self-contained"
# every section optional: a near-empty payload must still render
printf '{"title":"t"}' > "$TMP/min.json"
"$ROOT/scripts/report.sh" "$TMP/min.json" -o "$TMP/min.html" --no-open >/dev/null 2>&1 \
  && ok "renders a payload with no candidates" || bad "renders a payload with no candidates"

# ---------------------------------------------------------------- input safety
grp "rdap.sh input handling"
r="$TMP/inv.tsv"
printf '%s\n' 'not a name!' '-leading' 'trailing-' | "$ROOT/scripts/rdap.sh" --tlds com --quiet > "$r" 2>/dev/null
rc=$?
is "rejects every unusable label" 3 "$(grep -c 'invalid' "$r" || true)"
is "reports why, rather than dying silently" 2 "$rc"
hasnt "never labels a rejected input available" "available" "$r"
# a bad line among good ones must not take the good ones down with it
m="$TMP/mix.tsv"
printf '%s\n' 'bad name!' leadsman | "$ROOT/scripts/rdap.sh" --tlds com --quiet > "$m" 2>/dev/null
is "one bad label does not discard the rest" 1 "$(grep -c 'leadsman.com' "$m" || true)"

# ---------------------------------------------------------------- docs
grp "docs"
missing=0
while read -r pth; do
  [ -e "$ROOT/$pth" ] || { bad "SKILL.md references $pth" "no such file"; missing=1; }
done < <(grep -o '`\(references\|examples\|scripts\|assets\)/[a-zA-Z0-9._-]*`' "$ROOT/SKILL.md" \
         | tr -d '`' | sort -u)
[ "$missing" = 0 ] && ok "every path named in SKILL.md exists"
for f in "$ROOT"/examples/*.md; do
  grep -qF "$(basename "$f")" "$ROOT/SKILL.md" && ok "$(basename "$f") is indexed in SKILL.md" \
    || bad "$(basename "$f") is indexed in SKILL.md" "an unindexed example gets opened by guesswork"
done
for c in "$HERE"/cases/*.md; do
  n=$(basename "$c")
  grep -q '^\*\*Must\*\*$' "$c" && grep -q '^\*\*Fails if\*\*$' "$c" \
    && ok "case $n states must and fails-if" \
    || bad "case $n states must and fails-if" "a case with no failure condition grades nothing"
done

grep -q '^name: naming-scout$' "$ROOT/SKILL.md" && ok "frontmatter declares the name" \
  || bad "frontmatter declares the name"
d=$(grep -m1 '^description: ' "$ROOT/SKILL.md" | cut -c14-)
[ "${#d}" -gt 80 ] && [ "${#d}" -lt 1024 ] && ok "description is a usable length (${#d})" \
  || bad "description is a usable length" "got ${#d} chars"

# ---------------------------------------------------------------- live registries
if [ "$NETWORK" = 1 ]; then
  grp "live RDAP controls (a 404 here would manufacture false 'available')"
  # every control below is a domain that is definitely registered. Any of them coming
  # back 'available' means that TLD's server is answering for names it does not serve.
  for pair in "nic.io" "nic.sh" "about.me" "twitch.tv" "example.com" "example.net" "example.org"; do
    name="${pair%%.*}"; tld="${pair#*.}"
    st=$(printf '%s\n' "$name" | "$ROOT/scripts/rdap.sh" --tlds "$tld" --quiet --no-cache 2>/dev/null \
         | awk -F'\t' 'NR>1{print $2; exit}')
    case "$st" in
      registered|parked|for_sale|reserved) ok "$pair reads as taken ($st)" ;;
      available) bad "$pair reads as taken" "returned 'available'. THIS SERVER IS LYING." ;;
      *)         ok "$pair is inconclusive ($st), which is not a false negative" ;;
    esac
  done
  free="zz$(date +%s)qxnames"
  st=$(printf '%s\n' "$free" | "$ROOT/scripts/rdap.sh" --tlds com --quiet --no-cache 2>/dev/null \
       | awk -F'\t' 'NR>1{print $2; exit}')
  is "an unregistered label reads as available" "available" "$st"
  st=$(printf '%s\n' testname | "$ROOT/scripts/rdap.sh" --tlds bd --quiet --no-cache 2>/dev/null \
       | awk -F'\t' 'NR>1{print $2; exit}')
  case "$st" in
    unknown*) ok "a TLD with no RDAP reads as unknown, not available" ;;
    *)        bad "a TLD with no RDAP reads as unknown" "got '$st'" ;;
  esac
fi

printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
[ "$NETWORK" = 0 ] && printf 'offline suite only. run with --network for the registry controls.\n'
exit "$FAIL"
