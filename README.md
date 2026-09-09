# Naming Scout

Finds a name for your startup, product or side project. Then checks if you can use it.

```bash
npx skills add me-shaon/naming-scout
```

It is an agent skill. It works in Claude Code, Cursor, Codex, OpenCode and 75 other agents.
Add `-g` to install it for every project. You need `curl` and `jq`.

---

## The problem with name generators

You want to name a budgeting app for freelancers.

A generator gives you this:

| Name | What it is | The `.com` |
|---|---|---|
| `Budgetly` | "budget" plus "ly" | taken in 2011 |
| `Budgetify` | "budget" plus "ify" | taken in 2014 |
| `GetBudget` | "budget" plus "get" | taken in 2003 |

All three are the same word with letters added. None of them says what the app does. And all
three domains went years ago.

Every generator looks in the same small place. That place is empty now.

---

## What Naming Scout does instead

It starts with your product, not your keyword.

Your app helps freelancers who earn £9,000 one month and £900 the next. It works out a safe
amount to pay yourself. So the bad months stop hurting.

A cushion is soft. It stops you getting hurt when you fall.

> ## Cash Cushion
> Money that softens the fall in a bad month.

Nobody has to explain this name to you. That is the difference.

---

## It tells you the truth about domains

Most tools show you a red cross. You learn nothing from a red cross.

Naming Scout tells you five different things:

| Answer | What it means for you |
|---|---|
| **free** | Nobody owns it. You can register it now. |
| **for sale** | Someone owns it. They want to sell it. |
| **parked** | Someone owns it. There is no website and no price. |
| **taken** | Someone owns it and uses it. |
| **not checked** | The check failed. This does not mean free. |

The last one matters. Other tools show a failed check as a free domain. You find out later,
after you have chosen the name.

Naming Scout cannot tell you the price. No registry publishes prices. It tells you a price
exists and gives you the listing.

---

## It works in your language

You are building a shop app in Bangladesh. You want the word `dokan`.

Bangla is not written in English letters. So people spell it in different ways. Your customers
will type all of them:

```
dokan.com     taken in 2002
dukan.com     taken in 2000
dukaan.com    taken in 1999
```

All three are gone. Most people only check one spelling and never learn this.

Naming Scout checks every spelling first. It does this for Bangla, Hindi, Urdu, Arabic,
Turkish, Thai and Korean.

---

## It stops you making a bad spelling choice

You want `staticapi.com`. It is for sale. You think: I will use `statikapi.com` instead.

Naming Scout checks that idea:

```
staticapi.com    for sale
statikapi.com    taken in October 2025
staticapi.dev    free
```

Someone already took the misspelling. And the correct spelling is free on `.dev`.

Keeping the right spelling and changing the ending is almost always better. Your customers
type the spelling they know.

---

## It tells you if people can find you

Every name gets one of three answers:

- **ownable.** Nothing else uses this name. You will be the first search result.
- **contested.** Other things share this name. You will need time and work.
- **crowded.** This name is a common word. You may never be first.

A name you cannot be found by costs you more than an expensive domain. Most naming tools
never mention this.

---

## What you get

A web page opens in your browser. The answer is at the top.

You see one recommended name, why it works, and the domain to buy. You also see the one thing
that would change the answer. Below that, two more names. Then a list of 8 to 15 names. You
can open any of them to read the full reasoning.

Every name comes with a weakness. If a name has no weakness listed, nobody checked it properly.

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

## What it cannot do

- **It cannot tell you a domain price.** No registry publishes prices.
- **It cannot check every domain ending.** `.co` and most South Asian endings have no registry
  API. Those come back as "not checked".
- **It cannot check social handles.** The platforms give wrong answers, so it sends you to look.
- **It cannot clear a trademark.** It helps you search. That is not legal advice.

Before you spend money on a brand, ask a lawyer to do a trademark search in every country you
will sell in. Changing your name later costs far more.
