# Naming Scout

Names your company, product, app, newsletter or side project. Then checks whether the name is
actually usable: domain, trademark, GitHub, npm, app stores and search.

An agent skill for Claude Code, Cursor, Codex, OpenCode and 75 other coding agents.

```bash
npx skills add me-shaon/naming-scout
```

Add `-g` to install for every project instead of just this one. Needs `curl` and `jq` for the
live checks.

Then describe what you are building, and it takes over from there.

---

## Why not just use a domain search tool

Because they answer a different question than the one you have.

You want to know what to call your company. A registrar wants to sell you a domain. Those two
goals stop overlapping the moment a good name turns out to be taken.

### They search the space everyone has already searched

Namelix, Namecheap Beast Mode and every "AI name generator" work by permutation. Take your
keyword, bolt on a prefix or a suffix, check the domain, repeat. That is why the output is
always the same shape: `Growthly`, `GrowthAI`, `GrowthAI Labs`, `GetGrowth`, `Growthr`.

Everybody's tool searches that space, so everything in it is gone.

Naming Scout works in **metaphor territories** instead. It reads your positioning, picks four
to eight concept domains that fit it, and generates inside those. A budgeting app for
freelancers gets *storing the harvest* and *steadiness at sea*, not `Budgetly`.

The difference is measurable, and the skill measures it. In one run for a music newsletter:

| Round | Approach | Free on `.com` |
|---|---|---|
| 1 | Industry vocabulary: `merchtable`, `soundcheck`, `backline` | **1 / 20 (5%)** |
| 2 | Phrases: `thedoorsplit`, `whatthegigpays`, `countthegate` | **8 / 17 (47%)** |

Same brief, same afternoon. Nine times the hit rate, because permutation tools cannot produce
a phrase, so nobody had taken them.

### They tell you a name is unavailable when it is for sale

A registrar search box shows one red X. Behind that X sit five completely different
situations, and knowing which one you are looking at is usually the actual decision.

Naming Scout asks the registry directly over RDAP and reports them separately:

```
evenmonths.com     available     register it now, $12
granary.com        for_sale      Efty listing, held since 1994
harborline.com     parked        ParkingCrew since 2000, no listing, no price
safeharbor.com     registered    live business since 1995, not for sale
sounder.co         unknown       .co has no RDAP server. Not resolved. Not free.
```

That last row matters most. **A failed check is never reported as an available domain.**

### They let the domain pick your name

Every generator ranks by what is free. That gets the priority backwards. A mediocre name with
a free `.com` is worth less than a strong name whose `.com` costs $2,000.

Naming Scout ranks on the name and shows the domain as a cost line. Availability is used as a
*map*, telling you which directions are mined out and which have room. In one run a territory
with 25% availability was abandoned for one with 14%, because the second one produced better
names.

### They check the domain and stop

The domain is the cheapest and least consequential thing about a name. It is also the only
thing most tools look at.

| | Registrars | AI generators | Naming Scout |
|---|---|---|---|
| Domain availability | Yes | Yes | Yes, registry-level |
| Parked vs for sale vs registered | No | No | Yes |
| GitHub, npm, PyPI, crates, RubyGems | No | No | Yes |
| Trademark | No | No | Guided, never claimed as clearance |
| App stores, social handles | No | No | Guided, flagged as unreliable |
| Can you rank for your own name | No | No | Graded per candidate |
| Non-English names and transliteration | No | No | Yes |

### They will confidently make things up

This is the failure the skill was built around.

A well-known model was asked to name a project and returned 12 candidates, cleared with:

> *"I could not find an indexed website for these, which is promising."*

Live registry check: **all 12 were registered.** Several since 2004. The one name it warned
against was the only one actually free.

No indexed website means parked or private, and parked is what a squatter's inventory looks
like. For a short brandable domain the heuristic runs backwards. Naming Scout will not make
that claim, because it asks the registry instead of guessing.

---

## What else it does that nothing else does

**Grades how hard it will be to find you.** Every candidate gets `ownable`, `contested` or
`crowded`. `Granary` is a lovely word, and you would compete with actual granaries for your
own name forever. That costs more than an expensive domain and no other tool mentions it.

**Names in your language.** A Bangladeshi founder wanting `dokan` instead of `shop` gets the
whole romanisation sweep, because `dokan`, `dukan` and `dukaan` are one word to a customer and
three strings to a registry. All three are already registered. Founders assume otherwise.

**Handles respelling honestly.** Want `statik` because `static` is taken? It checks who owns
the spelling your users will actually type, and reports that `statikapi.com` went to someone
else in October 2025. Usually the better answer is to keep the spelling and change the TLD.

**Tells you what it could not verify.** Rate-limited lookups, TLDs with no RDAP server,
trademark searches that are not clearance opinions. Every report ends with the list.

---

## What you get

A self-contained HTML page opens in your browser, ordered answer first.

The pick, with the reason and the domain to register. Two alternates. Boldest and safest. Then
a shortlist of 8 to 15 names as single-line rows you can open for the full reasoning. The
method is folded away at the bottom, where it belongs.

Every candidate carries a stated weakness. A name presented without one has not been examined.

---

## Documentation

Full guide: **[`naming-scout/README.md`](naming-scout/README.md)**

Eight worked runs with live data: **[`naming-scout/examples/`](naming-scout/examples/)**

| Example | |
|---|---|
| [Startup](naming-scout/examples/saas-startup.md) | The common case. A founder naming a product |
| [Local language](naming-scout/examples/local-language.md) | Naming in Bangla for a Dhaka market |
| [Respelling](naming-scout/examples/respelling.md) | `statik` instead of `static`, and why not |
| [Consumer brand](naming-scout/examples/consumer-product.md) | Where trademark is the real risk |
| [Aftermarket](naming-scout/examples/aftermarket.md) | A funded team willing to buy |
| [Newsletter](naming-scout/examples/newsletter.md) | Domain, social and search only |
| [Wrong direction](naming-scout/examples/weak-first-direction.md) | The first idea fails and the run restarts |
| [Developer tool](naming-scout/examples/developer-tool.md) | Where npm and PyPI decide it |

---

## Limits

It cannot price an aftermarket domain, because RDAP has no price field. It cannot verify
every TLD, `.co` and most South Asian ccTLDs included. It does not check social handles,
because platform status codes are wrong often enough to be useless. Its trademark work is a
signal, never a clearance opinion.

Before you spend money on a brand, get a trademark search from an attorney in every market you
will sell in. Rebranding after a cease-and-desist costs more than every other step combined.
