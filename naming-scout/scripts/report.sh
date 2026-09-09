#!/usr/bin/env bash
# report.sh - render a naming report as a self-contained HTML page and open it.
#
# Takes the report as JSON, injects it into assets/report-template.html, writes a single
# HTML file with no external dependencies, and opens it in the default browser.
#
# Usage:
#   ./report.sh report.json                     # render and open
#   ./report.sh report.json -o ~/naming.html    # choose the output path
#   ./report.sh report.json --no-open           # render only, print the path
#   ./report.sh --schema                        # print the JSON schema and exit
#   cat report.json | ./report.sh -             # read JSON from stdin
#
# Options:
#   -o, --out FILE   output path. default: a timestamped file in the system temp dir
#   --no-open        do not launch a browser
#   --schema         print the expected JSON shape
#
# Every field is optional. Sections with no data are omitted from the page rather than
# rendered empty, so a partial report renders correctly.

set -uo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMPLATE="$HERE/../assets/report-template.html"
OUT=""; DO_OPEN=1; SRC=""

die(){ printf 'report.sh: %s\n' "$*" >&2; exit 2; }
command -v jq >/dev/null || die "jq not found (brew install jq / apt install jq)"

schema(){ cat <<'JSON'
{
  "title":       "Naming Scout: <what is being named>",
  "subtitle":    "one line on the run",
  "date":        "YYYY-MM-DD",
  "domain_mode": "D. Aftermarket welcome",
  "clearance_profile": "Developer tool",

  "brief": { "naming":"", "does":"", "audience":"", "positioning":"",
             "personality":"", "constraints":"" },
  "assumptions": ["things you assumed because the user did not say"],

  "territories": [
    { "name":"Depth sounding", "description":"what the territory is",
      "fit":"why it fits this brief", "checked":24, "available":14,
      "note":"unmined / normal / exhausted" }
  ],

  "rounds": [
    { "round":1, "focus":"what this round explored", "checked":24, "available":1,
      "note":"what the rate told you" }
  ],

  "candidates": [
    { "rank":1, "name":"Leadsman", "territory":"Depth sounding",
      "why":"specific reason this name works, one or two sentences",
      "weakness":"the named cost. every candidate needs one",
      "verdict":"what you would do about it",
      "searchability":{ "grade":"ownable",
                        "note":"nothing else claims the term. first result within weeks" },
      "canonical":{ "spelling":"staticapi", "domain":"staticapi.com", "state":"for_sale",
                    "detail":"only for a respelled name. who holds the spelling users type" },
      "domains":  [ { "domain":"leadsman.dev", "state":"available", "detail":"" },
                    { "domain":"leadsman.com","state":"registered","detail":"since 1999" } ],
      "clearance":[ { "check":"GitHub","state":"taken","confidence":"high","detail":"" },
                    { "check":"npm","state":"free","confidence":"high","detail":"" } ] }
  ],

  "top3":           [ { "name":"", "reason":"", "dealbreaker":"what would make you drop it" } ],
  "unconventional": { "name":"", "reason":"", "cost":"what it demands" },
  "safest":         { "name":"", "reason":"", "cost":"" },
  "unverified":     [ "what you could not check, and why" ]
}

Domain states: available · for_sale · parked · registered · reserved · unknown · invalid
Clearance states: free · taken · unknown  (plus confidence: high · medium · low)
Searchability grades: ownable · contested · crowded  (see references/search-and-seo.md)
canonical: include only when the name is a respelling of a real word (statik for static).
           The page shows it as the traffic you would leak. See references/brand-filter.md.
Text fields accept **bold**, *italic* and `code`.
JSON
}

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--out)  OUT="${2:?}"; shift 2 ;;
    --no-open) DO_OPEN=0; shift ;;
    --schema)  schema; exit 0 ;;
    -h|--help) sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -)         SRC="-"; shift ;;
    -*)        die "unknown option: $1 (try --help)" ;;
    *)         SRC="$1"; shift ;;
  esac
done

[ -n "$SRC" ] || die "no input. pass a JSON file, or - for stdin. --schema prints the shape."
[ -r "$TEMPLATE" ] || die "template missing: $TEMPLATE"

if [ "$SRC" = "-" ]; then json=$(cat); else
  [ -r "$SRC" ] || die "cannot read $SRC"; json=$(cat "$SRC"); fi

# validate before writing anything: a broken page is worse than a clear error
printf '%s' "$json" | jq -e 'type=="object"' >/dev/null 2>&1 \
  || die "input is not a JSON object. run --schema to see the expected shape."

# Compact, then escape < so the payload can never terminate the host <script> block.
# Every < in valid JSON sits inside a string, so the substitution is always safe.
# The payload goes to a file rather than a variable: passing it through `awk -v` or a sed
# replacement would run backslash-escape processing over it and corrupt every \u and \".
payfile=$(mktemp); trap 'rm -f "$payfile"' EXIT
printf '%s' "$json" | jq -c . | sed 's|<|\\u003c|g' > "$payfile"

if [ -z "$OUT" ]; then
  slug=$(printf '%s' "$json" | jq -r '.title // "naming-report"' \
         | tr 'A-Z' 'a-z' | tr -cs 'a-z0-9' '-' | sed 's/^-//; s/-$//' | cut -c1-48)
  OUT="${TMPDIR:-/tmp}/${slug:-naming-report}-$(date +%Y%m%d-%H%M%S).html"
fi
mkdir -p "$(dirname "$OUT")" 2>/dev/null

# Splice by line, concatenating the payload from disk. No tool ever interprets its
# contents, so quotes, backslashes and unicode escapes survive verbatim.
ln=$(grep -n '__NAMING_SCOUT_DATA__' "$TEMPLATE" | head -1 | cut -d: -f1)
[ -n "$ln" ] || die "template has no __NAMING_SCOUT_DATA__ placeholder"
marker_line=$(sed -n "${ln}p" "$TEMPLATE")
{
  [ "$ln" -gt 1 ] && head -n "$((ln-1))" "$TEMPLATE"
  printf '%s' "${marker_line%%__NAMING_SCOUT_DATA__*}"
  cat "$payfile"
  printf '%s\n' "${marker_line#*__NAMING_SCOUT_DATA__}"
  tail -n "+$((ln+1))" "$TEMPLATE"
} > "$OUT" || die "could not write $OUT"

grep -q '__NAMING_SCOUT_DATA__' "$OUT" && die "placeholder not substituted; template may be corrupt"

n=$(printf '%s' "$json" | jq -r '(.candidates // []) | length')
printf 'report: %s (%s candidates)\n' "$OUT" "$n" >&2

if [ "$DO_OPEN" = 1 ]; then
  opener=""
  for c in open xdg-open wslview; do command -v "$c" >/dev/null && { opener="$c"; break; }; done
  if [ -n "$opener" ]; then
    "$opener" "$OUT" >/dev/null 2>&1 &
  else
    printf 'no browser opener found. open this file manually:\n  file://%s\n' "$OUT" >&2
  fi
fi
printf '%s\n' "$OUT"
