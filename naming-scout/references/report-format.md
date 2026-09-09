# Report format

The report is the deliverable. Someone should get the answer in ten seconds and be able to
argue with it in five minutes.

**It ships as an HTML page, not as terminal text.** Build the JSON described by
`scripts/report.sh --schema`, render it, and it opens in the browser:

```bash
scripts/report.sh report.json
```

`examples/report-data.example.json` is a complete payload from a real run.

## The one rule: answer first

Lead with the name you would use. Not the brief, not the territories, not the method. The
reader came for a decision, and everything else is evidence they may or may not want.

The page enforces this ordering, so your job is to fill the fields at the right length:

| Order | What the reader sees | Where it comes from |
|---|---|---|
| 1 | **The pick** — one name, large, with the reason, the domain to register, and what would change your mind | `top3[0]` + that candidate |
| 2 | **Two alternates** — name, one line, best domain | `top3[1]`, `top3[2]` |
| 3 | **Boldest and safest** — one line each | `unconventional`, `safest` |
| 4 | **The shortlist** — collapsed rows, one line each, open for the reasoning | `candidates` |
| 5 | **How this was found** — folded away: brief, territories, rounds | `brief`, `territories`, `rounds` |
| 6 | **Before you commit** — what was not verified | `unverified` |

The method section is folded shut on purpose. It is the part you would show someone who
challenges the recommendation, not the part you open with.

## Length discipline

The page is only as clean as the text you put in it. Overlong fields are what made the old
reports unreadable.

| Field | Length | Note |
|---|---|---|
| `subtitle` | one line | The finding of the run, not a description of it. "The .com collapse is the finding: move to .dev, or buy." |
| `top3[].reason` | **one sentence** | This sits under a 58px name. Two sentences and the page stops looking like an answer. |
| `top3[].dealbreaker` | one sentence | Framed as "what would change my mind". |
| `unconventional.reason`, `safest.reason` | **one line** | These are footnotes to the pick, not entries in their own right. |
| `candidates[].why` | one or two sentences | Hidden until the row is opened, so it can carry more, but not a paragraph. |
| `candidates[].weakness` | one or two sentences | Required on every candidate. |
| `candidates[].verdict` | one line | What you would do about it. |
| `territories[].fit` | one or two lines | Why this territory, for this brief. |
| `rounds[].note` | one line | What the hit rate meant, not what you did. |

If a field wants to be longer, it usually means the point is not sharp yet.

## What goes in each field

### The pick and the alternates

`top3` is ranked, and the first entry is the recommendation, not a menu option. Say which
one you would use and why, in a sentence someone could disagree with.

Every entry needs a `dealbreaker`: the one fact that would change the recommendation. A
pick with no stated dealbreaker reads as sales copy.

### Boldest and safest

**Boldest** is the highest ceiling and the highest risk — usually from the territory the
user would not have asked for: an imperative, a phrase, a coined word. Put what it demands
from them in `cost`.

**Safest** is the lowest clearance risk and the least explanation cost. Often not exciting,
which is the point: it answers "I need to ship next week". It may be the same name as the
pick; that is a real finding, not a duplication.

Omit either if the run genuinely produced nothing that fits. Do not promote a middling name
into an empty slot.

### The shortlist

8–15 candidates, ranked, each with `why`, `weakness`, `verdict`, and only the checks that
matter for this project. A newsletter candidate has no `clearance` array.

**Every entry has a stated weakness.** An entry without one has not been examined.

List `domains` best-first — the page surfaces the most actionable one in the collapsed row
(available, then for_sale, then parked, then registered), and shows the rest on open.

### Territories

`checked` and `available` drive a rate bar and the open/normal/mined colour. `note` is the
one-word read: `unmined`, `normal`, `exhausted`. This is the part the user keeps if they
reject the whole shortlist, so make `fit` say why the territory suits this brief
specifically.

### Before you commit

Explicit, never a footnote. Unresolved lookups, the trademark disclaimer, the checks you
skipped and why:

```
"deadreckon.dev returned HTTP 429 after four attempts. That is **unresolved, not available**."
"No trademark search. Correct for a hobby CLI, wrong the moment you charge for it."
"Social handles were not checked — platform status codes are unreliable in both directions."
```

## Tone

Write as an advisor who will be held to it.

- "Registered since 2004 by a live consultancy" beats "unavailable".
- "This needs a tagline to mean anything" beats "highly brandable".
- "I would pick Lodestar and run it on .dev" beats presenting three options equally.

Avoid: clean, modern, sleek, catchy, memorable, powerful, versatile, and any adjective that
would apply equally to a different name. Every claim should be falsifiable.

## In the terminal

Do not restate the report. Say the recommendation, the one thing that would change it, and
give the path:

> **Sounder**, on `sounder.dev`. It types well and reads correctly cold. I would drop it
> only if the PyPI collision matters more than I think — the name is taken there, so a
> Python installer would ship as `sounder-cli`.
>
> Full report: /tmp/postgres-slow-query-profiler-cli-20260908.html

## Length

As long as the number of names you would defend, and no longer. A run that produced six
good names produces a six-name report. Padding to fifteen with material you would cut in
conversation is the fastest way to make the whole thing feel machine-generated.

If you cannot fill a shortlist you believe in, say so and run another round in a different
territory.
