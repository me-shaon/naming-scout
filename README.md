# Naming Scout

**Finds a name for your startup, product or side project. Then checks whether you can
actually use it.**

**Naming Scout is an agent skill.** It builds names from what your product actually does,
instead of adding letters to your keyword. Then it checks each name against the domain
registry, the package registries and more.

```bash
npx skills add me-shaon/naming-scout
```

Claude Code, Cursor, Codex, OpenCode and 75 other agents. Add `-g` for every project. Needs
`curl` and `jq`.

---

## An example

You are naming an app for freelancers. Their income is £9,000 one month and £900 the next.
The app works out how much they can safely pay themselves, so every month feels the same.

**A name generator gives you this:**

| Name | What it means | `.com` |
|---|---|---|
| `Budgetly` | "budget" + "ly" | taken since 2011 |
| `Budgetify` | "budget" + "ify" | taken since 2014 |
| `GetBudget` | "budget" + "get" | taken since 2003 |

Three versions of one word. None of them says anything about the product, and all three were
taken years ago. Every generator searches this same small space, so it is empty.

**Naming Scout starts from what the app does.** It softens the bad months. A cushion is the
soft thing that stops you getting hurt when you fall. So:

> ## Cash Cushion
> Money that softens the fall in a bad month.

You understand it without being told. That is the difference.

Then it tells you where each name stands:

- `cashcushion.com` is **for sale**. It is listed on Afternic and has been held since 2003.
- `evenmonths.com` is **free** today, from the same run.

It cannot tell you what the seller wants, because no registry publishes prices. It tells you
a price exists and sends you to the listing.

Cash Cushion is the better name. Even Months is the cheaper one. Naming Scout shows you both
and says which it would pick and why, instead of dropping the good name just because the
domain costs money.

---

## What it checks

Automatic, from an official source:

| Check | Answer you get |
|---|---|
| Domain | Free, registered, parked, for sale, reserved, or **not resolved** |
| GitHub | Is the username or org taken |
| npm, PyPI, crates.io, RubyGems, Docker Hub | Is the package name taken |

Guided, where it helps you look and grades what it finds:

| Check | Why it is not automatic |
|---|---|
| Trademark | Public registers need judgement. This is never a legal opinion. |
| Search | Whether you could ever rank first for your own name |
| App stores | Both stores need a manual search |
| Social handles | Status codes are wrong so often they are useless |

---

## Why not just use a domain search tool

**A registrar shows one red X for five different situations.** Naming Scout asks the registry
directly and keeps them apart:

```
evenmonths.com     free        register it today
cashcushion.com    for sale    Afternic listing, held since 2003
harborline.com     parked      a holding page since 2000, no listing
safeharbor.com     registered  held since 1995, not advertised for sale
sounder.co         unknown     .co has no registry API. Not checked. Not free.
```

That last line matters most. **A check that failed is never shown as a free domain.**

**Generators rank names by what is free.** That is backwards. A weak name with a free `.com`
is worth less than a strong name whose `.com` costs $2,000. Naming Scout ranks by the name and
shows the domain as a cost. In one run it dropped a direction where 25% of names were free for
one where only 14% were, because the second one produced better names.

**AI tools guess about availability.** A well-known model once returned 12 names, cleared with
*"I could not find an indexed website for these, which is promising."* All 12 were registered,
some since 2004. The one it warned against was the only free one. No website usually means
parked, and parked is what a squatter holds. Naming Scout asks the registry instead.

---

## It also does three things nothing else does

**Tells you if you can be found.** Every name is graded `ownable`, `contested` or `crowded`.
A name you cannot rank for costs you more than an expensive domain.

**Works in your language.** A founder wanting `dokan` instead of `shop` gets every spelling
checked, because `dokan`, `dukan` and `dukaan` are one word to a customer and three different
domains. All three are already taken, which most people assume is not the case.

**Is honest about misspelling.** Want `statik` because `static` is taken? It checks who owns
the spelling your users will actually type. Usually the better answer is to keep the spelling
and change the ending.

---

## What you get

A web page opens in your browser with the answer at the top.

One recommended name, why it works, the domain to register, and the one thing that would
change the recommendation. Then two alternatives, then a list of 8 to 15 names you can open
for the full reasoning. The working is at the bottom, folded away.

Every name comes with a stated weakness. A name with no weakness listed has not been checked
properly.

---

## Examples

Eight complete runs with real data: **[`naming-scout/examples/`](naming-scout/examples/)**

| Example | |
|---|---|
| [Startup](naming-scout/examples/saas-startup.md) | The normal case. A founder naming a product |
| [Local language](naming-scout/examples/local-language.md) | Naming in Bangla for a Dhaka market |
| [Misspelling](naming-scout/examples/respelling.md) | `statik` instead of `static`, and why not |
| [Consumer brand](naming-scout/examples/consumer-product.md) | Where trademark is the real risk |
| [Buying a domain](naming-scout/examples/aftermarket.md) | A funded team willing to pay |
| [Newsletter](naming-scout/examples/newsletter.md) | Domain, social and search only |
| [Wrong direction](naming-scout/examples/weak-first-direction.md) | The first idea fails and the run restarts |
| [Developer tool](naming-scout/examples/developer-tool.md) | Where npm and PyPI decide it |

Full guide: **[`naming-scout/README.md`](naming-scout/README.md)**

---

## What it cannot do

- **Tell you a domain's price.** No registry publishes that. It tells you a listing exists.
- **Check every domain ending.** `.co` and most South Asian endings have no registry API.
  Those come back as "not checked", never as free.
- **Check social handles.** The platforms lie in both directions, so it sends you to look.
- **Clear a trademark.** It helps you search. That is not a lawyer's opinion.

Before you spend money on a brand, get a trademark search from a lawyer in every country you
will sell in. A forced rebrand costs more than every other step combined.
