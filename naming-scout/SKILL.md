---
name: naming-scout
description: Find and validate names for a company, product, SaaS, app, CLI, library, newsletter, community, agency, course, or content brand. Runs a positioning interview, generates candidates inside metaphor territories rather than by permutation, filters them for brand quality, then checks the namespaces that actually matter using registry-level RDAP and package registry APIs. Use when the user asks for name ideas, a brand name, a product or project name, a domain name, help renaming something, or wants to know whether a name they already have is available or clear to use.
---

# Naming Scout

Two problems, kept separate:

1. **Finding good names.** A positioning interview, then concept clustering into metaphor territories.
2. **Deciding whether a name is usable.** Registry-level checks, with honest confidence labels.

Never let step 2 drive step 1. A mediocre name with a free `.com` is worth less than a
strong name whose `.com` costs $2,000. Availability is a constraint to be priced, not a
naming criterion.

**The bar for every name you present: would a founder actually consider using this?**

## Workflow

### 1. Interview before generating

Do not generate names from a one-line request. Ask, in **one batched message**, only what
you cannot already infer from what the user said. Full question set and the reasoning
behind it: `references/discovery.md`.

The six things you must know before generating:

| | | |
|---|---|---|
| **What** | the thing being named | company, SaaS, app, CLI, library, newsletter, community, agency, course, content brand |
| **Does** | what it does, in a sentence | the mechanism, not the marketing |
| **Who** | audience | who says the name out loud, and to whom |
| **Position** | category and the wedge inside it | what it is instead of, and why |
| **Personality** | tone | serious, technical, premium, playful, irreverent, scientific, minimal, quirky |
| **Constraints** | hard limits | length, spelling, languages, words to avoid, style preference |

Then two decisions that change the whole back half of the run:

- **Domain mode** (A–E, `references/domain-states.md`). Ask plainly: does it have to be
  `.com`? Are you willing to buy from the aftermarket? Should parked domains be shown?
- **Clearance profile** (`references/clearance-guide.md`). If the user does not know,
  propose one from what they are naming and say in one line why those checks and not others.

If the user already answered something, do not ask it again. If the brief is rich enough
already, skip straight to a one-line confirmation of your reading and generate.

**If the user arrives with a name already** — "is X available", "what do you think of X",
"can we use X" — that is the most common entry point and it has its own path. Run the brand
filter on their name and tell them the specific weakness they had not noticed. Run the
clearance. If the exact domain is gone, check the `get-`/`try-`/`the-` route before
concluding it is unusable. Then offer alternatives inside the territory their name already
belongs to, because they chose that territory for a reason. Do not skip the brand-filter
step: the most useful thing you can say about a name someone is attached to is a concrete
flaw, delivered before they find out the domain costs $8,000.

### 2. Extract concepts, then build territories

From the brief pull: the mechanism, the outcome, the felt emotion, the enemy or tension,
the imagery, the category conventions, and what the user is deliberately not.

Group those into **4–8 naming territories**. A territory is a coherent metaphor domain
with an internal logic, not a word list. Adapt them to the brief; do not import a fixed
taxonomy that does not fit. Territory catalogue and worked examples:
`references/territories.md`.

State the territories to the user before or alongside the first batch. The territories
are half the value: they are how the user reasons about the space after you leave.

### 3. Generate in rounds, not in one dump

| Round | Purpose | Scale |
|---|---|---|
| 1 | Spread across every territory | 6–10 per territory |
| 2 | Check the strongest, read the hit rate per territory | the survivors |
| 3 | Go deep in the territories that are both good and unmined | more per territory |
| 4 | Refine surviving stems: compounds, alternate seams, tighter forms | targeted |
| 5 | Defensive variants, **finalists only** | 2–3 names |

**Availability rate per territory is a signal about where to keep digging.** A territory
returning 5% available is mined out by everyone who used the same obvious words. A
territory returning 45% is unexplored space. Report the rates; they are genuinely useful
to the user and they cost nothing extra.

Availability tells you where to dig. It never tells you what is good.

### 4. Filter for brand quality before checking anything

Run every candidate through `references/brand-filter.md` before it earns a lookup.
Checking bad names wastes calls and pads the report.

Fast version: say it aloud; spell it down a phone line; picture it in a URL bar and as a
logo; ask whether it still fits when the product doubles in scope; ask whether it collides
with something in the same category; ask what one sentence explains it.

**A candidate with no one-sentence reason to exist is cut, however available it is.**

### 5. Check what matters, and only that

Paths below are relative to this skill's own directory. Run them from there, or prefix with
the absolute path to it.

```bash
# domains: registry-level, distinguishes available / registered / parked / for_sale / unknown
# output is ordered by buyability: available, for_sale, parked, registered, unknown
printf '%s\n' name1 name2 name3 | scripts/rdap.sh --tlds com,io --quiet

# domain mode A (strict) and mode D (aftermarket welcome)
… | scripts/rdap.sh --tlds com --available
… | scripts/rdap.sh --tlds com --states available,for_sale,parked

# namespaces: only the ecosystems in the chosen clearance profile
scripts/clearance.sh --checks github,npm,pypi name1 name2

# defensive sweep, finalists only
scripts/variants.sh finalist | scripts/rdap.sh --tlds com --available

# second use: a name you want whose exact domain is gone. --set article finds the
# get-/try-/the- route before you conclude the name is unusable.
scripts/variants.sh --set article,plural wantedname | scripts/rdap.sh --tlds com --available
```

Pass a whole round in one invocation. The scripts parallelise, back off on 429, and cache
results (registered 30 days, available 1 hour), so one call for 30 names is far cheaper and
kinder to the registries than 30 calls. Add `--no-cache` only when a stale `available` would
be costly. `export GITHUB_TOKEN=…` before a run with many GitHub checks.

**When the tools are unavailable** — no network, no `jq`, sandboxed shell — do the naming
work anyway and say plainly that nothing was verified. Territories, candidates, the brand
filter and the ranking are all still worth delivering. What you must not do is fall back to
guessing availability from memory or from search results; that is the exact failure this
skill exists to prevent. Mark every candidate `unchecked` and tell the user which commands
to run.

Checks with no reliable API — trademark, social handles, app stores, search presence — are
done by search, and reported with the confidence the method actually supports. Read
`references/clearance-guide.md` before doing any of them; it says what each check can and
cannot establish.

Non-negotiable reporting rules:

- **`unknown` is never `available`.** Rate limits, missing RDAP servers and timeouts are
  unknowns. Say so.
- **Absence of a website is not availability.** In the source research, 12 of 12 names
  cleared by "no indexed website" were registered. An unindexed short brandable is more
  likely expensively held than free.
- **Parked is registered.** Label it `parked`, never "available".
- **Never state trademark clearance.** "No obvious conflict in this search" is the
  strongest claim available to you, and it is not legal advice.

### 6. Report — always as an HTML page in the browser

Structure in `references/report-format.md`. Shape:

brief you worked from → territories found, with hit rates → ranked shortlist of **8–15**,
each with territory, why it works, its specific weakness, domain state, requested
clearance → top 3 → best unconventional option → safest option → what you could not verify.

Deliver it as a page, not as a wall of terminal text. Write the report to JSON, render it,
and it opens in the default browser:

```bash
scripts/report.sh --schema          # the JSON shape, every field optional
scripts/report.sh report.json       # renders a self-contained page and opens it
scripts/report.sh report.json -o ~/naming-report.html --no-open
```

Write the JSON to the scratchpad or a temp path, not into the user's project, unless they
asked for a file. `examples/report-data.example.json` is a complete worked payload.

The page colour-codes every domain and clearance state, so `unknown` can never be mistaken
for `available`; it filters to available-only or available-plus-purchasable, searches the
shortlist, and prints cleanly. Sections you leave out are omitted rather than shown empty,
so a partial run still renders.

Then say the three or four sentences that matter in the terminal — your actual
recommendation and the one thing that would change it — and give the file path. Do not
restate the whole report as text; that is what the page is for.

Rank by naming quality, positioning fit, distinctiveness, usability, clearance risk,
then domain state. Reorder only when the user set a hard constraint ("must be an
available .com" makes availability a filter, not a tiebreaker).

**A good result beats a long result.** Fifteen names you would defend beat forty you would not.

### 7. Self-review before sending

Answer these honestly. Any "no" means another round, not a softer adjective.

- Are the top names genuinely different from each other, or three shades of one idea?
- Did any territory get explored only because it was easy?
- Would I stake my judgment on the top 3 in front of a founder?
- Is every domain state I printed one the tools actually returned?
- Did I run checks the user does not need?
- Does each "why it works" say something that could not be said about a different name?
- Is there a weakness listed for every candidate? A candidate with no stated weakness has
  not been examined.

## Failure modes

Do not:

- open with `<concept>ly`, `<concept>AI`, `<concept>Labs`, `<concept>HQ`, `Get<concept>`,
  or a dropped vowel. These are the output of a permutation tool, and the space is exhausted.
- present forty names. Present the ones you would defend.
- ship six variants of one weak idea as if they were six ideas.
- call a parked domain available, or an unknown a negative.
- run npm and PyPI checks for a newsletter, or skip PyPI for a Python library.
- assume `.com` matters before asking, or assume shorter is better.
- describe a name as "clean, modern, memorable". Say what it does that another name does not.
- recommend a name that reads well and sounds wrong. Say it out loud first.

## Reference material

| File | Read it when |
|---|---|
| `references/discovery.md` | building the interview, or judging what to skip |
| `references/territories.md` | building territories, or a territory is running dry |
| `references/brand-filter.md` | scoring candidates before they earn a lookup |
| `references/domain-states.md` | interpreting a state, or picking the domain mode |
| `references/clearance-guide.md` | choosing a profile, or running trademark/social/app-store/search |
| `references/report-format.md` | writing the final report |
| `examples/report-data.example.json` | the report JSON, filled in from a real run |
| `examples/` | five worked runs, including one where the first direction fails |
