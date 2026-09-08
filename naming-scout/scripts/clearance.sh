#!/usr/bin/env bash
# clearance.sh - non-domain namespace checks for a candidate name.
#
# Covers the checks that have a real API and therefore a trustworthy answer.
# Checks that do not (social handles, trademark, app stores) are deliberately
# absent: see references/clearance-guide.md for how to handle those instead of
# pretending a status code settles them.
#
# Usage:
#   ./clearance.sh --checks github,npm,pypi NAME [NAME...]
#   printf '%s\n' name1 name2 | ./clearance.sh --checks github,npm
#
# Options:
#   --checks LIST   comma-separated: github,npm,pypi,crates,rubygems,gohomepage,dockerhub
#                   or 'all'.                          default: github,npm,pypi
#   --jobs N        parallel workers.                   default: 6
#   --format tsv|json                                   default: tsv
#   --quiet         suppress the stderr summary
#
# Output columns:  name  check  state  confidence  detail
#
# States:
#   free            the namespace API says nothing is registered under this name
#   taken           something is registered under this name
#   unknown         rate limited, blocked, or the API errored. NOT a negative result.
#
# Confidence:
#   high            authoritative registry API, both directions trustworthy
#   medium          public endpoint that can rate limit or soft-block
#
# GitHub note: an unauthenticated caller gets 60 requests/hour. Export GITHUB_TOKEN
# to raise that to 5000 and to stop 'free' results being drowned in 403s.

set -uo pipefail

UA="naming-scout/1.0"
CONNECT_TIMEOUT=6
MAX_TIME=15
CHECKS="github,npm,pypi"
JOBS=6
FORMAT=tsv
QUIET=0

die(){ printf 'clearance.sh: %s\n' "$*" >&2; exit 2; }
command -v curl >/dev/null || die "curl not found"

# ---------------------------------------------------------------- worker mode
if [ "${1:-}" = "__worker" ]; then
  name="$2"; check="$3"
  row(){ printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$check" "$1" "$2" "${3:--}"; }

  # slugs differ per ecosystem: npm and PyPI normalise, GitHub does not allow underscores
  slug_lower=$(printf '%s' "$name" | tr 'A-Z' 'a-z')
  slug_dash=$(printf '%s' "$slug_lower" | tr '_ ' '--')

  fetch(){ # fetch URL [extra-header] [use-github-token] -> sets HTTP
    local args=(-sSL -o /dev/null -A "$UA"
                --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" -w '%{http_code}')
    [ -n "${2:-}" ] && args+=(-H "$2")
    [ -n "${3:-}" ] && [ -n "${GITHUB_TOKEN:-}" ] && args+=(-H "Authorization: Bearer $GITHUB_TOKEN")
    HTTP=$(curl "${args[@]}" "$1" 2>/dev/null)
  }

  case "$check" in
    github)
      # the users API covers both users and orgs; 404 means the login is unclaimed
      fetch "https://api.github.com/users/$slug_dash" "Accept: application/vnd.github+json" auth
      case "$HTTP" in
        404) row free   high   "github.com/$slug_dash unclaimed" ;;
        200) row taken  high   "https://github.com/$slug_dash" ;;
        403|429) row unknown medium "rate limited (set GITHUB_TOKEN to raise the limit)" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    npm)
      fetch "https://registry.npmjs.org/$slug_dash"
      case "$HTTP" in
        404) row free  high "unpublished on npm" ;;
        200) row taken high "https://www.npmjs.com/package/$slug_dash" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    pypi)
      fetch "https://pypi.org/pypi/$slug_dash/json"
      case "$HTTP" in
        404) row free  high "unpublished on PyPI" ;;
        200) row taken high "https://pypi.org/project/$slug_dash/" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    crates)
      fetch "https://crates.io/api/v1/crates/$(printf '%s' "$slug_lower" | tr ' ' '_')"
      case "$HTTP" in
        404) row free  high "unpublished on crates.io" ;;
        200) row taken high "https://crates.io/crates/$slug_lower" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    rubygems)
      fetch "https://rubygems.org/api/v1/gems/$slug_dash.json"
      case "$HTTP" in
        404) row free  high "unpublished on RubyGems" ;;
        200) row taken high "https://rubygems.org/gems/$slug_dash" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    dockerhub)
      # /v2/repositories/NAME/ is a list endpoint and returns 200 with an empty page for
      # any name, so it cannot answer this. /v2/users and /v2/orgs 404 correctly.
      fetch "https://hub.docker.com/v2/users/$slug_lower/"
      if [ "$HTTP" = 404 ]; then fetch "https://hub.docker.com/v2/orgs/$slug_lower/"; fi
      case "$HTTP" in
        404) row free  high "no Docker Hub user or org namespace" ;;
        200) row taken high "https://hub.docker.com/u/$slug_lower" ;;
        *)   row unknown medium "http $HTTP" ;;
      esac ;;
    gohomepage)
      # Go has no central registry; pkg.go.dev indexes what has been fetched at least once
      fetch "https://pkg.go.dev/search?q=$slug_lower"
      row unknown medium "Go has no name registry; check https://pkg.go.dev/search?q=$slug_lower by hand" ;;
    *) row unknown medium "unsupported check: $check" ;;
  esac
  exit 0
fi

# ---------------------------------------------------------------- parent mode
names=()
while [ $# -gt 0 ]; do
  case "$1" in
    --checks) CHECKS="${2:?}"; shift 2 ;;
    --jobs)   JOBS="${2:?}";   shift 2 ;;
    --format) FORMAT="${2:?}"; shift 2 ;;
    --quiet)  QUIET=1; shift ;;
    -h|--help) sed -n '2,36p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "unknown option: $1" ;;
    *)  names+=("$1"); shift ;;
  esac
done
[ "$CHECKS" = all ] && CHECKS="github,npm,pypi,crates,rubygems,dockerhub"

if [ ${#names[@]} -eq 0 ]; then
  while IFS= read -r l; do
    l=$(printf '%s' "$l" | tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    case "$l" in ""|\#*) continue ;; esac
    names+=("$l")
  done
fi
[ ${#names[@]} -gt 0 ] || die "no names given (as arguments or on stdin)"

# names go straight into request URLs, so reject anything outside the package-name
# character set rather than letting curl normalise a path out of it
clean=()
for n in "${names[@]}"; do
  c=$(printf '%s' "$n" | tr 'A-Z' 'a-z' | tr -d " '\t&")
  c="${c%.}"
  if [ -z "$c" ] || printf '%s' "$c" | LC_ALL=C grep -q '[^a-z0-9._-]' || case "$c" in .*|*..*) true ;; *) false ;; esac; then
    printf '%s\t-\tinvalid\thigh\tnot a usable package or org name\n' "${n:-<blank>}" >&2
    continue
  fi
  clean+=("$c")
done
names=("${clean[@]}")
[ ${#names[@]} -gt 0 ] || die "no usable names after validation"

work=$(mktemp); rows=$(mktemp); trap 'rm -f "$work" "$rows"' EXIT
IFS=',' read -r -a check_arr <<< "$CHECKS"
for n in "${names[@]}"; do
  for c in "${check_arr[@]}"; do
    c=$(printf '%s' "$c" | tr -d ' ')
    [ -n "$c" ] && printf '%s %s\n' "$n" "$c" >> "$work"
  done
done

xargs -P "$JOBS" -I{} bash -c 'read -r n c <<< "$1"; "$0" __worker "$n" "$c"' "$0" {} < "$work" > "$rows" 2>/dev/null

if [ "$FORMAT" = json ]; then
  sort -t$'\t' -k1,1 -k2,2 "$rows" | jq -R -s -c \
    'split("\n")|map(select(length>0)|split("\t")|{name:.[0],check:.[1],state:.[2],confidence:.[3],detail:.[4]})'
else
  printf '#name\tcheck\tstate\tconfidence\tdetail\n'
  sort -t$'\t' -k1,1 -k2,2 "$rows"
fi

if [ "$QUIET" = 0 ]; then
  u=$(awk -F'\t' '$3=="unknown"' "$rows" | wc -l | tr -d ' ')
  printf '\n' >&2
  awk -F'\t' '{c[$3]++} END{for(s in c) printf "  %-9s %d\n", s, c[s]}' "$rows" | sort -k2 -rn >&2
  [ "$u" -gt 0 ] && printf '  %s row(s) unverified - report these as unknown, not as free\n' "$u" >&2
  printf '  not covered here: trademark, social handles, app stores, search presence\n' >&2
fi
exit 0
