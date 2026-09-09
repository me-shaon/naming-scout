# Naming Scout

A Claude Agent Skill that finds names worth using, then tells you the truth about whether
you can use them.

## The problem

Naming something means doing two jobs badly at once.

The first is coming up with names. AI name generators give you two hundred of them, and
they are all the same name: your keyword plus `-ly`, plus `AI`, plus `Labs`, plus `HQ`. The
generator searched the space every generator has already searched, which is why the output
feels interchangeable.

The second is finding out whether a name is usable. That means checking the same six things
on six different sites, by hand, for every candidate: is the `.com` free or is it free-looking
and held at $5,000; are the handles gone; is there a live trademark in a colliding class; is
the GitHub org or npm package claimed; is there an app in the stores; is someone already
ranking for the term.

Most tools do a version of the first job. Almost none do the second. And the tools that do
both let the domain result decide which names you see, which is backwards: a mediocre name
with a free `.com` is worth less than a strong name whose `.com` costs $2,000.

## What makes it different

**It interviews you first.** Not keywords. What the thing does, who says the name out loud,
what it is instead of, what tone would be wrong. A name generated from positioning is a
different object from one generated from a search term.

**It generates inside metaphor territories, not by permutation.** A territory is a coherent
concept domain picked for your brief. Depth sounding. Courtroom vocabulary. The arithmetic
of a gig. Names from one territory sound like each other and unlike everything else, because
they came from an idea instead of a string operation. The territories are half the value.
They are how you keep thinking about the space once the run is over.

**It uses availability as a map, not as a filter.** Availability rate per territory tells
you which directions are mined out and which still have room. In one of the worked examples,
a territory with 25% availability was abandoned for one with 14%, because the second one
produced better names. That decision is the whole method in one line.

**It never guesses about availability.** Domain status comes from RDAP, the registry's own
protocol. Not from a registrar's search box. Not from whether a website loads. It
reports `available`, `registered`, `parked`, `for_sale`, `reserved` and `unknown` as
separate answers, because they are separate answers.

**It says what it could not verify.** A rate-limited lookup is reported as unknown, not as
available. A trademark search is reported as "no obvious conflict in what I searched", never
as clearance.

**The result opens in your browser.** Not a wall of terminal text. A page you can filter,
search, print, and send to a co-founder.

## The thing this exists to prevent

A well-known model was asked to name a project and produced 12 candidates with the
availability note: *"I could not find an indexed website for these, which is promising."*

Live registry check: **all 12 were registered.** Several since 2004. The one name it
advised against was the only one actually free.

"No indexed website" means parked or private. Parked is what squatter-held inventory looks
like. For a short brandable domain the heuristic runs backwards: no indexed site
makes it *more* likely the name is expensively held. Naming Scout will not make that claim,
because it asks the registry instead of guessing.

## Install

The skill is one directory. Copy it wherever your Claude reads skills from:

```bash
# Claude Code, personal skills
cp -r naming-scout ~/.claude/skills/

# or per-project
cp -r naming-scout .claude/skills/
```

Requirements: `curl` and `jq`. Optional but recommended: `export GITHUB_TOKEN=…` to raise
the GitHub check from 60 requests an hour to 5,000.

## Quick start

Just describe what you are naming:

> Name a CLI that reads your Postgres slow-query log and tells you which index is missing.
> Backend engineers. Should feel like precision tooling, not a startup.

It will ask two or three questions, propose a set of checks, and come back with territories
and a ranked shortlist.

The scripts also work on their own:

```bash
# domain status, registry-level, across several TLDs
printf '%s\n' leadsman sounder bythemark | scripts/rdap.sh --tlds com,dev,sh

# package and org namespaces
scripts/clearance.sh --checks github,npm,pypi leadsman sounder

# defensive variants for a finalist, piped straight into the domain check
scripts/variants.sh sounder | scripts/rdap.sh --tlds com --available

# render a report and open it in the browser
scripts/report.sh report.json
```

## What you should tell it

The more of this you give up front, the fewer questions it asks:

- **What** you are naming: company, SaaS, app, CLI, library, newsletter, community,
  agency, course, content brand
- **What it does**, mechanism first. "Watches your slow-query log and finds the missing
  index", not "AI-powered database optimisation platform"
- **Who** it is for, and who says the name out loud
- **What it is instead of.** The wedge, not the category
- **Tone**, including the tone that would be wrong
- **Constraints.** Length, spelling, languages, words to avoid
- **Domain appetite.** Must it be `.com`? Would you buy one that is already taken?
- **What it will ship as.** This decides which namespaces get checked

## What it checks

Automated, from an authoritative API:

| Check | Source | Confidence |
|---|---|---|
| Domain status | RDAP, per-TLD registry via the IANA bootstrap | High |
| GitHub org/user | GitHub API | High |
| npm, PyPI, crates.io, RubyGems | Each registry's own API | High |
| Docker Hub namespace | Docker Hub API | High |

Assisted, reported at the confidence the method supports:

| Check | How | Confidence |
|---|---|---|
| Trademark | Public register search, live marks, relevant classes | Low. Never a clearance opinion |
| Search presence | Search for an existing brand on the term | Medium |
| App stores | Manual store search | Medium |
| Social handles | Reported as probable, never verified | Low, deliberately |

Social handles are not automated on purpose. Bot detection makes a 200 untrustworthy, and
a confident-looking column of wrong answers is worse than no column.

## Good for

Companies · SaaS and B2B products · mobile and consumer apps · CLIs and developer tools ·
open-source libraries · newsletters · podcasts · media and content brands · communities ·
agencies · courses · conferences · side projects.

Also good for a name you already have: it will run the brand filter on it, tell you the
specific weakness you had not noticed, run the clearance, and offer alternatives inside the
territory your name already belongs to.

## What a result looks like

When the run finishes, a self-contained HTML page opens in your default browser. It is
ordered the way you actually read: **the answer first, the evidence underneath.**

- **The pick.** One name, large, with the reason, the domain to register, and the one
  thing that would change the recommendation
- **Two alternates**, a line each. Then **boldest** and **safest**, a line each
- **The shortlist.** 8 to 15 names as quiet single-line rows. Open one to see why it works,
  its named weakness, and every check that was run
- **How these were found.** The brief, the territories with their availability rates, and
  the round log. Folded shut, because this is what you open when you want to argue with the
  recommendation
- **Check these yourself.** What could not be verified

Every state gets its own mark, so `unknown` can never be mistaken for `available`. Filter
to available-only or available-plus-purchasable, search, toggle light and dark, print.

Each shortlist entry reads roughly like:

```
Leadsman                                            Depth sounding
Why:      The leadsman drops the weighted line and calls out the depth. He is not
          the navigator. He reports what is under you. That is this tool's job.
Weakness: You have to know the word for the name to mean anything. Anyone who does
          not will hear "lead" as a sales lead.
.dev free · .sh free · .com registered 1999 · npm free · PyPI free · GitHub taken
```

You can also render a report by hand from a JSON file:

```bash
scripts/report.sh --schema                 # the shape it expects, every field optional
scripts/report.sh examples/report-data.example.json
```

Five full worked runs are in [`examples/`](examples/), including one where the first
direction fails and the run has to change territory.

## Limitations

- **RDAP coverage is not universal.** Some TLDs, including `.co`, have no RDAP server this
  skill can verify. Those return `unknown_no_rdap`, which means the lookup did not resolve.
  It never means the domain is free. Confirm those at a registrar.
- **No prices.** RDAP has no price field. `for_sale` means a listing exists, not that it is
  affordable, and `available` on a new gTLD can still mean registry premium pricing.
- **Registries rate-limit.** Lookups that get throttled are reported as `unknown_error` and
  need re-running. They are never counted as available.
- **Parking detection is a nameserver heuristic.** It catches the common hosts and
  marketplaces. A name parked on custom nameservers will read as plain `registered`.
- **Social handles are not verified**, by design.
- **Trademark search here is a signal, not clearance.** See below.
- **It cannot tell you whether you will like a name in a year.** It can tell you why a name
  works, what it costs, and what it will be confused with.

## Before you commit commercially

Domain availability is the cheapest and least consequential of the checks. Before you spend
money on a brand:

1. **Get a trademark clearance search from an attorney** in every market you will operate
   in. A search here covers exact and near-exact strings in public registers. So does a
   search from any other AI tool. It does not cover common-law rights, unpublished
   applications, foreign marks, or similar marks nobody thought to search. Clearance is a
   legal opinion. This is not one.
2. **Register the trademark**, in the right classes, before you announce.
3. **Check the business registry** in your home jurisdiction for an existing entity.
4. **Reserve the handles yourself**, on the signup pages, in one sitting.
5. **Say it out loud on a phone call**, to someone who has not seen it written down.
6. **Buy the obvious misspelling.** One extra domain is cheaper than the traffic you lose.

Rebranding after a cease-and-desist costs more than every step above combined.

## Credits

The method comes from a naming run of roughly 400 candidate domains across six rounds.
The availability-rate-as-signal technique, the concept-clustering approach, and the
"no indexed website" cross-check all come from that work.
