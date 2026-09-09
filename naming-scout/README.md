# Naming Scout

Names your company, product, app, newsletter or side project. Then checks whether the name is
actually usable: domain, trademark, GitHub, npm, app stores and search.

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

**It grades how hard the name is to find you by.** Every candidate gets `ownable`, `contested`
or `crowded`, because a name you cannot rank for costs more than an expensive domain.
`Granary` is a lovely word and you would be competing with actual granaries forever. It also
corrects the myth that a keyword domain ranks better, which stopped being true in 2012.

**It names in your language, not only in English.** A Bangladeshi founder wanting `dokan`
instead of `shop` gets the whole romanisation space swept, because `dokan`, `dukan` and
`dukaan` are one word to a customer and three strings to a registry. Every one of those is
already registered, which is the sort of thing founders assume is not true.

**It handles respelling honestly.** If you want `statik` because `static` is taken, it checks
who holds the spelling your users will actually type, and it tells you that `statikapi.com`
went to somebody else in October 2025. Usually the better answer is to keep the spelling and
change the TLD.

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

```bash
npx skills add me-shaon/naming-scout
```

That works with Claude Code, Cursor, Codex, OpenCode and 75 other agents. Add `-g` to install
for every project rather than just the current one.

From a clone instead:

```bash
cp -r naming-scout ~/.claude/skills/
```

Requirements: `curl` and `jq`. Optional but recommended: `export GITHUB_TOKEN=…` to raise
the GitHub check from 60 requests an hour to 5,000.

## Quick start

Describe what you are building. That is the whole input.

> I'm building a budgeting app for freelancers. The problem is irregular income. You make
> £9k one month and £900 the next, so normal budgeting apps are useless. We smooth it out
> and tell you what you can safely pay yourself each month. Need a name.

It asks two or three questions, proposes the checks that matter for a consumer app, and
comes back with territories and a ranked shortlist.

Here is what that run actually produced. Full transcript in
[`examples/saas-startup.md`](examples/saas-startup.md).

> **Even Months**
> It states the outcome in two words. Irregular income made even. A freelancer understands
> it before you finish the sentence, with no tagline and no explanation.
>
> `evenmonths.com` free · `.app` free
>
> **Would change my mind:** it is descriptive rather than distinctive, so it will be harder
> to own in trademark than a coined word.

Two candidates were cut in that run for something a domain check would never surface.
**Harvest Month** collides with Harvest, the time-tracking product used by the same
freelancers. **Buffer Month** collides with Buffer, which sells to the same audience.
Different category, same customer. That is where trademark disputes actually happen.

The scripts also run on their own:

```bash
# domain status, registry-level, across any TLDs you like
printf '%s\n' evenmonths granary thelayby | scripts/rdap.sh --tlds com,app,io

# defensive variants for a finalist, piped into the domain check
scripts/variants.sh evenmonths | scripts/rdap.sh --tlds com --available

# package and org namespaces, only if you are shipping code
scripts/clearance.sh --checks github,npm,pypi yourname

# render a report and open it in the browser
scripts/report.sh report.json
```

## What you should tell it

The more of this you give up front, the fewer questions it asks:

- **What** you are naming: company, SaaS, app, CLI, library, newsletter, community,
  agency, course, content brand
- **What it does**, mechanism first. "Smooths out irregular freelance income and tells you
  what you can safely pay yourself", not "AI-powered financial wellness platform"
- **Who** it is for, and who says the name out loud
- **What it is instead of.** The wedge, not the category
- **Tone**, including the tone that would be wrong
- **Constraints.** Length, spelling, languages, words to avoid
- **Domain appetite.** Must it be `.com`? Would you buy one that is already taken?
- **What it will ship as.** This decides which namespaces get checked
- **Your market and language.** If it is not English-speaking, say so. A name in your own
  language is often the strongest option and it needs a different check list

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
| Search presence | Collision check, plus an `ownable`/`contested`/`crowded` grade | Medium |
| App stores | Manual store search | Medium |
| Social handles | Reported as probable, never verified | Low, deliberately |

Social handles are not automated on purpose. Bot detection makes a 200 untrustworthy, and
a confident-looking column of wrong answers is worse than no column.

## Good for

Startups and companies · SaaS and B2B products · consumer and mobile apps · agencies and
consultancies · newsletters, podcasts and content brands · communities · courses and
conferences · physical product brands · developer tools and open-source libraries · side
projects.

**You are told which checks apply and the rest are skipped.** A consumer app gets domain,
trademark, app stores, social and search. A newsletter gets domain, social and search. Only
a project that ships code gets GitHub, npm and PyPI. You never have to know what a package
registry is.

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
Granary                                          Storing the harvest
Why:      A granary is where you keep the surplus so the lean months do not hurt.
          One word, warm, concrete, and it draws a picture. It sounds like an
          established company rather than a 2026 app.
Weakness: The link to freelance income needs one line of explanation the first
          time. The domain is a purchase, not a registration.
.com for sale on Efty, held since 1994 · price not visible from RDAP
```

You can also render a report by hand from a JSON file:

```bash
scripts/report.sh --schema                 # the shape it expects, every field optional
scripts/report.sh examples/report-data.example.json
```

Eight full worked runs are in [`examples/`](examples/):

| Run | What it shows |
|---|---|
| [`saas-startup.md`](examples/saas-startup.md) | The common case. A founder naming a product. No developer checks. |
| [`local-language.md`](examples/local-language.md) | Naming in Bangla for a Bangladeshi market. Transliteration sweeps, an unverifiable local TLD, searchability deciding the ranking |
| [`consumer-product.md`](examples/consumer-product.md) | A physical brand where trademark is the dominant risk, and an honest report when a territory does not recover |
| [`aftermarket.md`](examples/aftermarket.md) | A funded B2B company willing to buy the domain, with all five states side by side |
| [`newsletter.md`](examples/newsletter.md) | Domain, social and search only. Availability jumping from 5% to 47% on a change of territory |
| [`weak-first-direction.md`](examples/weak-first-direction.md) | The first direction is wrong and the run has to start over |
| [`respelling.md`](examples/respelling.md) | The founder wants `statik` instead of `static`. Why that fails and what to do instead |
| [`developer-tool.md`](examples/developer-tool.md) | A CLI, where GitHub, npm and PyPI decide the answer |

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
