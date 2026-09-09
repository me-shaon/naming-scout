# Report format

The report is the deliverable. A reader should get the answer in ten seconds and be able to
argue with it in five minutes.

**It ships as an HTML page, not as terminal text.** Build the JSON described by
`scripts/report.sh --schema`, render it, and it opens in the browser:

```bash
scripts/report.sh report.json
```

`examples/report-data.example.json` is a complete payload from a real run.

## The one rule: answer first

Lead with the name you would use. Not the brief. Not the territories. Not the method. The
reader came for a decision. Everything else is evidence they may or may not want.

The page enforces the order. Your job is to fill the fields at the right length.

| Order | What the reader sees | Where it comes from |
|---|---|---|
| 1 | **The pick.** One name, large, with the reason, the domain to register, and what would change your mind | `top3[0]` plus that candidate |
| 2 | **Two alternates.** Name, one line, best domain | `top3[1]`, `top3[2]` |
| 3 | **Boldest and safest.** One line each | `unconventional`, `safest` |
| 4 | **The shortlist.** Collapsed rows, one line each, open for the reasoning | `candidates` |
| 5 | **How these were found.** Folded shut: brief, territories, rounds | `brief`, `territories`, `rounds` |
| 6 | **Check these yourself.** What was not verified | `unverified` |

The method section is folded shut on purpose. It is what you show someone who challenges
the recommendation. It is not what you open with.

## Length discipline

The page is only as clean as the text you put in it. Overlong fields are what made earlier
versions unreadable.

| Field | Length | Note |
|---|---|---|
| `subtitle` | One line | The finding of the run, not a description of it. |
| `top3[].reason` | **One sentence** | It sits under a 58px name. Two sentences and the page stops reading as an answer. |
| `top3[].dealbreaker` | One sentence | The page labels it "Would change my mind". |
| `unconventional.reason`, `safest.reason` | **One line** | Footnotes to the pick, not entries of their own. |
| `candidates[].why` | One to three short sentences | Hidden until the row opens, so it can carry more. Never a paragraph. |
| `candidates[].weakness` | One or two sentences | Required on every candidate. |
| `candidates[].verdict` | One line | What you would do about it. |
| `territories[].fit` | One or two lines | Why this territory suits this brief. |
| `rounds[].note` | One line | What the rate told you, not what you did. |

A field that wants to be longer usually means the point is not sharp yet.

## How to write the copy

Reports get read once, quickly, by someone about to decide something. Write for that reader.

**Short sentences. One idea each.** Split a long sentence rather than joining it with a
comma.

Do not write:

> The leadsman is the crew member who drops the weighted line and calls the depth, which is
> precisely this tool's role, and it spells itself, so there is no phone-test problem.

Write:

> The leadsman drops the weighted line and calls out the depth. He is not the navigator. He
> reports what is under you. That is this tool's job.

**Banned. These are the marks of generated text.**

| Pattern | Use instead |
|---|---|
| Em dashes | A full stop, a colon, or brackets. Rewrite the sentence if none fit. |
| `X, and Y` joining two full clauses | Two sentences. |
| Three items for rhythm: "clean, modern and memorable" | The one thing that is true. |
| "which is exactly what...", "so that it becomes..." | Say it directly. |
| "It is not just X, it is Y" | Say what it is. |
| Filler words: robust, seamless, comprehensive, powerful, leverage, delve | Cut the word. |
| A closing sentence restating the paragraph | Delete it. |

**Say the thing. Do not gesture at it.** "PyPI already holds the name" beats "there may be
namespace considerations on the Python side".

**Name the cost.** "You lose the clean binary name" beats "there are tradeoffs".

**Adjectives must be falsifiable.** If a word would fit a different name equally well, cut
it. Clean, modern, sleek, catchy, memorable, powerful and versatile all fail that test.

## What goes in each field

### The pick and the alternates

`top3` is ranked. The first entry is your recommendation, not a menu option. Say which one
you would use. Give a reason someone could disagree with.

Every entry needs a `dealbreaker`. That is the one fact that would change the
recommendation. A pick without one reads as sales copy.

### Boldest and safest

**Boldest** has the highest ceiling and the highest risk. It usually comes from the
territory the user would not have asked for: an imperative, a phrase, a coined word. Put
what it demands from them in `cost`.

**Safest** has the lowest clearance risk and the smallest explanation cost. It is often the
dull choice. That is the point. It answers "I need to ship next week". It may be the same
name as the pick. That is a real finding, not a duplication.

Omit either one if the run produced nothing that fits. Never promote a middling name into
an empty slot.

### The shortlist

Eight to fifteen candidates, ranked. Each gets `why`, `weakness`, `verdict`, and only the
checks that matter for this project. A newsletter candidate has no `clearance` array.

**Every entry needs a stated weakness.** An entry without one has not been examined.

List `domains` best first. The page shows the most actionable one in the collapsed row,
preferring available, then for_sale, then parked, then registered. The rest appear when the
row opens.

### Territories

`checked` and `available` drive the rate bar and its colour. `note` is the one-word read:
`open`, `normal`, `exhausted`. This section is what the user keeps if they reject the whole
shortlist, so `fit` must say why the territory suits this brief in particular.

### Check these yourself

Explicit, never a footnote. List unresolved lookups, the trademark disclaimer, and the
checks you skipped.

```
"deadreckon.dev returned HTTP 429 after four attempts. That is **unresolved. It is not available.**"
"No trademark search was run. That is fine for a hobby CLI. It stops being fine the day you charge for it."
"Social handles were not checked. Platform status codes are wrong in both directions often enough to be useless."
```

## Tone

Write as an advisor who will be held to it.

- "Registered since 2004 by a live consultancy" beats "unavailable".
- "This needs a tagline to mean anything" beats "highly brandable".
- "I would pick Lodestar and run it on .dev" beats presenting three options equally.

## In the terminal

Do not restate the report. Give the recommendation, the one thing that would change it, and
the path.

> **Sounder**, on `sounder.dev`. It types well and reads correctly cold. PyPI already holds
> the name, so a Python installer would ship as `sounder-cli`. That is the only thing that
> would change my mind.
>
> Full report: /tmp/postgres-slow-query-profiler-cli-20260908.html

## Length

As long as the number of names you would defend. No longer. A run that produced six good
names produces a six-name report. Padding to fifteen with material you would cut in
conversation is the fastest way to make the whole thing feel machine-generated.

If you cannot fill a shortlist you believe in, say so. Run another round in a different
territory.
