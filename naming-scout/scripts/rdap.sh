#!/usr/bin/env bash
# rdap.sh - registry-level domain status via RDAP.
#
# Answers "is this domain in the registry?" by asking the registry, not a registrar.
# A registrar search box collapses registered, premium and aftermarket into one red X.
# This does not.
#
# Usage:
#   printf '%s\n' name1 name2 | ./rdap.sh --tlds com,io,dev
#   ./rdap.sh --tlds com --names names.txt
#   ./rdap.sh --tlds com,ai --names - < names.txt
#
# Options:
#   --tlds LIST     comma-separated TLDs, no dots.        default: com
#   --names FILE    file of names, one per line, - = stdin. default: stdin
#   --jobs N        parallel workers.                     default: 8
#   --format tsv|json                                     default: tsv
#   --no-cache      skip the local result cache
#   --refresh-map   re-fetch the IANA bootstrap now
#   --states LIST   print only these states, comma-separated. e.g. available,for_sale
#   --available     shorthand for --states available
#   --quiet         suppress the stderr summary
#
# Output columns (TSV, one header line beginning with '#'):
#   domain  state  created  signal  source
#
# States:
#   available            registry returned 404. Not in the registry.
#   registered           in the registry.
#   parked               registered, nameservers belong to a parking host.
#   for_sale             registered, nameservers belong to a domain marketplace.
#   reserved             registry marks the name reserved/blocked. Not buyable.
#   unknown_no_rdap      no verified RDAP server for this TLD. NOT a negative result.
#   unknown_error        rate limited, timed out, or server error. NOT a negative result.
#   invalid              label is not a legal DNS label.
#
# Never read unknown_* as "available". That distinction is the point of this script.

set -uo pipefail

CACHE_DIR="${NAMING_SCOUT_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/naming-scout}"
MAP_FILE="$CACHE_DIR/rdap-servers.json"
MAP_TTL_SECS=$(( 7 * 24 * 3600 ))
RES_DIR="$CACHE_DIR/results"
TTL_REGISTERED=$(( 30 * 24 * 3600 ))   # registered rarely flips to free, and never abruptly
TTL_AVAILABLE=3600                     # a stale "available" is the one wrong answer that costs money
TTL_UNKNOWN=300
BOOTSTRAP_URL="https://data.iana.org/rdap/dns.json"
UA="naming-scout/1.0 (+RDAP client; contact via repository)"
MAX_RETRIES=4
CONNECT_TIMEOUT=8
MAX_TIME=20

# Fallback servers, consulted only when the IANA bootstrap has no entry for a TLD (either
# because the bootstrap genuinely omits it, or because the bootstrap fetch failed). Every
# entry here was verified by hand against a known-registered control domain AND a known-free
# one. Only add entries you verified BOTH ways: a server that 404s on a registered domain
# silently manufactures false "available" results, which is the worst failure this tool has.
# During development, rdap.org and several plausible-looking servers did exactly that.
declare -a OVERRIDES=(
  "io|https://rdap.identitydigital.services/rdap/"    # control: nic.io    200 / free 404
  "sh|https://rdap.identitydigital.services/rdap/"    # control: nic.sh    200
  "me|https://rdap.identitydigital.services/rdap/"    # control: about.me  200 / free 404
  "tv|https://rdap.nic.tv/"                           # control: twitch.tv 200 / free 404
  "com|https://rdap.verisign.com/com/v1/"             # keeps .com working if the bootstrap
  "net|https://rdap.verisign.com/net/v1/"             # fetch fails on a cold cache
  "org|https://rdap.publicinterestregistry.org/rdap/"
)

die(){ printf 'rdap.sh: %s\n' "$*" >&2; exit 2; }
log(){ [ "$QUIET" = 1 ] || printf '%s\n' "$*" >&2; }

command -v curl >/dev/null || die "curl not found"
command -v jq   >/dev/null || die "jq not found (brew install jq / apt install jq)"

TLDS="com"; NAMES_SRC="-"; JOBS=8; FORMAT=tsv; USE_CACHE=1; REFRESH_MAP=0; STATES=""; QUIET=0

# ---------------------------------------------------------------- worker mode
# The script re-invokes itself through xargs for each domain. Everything below
# __worker runs in a child process and prints exactly one row.
if [ "${1:-}" = "__worker" ]; then
  domain="$2"; server="$3"; use_cache="$4"
  name="${domain%%.*}"; tld="${domain#*.}"

  emit(){ printf '%s\t%s\t%s\t%s\t%s\n' "$domain" "$1" "${2:--}" "${3:--}" "${4:-rdap}"; }

  cache_path="$RES_DIR/$(printf '%s' "$domain" | tr 'A-Z' 'a-z').row"
  if [ "$use_cache" = 1 ] && [ -f "$cache_path" ]; then
    cached=$(cat "$cache_path" 2>/dev/null)
    c_state=$(printf '%s' "$cached" | cut -f2)
    c_age=$(( $(date +%s) - $(stat -f %m "$cache_path" 2>/dev/null || stat -c %Y "$cache_path" 2>/dev/null || echo 0) ))
    case "$c_state" in
      available)            ttl=$TTL_AVAILABLE ;;
      unknown_*)            ttl=$TTL_UNKNOWN ;;
      *)                    ttl=$TTL_REGISTERED ;;
    esac
    if [ "$c_age" -lt "$ttl" ]; then printf '%s\n' "$cached" | awk -F'\t' 'BEGIN{OFS="\t"}{$5=$5"+cache";print}'; exit 0; fi
  fi

  if [ -z "$server" ]; then emit unknown_no_rdap - "no RDAP server for .$tld" none; exit 0; fi

  url="${server%/}/domain/$domain"
  body=""; code=""; attempt=0
  while : ; do
    attempt=$(( attempt + 1 ))
    resp=$(curl -sSL -A "$UA" -H 'Accept: application/rdap+json' \
                 --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
                 -w '\n__HTTP__%{http_code}' "$url" 2>/dev/null)
    code="${resp##*__HTTP__}"; body="${resp%$'\n'__HTTP__*}"
    case "$code" in
      429|500|502|503|504|000|"")
        if [ "$attempt" -ge "$MAX_RETRIES" ]; then break; fi
        # exponential backoff with jitter, so parallel workers do not resynchronise
        sleep "$(awk -v a="$attempt" 'BEGIN{srand();printf "%.2f", (2^(a-1)) + rand()}')"
        ;;
      *) break ;;
    esac
  done

  state=""; created="-"; signal="-"
  case "$code" in
    404) state=available ;;
    200)
      created=$(printf '%s' "$body" | jq -r '[.events[]?|select(.eventAction=="registration")|.eventDate][0] // "-"' 2>/dev/null)
      created="${created%%T*}"; [ -n "$created" ] || created="-"
      ns=$(printf '%s' "$body" | jq -r '[.nameservers[]?.ldhName]|join(",")' 2>/dev/null | tr 'A-Z' 'a-z')
      st=$(printf '%s' "$body" | jq -r '[.status[]?]|join(",")' 2>/dev/null)
      registrar=$(printf '%s' "$body" | jq -r '[.entities[]?|select(.roles[]?=="registrar")|.vcardArray[1][]?|select(.[0]=="fn")|.[3]][0] // "-"' 2>/dev/null)
      state=registered; signal="registrar=$registrar"
      case "$st" in
        *reserved*|*blocked*) state=reserved; signal="registry status: $st" ;;
      esac
      if [ "$state" = registered ]; then
        case "$ns" in
          # nameservers delegated to a marketplace: the holder is advertising a sale
          *afternic*|*sedoparking*|*sedo.com*|*dan.com*|*undeveloped*|*hugedomains*|*domainmarket*|*brandbucket*|*squadhelp*|*atom.com*|*abovedomains*|*efty*|*namebrightdns*)
            state=for_sale; signal="marketplace ns: ${ns%%,*}" ;;
          # nameservers delegated to a parking/monetisation host: no real site behind it
          *bodis*|*parkingcrew*|*sedo*|*above.com*|*parklogic*|*cashparking*|*fabulous.com*|*voodoo.com*|*dsredirection*|*parkpage*|*trademarkarea*)
            state=parked; signal="parking ns: ${ns%%,*}" ;;
          "")
            signal="no nameservers (often expiring or on hold); registrar=$registrar" ;;
        esac
      fi
      ;;
    400|422) state=invalid;       signal="registry rejected the query (http $code)" ;;
    *)       state=unknown_error; signal="http $code after $attempt attempt(s)" ;;
  esac

  row=$(printf '%s\t%s\t%s\t%s\trdap' "$domain" "$state" "$created" "$signal")
  printf '%s\n' "$row"

  # only cache states the registry actually asserted; never cache an error
  case "$state" in
    available|registered|parked|for_sale|reserved)
      mkdir -p "$RES_DIR" 2>/dev/null && printf '%s\n' "$row" > "$cache_path" 2>/dev/null ;;
  esac
  exit 0
fi

# ---------------------------------------------------------------- parent mode
while [ $# -gt 0 ]; do
  case "$1" in
    --tlds)        TLDS="${2:?}"; shift 2 ;;
    --names)       NAMES_SRC="${2:?}"; shift 2 ;;
    --jobs)        JOBS="${2:?}"; shift 2 ;;
    --format)      FORMAT="${2:?}"; shift 2 ;;
    --no-cache)    USE_CACHE=0; shift ;;
    --refresh-map) REFRESH_MAP=1; shift ;;
    --states)      STATES="${2:?}"; shift 2 ;;
    --available)   STATES="available"; shift ;;
    --quiet)       QUIET=1; shift ;;
    -h|--help)     sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)             die "unknown option: $1 (try --help)" ;;
  esac
done
mkdir -p "$CACHE_DIR" "$RES_DIR" || die "cannot create cache dir $CACHE_DIR"

# --- IANA bootstrap: one fetch, cached for a week -------------------------------
map_age=$(( $(date +%s) - $(stat -f %m "$MAP_FILE" 2>/dev/null || stat -c %Y "$MAP_FILE" 2>/dev/null || echo 0) ))
if [ "$REFRESH_MAP" = 1 ] || [ ! -s "$MAP_FILE" ] || [ "$map_age" -gt "$MAP_TTL_SECS" ]; then
  log "· fetching IANA RDAP bootstrap"
  if curl -sSL -A "$UA" --connect-timeout 10 --max-time 30 "$BOOTSTRAP_URL" -o "$MAP_FILE.tmp" 2>/dev/null \
     && jq -e '.services|length>0' "$MAP_FILE.tmp" >/dev/null 2>&1; then
    mv "$MAP_FILE.tmp" "$MAP_FILE"
  else
    rm -f "$MAP_FILE.tmp"
    [ -s "$MAP_FILE" ] && log "! bootstrap fetch failed, using stale cached map" \
                       || log "! bootstrap unavailable; only override TLDs will resolve"
  fi
fi

server_for(){
  # bootstrap is authoritative; the hand-verified list is only a fallback
  local tld="$1" s=""
  [ -s "$MAP_FILE" ] && s=$(jq -r --arg t "$tld" \
      'first(.services[]|select(.[0][]==$t)|.[1][]|select(startswith("https")))//empty' "$MAP_FILE" 2>/dev/null)
  if [ -z "$s" ]; then
    for o in "${OVERRIDES[@]}"; do [ "${o%%|*}" = "$tld" ] && { s="${o#*|}"; break; }; done
  fi
  printf '%s' "$s"
}

# --- build the work list --------------------------------------------------------
if [ "$NAMES_SRC" = "-" ]; then names=$(cat); else [ -r "$NAMES_SRC" ] || die "cannot read $NAMES_SRC"; names=$(cat "$NAMES_SRC"); fi
IFS=',' read -r -a tld_arr <<< "$TLDS"

# bash 3.2 (macOS default) has no associative arrays, so the tld->server map is a
# newline-delimited "tld<TAB>server" string.
SERVER_MAP=""; NTLD=0
for t in "${tld_arr[@]}"; do
  t=$(printf '%s' "$t" | tr 'A-Z' 'a-z' | tr -d ' .')
  [ -n "$t" ] || continue
  srv=$(server_for "$t")
  SERVER_MAP="${SERVER_MAP}${t}\t${srv}\n"
  NTLD=$(( NTLD + 1 ))
  [ -n "$srv" ] || log "! no verified RDAP server for .$t - those rows will read unknown_no_rdap"
done

worklist=$(mktemp); rejects=$(mktemp); rows=$(mktemp)
trap 'rm -f "$worklist" "$rejects" "$rows"' EXIT
count=0
while IFS= read -r raw; do
  # order matters here: trim and comment-strip first, then drop a pasted TLD, and only
  # then validate. Sanitising before stripping turns "GOOGLE.COM" into "googlecom".
  line=$(printf '%s' "$raw" | tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
  case "$line" in ""|\#*) continue ;; esac
  n=$(printf '%s' "$line" | tr 'A-Z' 'a-z')
  n="${n%.}"                                   # trailing dot
  case "$n" in *.*) n="${n%.*} " ; n="${n% }" ;; esac   # drop a pasted TLD label
  # multi-word brand names are legitimate input: "Door Split" -> doorsplit
  n=$(printf '%s' "$n" | tr -d " '\t&.")
  # anything still outside the DNS label set is reported, never silently rewritten
  case "$n" in
    ""|-*|*-) printf '%s\tinvalid\t-\tnot a usable DNS label\tinput\n' "${line:-<blank>}" >> "$rejects"; continue ;;
  esac
  if printf '%s' "$n" | LC_ALL=C grep -q '[^a-z0-9-]' || [ "${#n}" -gt 63 ]; then
    printf '%s\tinvalid\t-\tnot a usable DNS label\tinput\n' "$line" >> "$rejects"; continue
  fi
  while IFS=$'\t' read -r t srv; do
    [ -n "$t" ] || continue
    printf '%s.%s\t%s\n' "$n" "$t" "$srv" >> "$worklist"
    count=$(( count + 1 ))
  done <<< "$(printf '%b' "$SERVER_MAP")"
done <<< "$names"

nrej=$(wc -l < "$rejects" 2>/dev/null | tr -d ' '); nrej=${nrej:-0}
[ "$nrej" -gt 0 ] && log "! $nrej input line(s) rejected as invalid labels"

STATUS=0
if [ "$count" -gt 0 ]; then
  log "· $count lookups across $NTLD TLD(s), $JOBS parallel"
  # xargs -I collapses tabs in the replacement string, so the worklist is handed over
  # space-separated: neither a domain nor an RDAP URL can contain a space.
  # shellcheck disable=SC2016
  awk -F'\t' '{print $1" "$2}' "$worklist" \
    | xargs -P "$JOBS" -I{} bash -c 'read -r d s <<< "$1"; "$0" __worker "$d" "$s" '"$USE_CACHE" "$0" {} \
    > "$rows" 2>/dev/null
else
  # nothing usable to look up. Still print the invalid rows: they say why.
  log "! no valid names on input"
  STATUS=2
fi

cat "$rejects" >> "$rows" 2>/dev/null
# ordering puts available first, then the states you might still buy, then the rest
state_rank(){ awk -F'\t' 'BEGIN{OFS="\t"}
  {r=9}
  $2=="available"{r=1} $2=="for_sale"{r=2} $2=="parked"{r=3} $2=="registered"{r=4}
  $2=="reserved"{r=5} $2 ~ /^unknown/{r=6} $2=="invalid"{r=7}
  {print r,$0}' "$rows" | sort -t$'\t' -k1,1n -k2,2 | cut -f2-; }

filter(){ # keep only the requested states, if any were requested
  if [ -z "$STATES" ]; then cat; else
    awk -F'\t' -v want=",$STATES," '{ if (index(want, "," $2 ",")) print }'
  fi
}

if [ "$FORMAT" = json ]; then
  state_rank | filter | jq -R -s -c \
    'split("\n")|map(select(length>0)|split("\t")|{domain:.[0],state:.[1],created:.[2],signal:.[3],source:.[4]})'
else
  printf '#domain\tstate\tcreated\tsignal\tsource\n'
  state_rank | filter
fi

if [ "$QUIET" = 0 ]; then
  printf '\n' >&2
  awk -F'\t' '{c[$2]++} END{for(s in c) printf "  %-18s %d\n", s, c[s]}' "$rows" | sort -k2 -rn >&2
  a=$(awk -F'\t' '$2=="available"' "$rows" | wc -l | tr -d ' ')
  u=$(awk -F'\t' '$2 ~ /^unknown/' "$rows" | wc -l | tr -d ' ')
  printf '  available rate: %s/%s\n' "$a" "$count" >&2
  [ "$u" -gt 0 ] && printf '  %s row(s) unverified - do not read these as available\n' "$u" >&2
fi
exit "$STATUS"
