#!/usr/bin/env bash
# variants.sh - generate the defensive variant set for a finalist name.
#
# Only worth running on the two or three names you would actually launch. Running it
# on a whole shortlist multiplies your lookups by ~15 and tells you nothing you can act on.
#
# Usage:
#   ./variants.sh signalforge
#   ./variants.sh --set typo signalforge
#   ./variants.sh signalforge | ./rdap.sh --tlds com --available
#
# Options:
#   --set LIST   comma-separated from: plural,article,verb,typo,hyphen,tld-stem,translit,all
#                default: plural,article,verb,typo
#
# Sets:
#   plural    signalforge -> signalforges
#   article   -> thesignalforge, getsignalforge, trysignalforge, joinsignalforge, ...
#   verb      -> signalforgeapp, signalforgehq, signalforgelabs, ...
#   typo      doubled letters, dropped interior letters, transposed pairs, and the
#             few letter swaps that actually produce confusable brands
#   hyphen    signalforge -> signal-forge
#   tld-stem  splits a compound so the domain-hack spelling can be tested separately
#   translit  romanisation variants for a name from a non-Latin script.
#             dokan -> dukan, dokaan, dukaan, dokhan. Run this whenever the name comes
#             from Bangla, Hindi, Urdu, Arabic, Persian, Turkish, Thai, Korean or any
#             language people romanise inconsistently. Your users will type all of these,
#             and so will the squatters.
#
# Output: one candidate per line, deduplicated, ready to pipe into rdap.sh.
#
# The typo set is deliberately conservative. Exhaustive typo generation produces
# hundreds of strings nobody would ever type, and buying them is not a real defence.

set -uo pipefail
SETS="plural,article,verb,typo"
names=()
while [ $# -gt 0 ]; do
  case "$1" in
    --set) SETS="${2:?}"; shift 2 ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) printf 'variants.sh: unknown option: %s\n' "$1" >&2; exit 2 ;;
    *) names+=("$1"); shift ;;
  esac
done
if [ ${#names[@]} -eq 0 ]; then
  while IFS= read -r l; do l=$(printf '%s' "$l" | tr -d ' \t'); [ -n "$l" ] && names+=("$l"); done
fi
[ ${#names[@]} -gt 0 ] || { printf 'variants.sh: no name given\n' >&2; exit 2; }
[ "$SETS" = all ] && SETS="plural,article,verb,typo,hyphen,tld-stem,translit"

has(){ case ",$SETS," in *",$1,"*) return 0 ;; *) return 1 ;; esac; }
out=""
add(){ out="$out$1"$'\n'; }

for raw in "${names[@]}"; do
  n=$(printf '%s' "$raw" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9')
  [ -n "$n" ] || continue
  add "$n"

  if has plural; then
    case "$n" in
      *s) add "${n%s}" ;;
      *y) add "${n%y}ies"; add "${n}s" ;;
      *)  add "${n}s" ;;
    esac
  fi

  if has article; then
    for p in the my get try use join go with; do add "$p$n"; done
    add "hey$n"
  fi

  if has verb; then
    for suf in app hq io labs; do add "$n$suf"; done
  fi

  if has hyphen; then
    for seam in forge stack scope flow lab labs works shop desk kit base craft \
                guide book file deck path port grid mark note wave; do
      case "$n" in *"$seam") add "${n%$seam}-$seam" ;; esac
    done
  fi

  if has tld-stem; then
    for seam in ai io co sh me tv us it up so; do
      case "$n" in *"$seam") add "${n%$seam}.$seam" ;; esac
    done
  fi

  if has translit; then
    # Consonant rules run once each. Vowel rules run twice, because real romanisations
    # differ on two vowels at a time: dokan, dukan, dokaan, dukaan are all the same word.
    # Combining consonant rules as well would produce strings nobody would ever type.
    VOWEL_RULES='s/aa/a/g s/a/aa/g s/ee/i/g s/i/ee/g s/oo/u/g s/u/oo/g s/o/u/g s/u/o/g s/e/a/g s/a/e/g'
    CONS_RULES='s/kh/k/g s/k/kh/g s/gh/g/g s/g/gh/g s/bh/b/g s/dh/d/g s/th/t/g
                s/ph/f/g s/f/ph/g s/sh/s/g s/s/sh/g s/ch/c/g s/c/ch/g s/z/j/g s/j/z/g
                s/v/w/g s/w/v/g s/v/b/g s/q/k/g s/k/q/g s/x/ks/g s/^a// s/a$// s/$/a/'

    pass1="$n"
    for r in $VOWEL_RULES $CONS_RULES; do
      pass1="$pass1 $(printf '%s' "$n" | sed "$r")"
    done
    for w in $pass1; do
      add "$w"
      case " $VOWEL_RULES " in *" "*) ;; esac
      for r in $VOWEL_RULES; do add "$(printf '%s' "$w" | sed "$r")"; done
    done

    # doubled consonants collapse: dokkan -> dokan
    len=${#n}
    for ((i=0;i<len-1;i++)); do
      [ "${n:i:1}" = "${n:i+1:1}" ] && add "${n:0:i}${n:i+1}"
    done
  fi

  if has typo; then
    len=${#n}
    for ((i=0;i<len;i++)); do add "${n:0:i}${n:i:1}${n:i}"; done          # doubled letter
    for ((i=1;i<len-1;i++)); do add "${n:0:i}${n:i+1}"; done              # dropped interior letter
    for ((i=0;i<len-1;i++)); do add "${n:0:i}${n:i+1:1}${n:i:1}${n:i+2}"; done  # transposition
    for sub in 's/ph/f/' 's/f/ph/' 's/c/k/' 's/k/c/' 's/z/s/' 's/s$/z/' 's/ie/ei/' 's/ei/ie/'; do
      add "$(printf '%s' "$n" | sed "$sub")"
    done
  fi
done

# Drop any string with three identical letters in a row. Vowel rules applied twice can
# produce them, and no name anybody types looks like that. sed, not awk: POSIX awk has no
# backreferences, so the same pattern there matches nothing and filters silently fail.
printf '%s' "$out" | sed '/\(.\)\1\1/d' | awk 'NF && !seen[$0]++'
