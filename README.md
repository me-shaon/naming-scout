# Naming Scout

An agent skill that finds a name for your startup or product. Then it checks if you can
really use it.

```bash
npx skills add me-shaon/naming-scout
```

Works in Claude Code, Cursor, Codex, OpenCode and 75 other agents. Add `-g` for every
project. You need `curl` and `jq`.

---

## Why it is different

Say you are naming a budgeting app. It helps freelancers who earn a lot one month and almost
nothing the next.

**A name generator gives you your keyword with letters added.**

```
Budgetly      taken in 2011
Budgetify     taken in 2014
GetBudget     taken in 2003
```

None of these tells your customer what the app does. And all of them are gone. Every
generator looks in the same small place, so that place is empty.

**Naming Scout works from what your product does.**

Your app stops bad months from hurting. A cushion is soft, and it stops you getting hurt when
you fall. So one idea it may reach is a name like this:

```
Cash Cushion    money that softens the fall in a bad month
```

That is one example, not a promise. You get 8 to 15 names, each with a reason and a weakness.

**Then it tells you the truth about every domain.**

Most tools show you a red cross. You learn nothing from a red cross. You get five answers
instead:

| Answer | What it means |
|---|---|
| **free** | Nobody owns it. Register it now. |
| **for sale** | Someone owns it and wants to sell it. |
| **parked** | Someone owns it. No website and no price. |
| **taken** | Someone owns it and uses it. |
| **not checked** | The check failed. This does not mean free. |

The last one matters most. Other tools show a failed check as a free domain. You find out
later, after you have chosen the name.

---

## It also does these

**It works in your language.** Say you want the Bangla word `dokan` for a shop app. Bangla is
not written in English letters, so your customers will type it in different ways. All of them
are already gone:

```
dokan.com     taken in 2002
dukan.com     taken in 2000
dukaan.com    taken in 1999
```

Most people check one spelling and never learn this. Naming Scout checks every spelling. It
does the same for Hindi, Urdu, Arabic, Turkish, Thai and Korean.

**It stops a bad spelling choice.** You want `staticapi.com`, but it is for sale. You think
about using `statikapi.com` instead:

```
staticapi.com    for sale
statikapi.com    taken in October 2025
staticapi.dev    free
```

Someone already took the misspelling. And the correct spelling is free with a different
ending. Keeping the spelling your customers know is almost always better.

**It tells you if people can find you.** Every name gets one of three answers:

- **ownable.** Nothing else uses this name. You will be the first search result.
- **contested.** Other things share this name. You will need time and work.
- **crowded.** This name is a common word. You may never be first.

A name people cannot find costs you more than an expensive domain.

---

## What you get

A web page opens in your browser. The answer is at the top.

You see one recommended name, why it works, and the domain to buy. You also see the one thing
that would change the answer. Below that, two more names, then the full list.

Every name comes with a weakness. If a name has no weakness listed, nobody checked it properly.

---

## What it checks

It checks these on its own:

- Domain names, at the registry
- GitHub usernames
- npm, PyPI, crates.io, RubyGems and Docker Hub package names

It helps you check these by hand, because they need judgement:

- Trademarks
- Search results
- App stores
- Social media handles

---

## Real examples

Eight complete runs with real data: **[`naming-scout/examples/`](naming-scout/examples/)**

| Example | What it shows |
|---|---|
| [Startup](naming-scout/examples/saas-startup.md) | The normal case. A founder naming a product |
| [Your own language](naming-scout/examples/local-language.md) | Naming in Bangla for a Dhaka market |
| [Misspelling](naming-scout/examples/respelling.md) | `statik` instead of `static`, and why not |
| [Consumer brand](naming-scout/examples/consumer-product.md) | Where trademark is the real risk |
| [Buying a domain](naming-scout/examples/aftermarket.md) | A funded team willing to pay |
| [Newsletter](naming-scout/examples/newsletter.md) | Domain, social and search only |
| [A wrong start](naming-scout/examples/weak-first-direction.md) | The first idea fails and the work restarts |
| [Developer tool](naming-scout/examples/developer-tool.md) | Where npm and PyPI decide it |

Full guide: **[`naming-scout/README.md`](naming-scout/README.md)**

---

## What it cannot do

- **It cannot tell you a domain price.** No registry publishes prices. It tells you a listing
  exists and sends you there.
- **It cannot check every domain ending.** `.co` and most South Asian endings have no registry
  API. Those come back as "not checked".
- **It cannot check social handles.** The platforms give wrong answers, so it sends you to look.
- **It cannot clear a trademark.** It helps you search. That is not legal advice.

Before you spend money on a brand, ask a lawyer to do a trademark search in every country you
will sell in. Changing your name later costs far more.
