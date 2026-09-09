# Example: the founder wants to respell the name

A short run. The user has a name, the `.com` is for sale, and they want to misspell their way
out of paying for it. Shows why that fails, what to do instead, and how the exercise exposed
a weaker problem underneath.

*Checks run 2026-09-09. Re-run before deciding.*

---

**User:** We serve read-only JSON APIs from the edge. You push a data file, we cache it
globally, you get an API with no server. I want to call it Static API but `staticapi.com` is
for sale and I don't want to pay. I'd take `statikapi.com` instead. Does that work?

**Scout:** Let me check the respelling before we discuss it, because it is the first move
everybody makes.

## The respelling is already gone

```bash
scripts/variants.sh --set respell static | sed 's/$/api/' | scripts/rdap.sh --tlds com
```

```
staticapi.com    for_sale     2017-09-06   NameBright listing
statikapi.com    registered   2025-10-04   Cloudflare
statcapi.com     free
statycapi.com    free
ztaticapi.com    free
```

Somebody registered `statikapi.com` eleven months ago. `statikapi.dev` went in December.
Respelling is not unclaimed ground. It is the most crowded ground there is, because everyone
who wanted the canonical spelling arrives at the same substitution.

What is left free is `statcapi`, `statycapi` and `ztaticapi`. Look at those for a moment. Each
one is a name you would have to spell out loud every time, forever, to reach a product whose
whole promise is simplicity.

## The rule, applied

`statikapi` fails four of the five tests in `brand-filter.md`.

| Test | Result |
|---|---|
| One transformation, deducible from the sound | Passes. `c` to `k` is a single swap. |
| Reads as its own word, not a typo | **Fails.** `Lyft` looks deliberate. `Statik` looks like static spelled wrong by someone in a hurry. |
| Canonical word generic and unowned | **Fails.** `staticapi.com` is a live listing, so every referral that gets typed correctly reaches a parked page selling the domain you declined to buy. |
| You can afford the leak | **Fails.** Pre-launch, developer audience, and developers are precisely the people who will type the correct spelling by reflex. |
| Never respell a descriptive name | **Fails. This is the one that decides it.** "Static API" works only because it is instantly understood. Misspelling it destroys the single property that made it worth having. |

Lyft can carry a respelling because "lift" belongs to nobody and the brand is unmistakable.
`Statik` carries the cost with none of the benefit.

## What to do instead

**First: keep the spelling, change the TLD.** The name is what people say. The TLD is what
they type once.

```
staticapi.com    for_sale     2017    NameBright
staticapi.io     free
staticapi.dev    free
staticapi.sh     free
staticapi.app    free
```

The correct spelling is free on every developer TLD. For a product whose users live in a
terminal, `staticapi.dev` costs nothing in credibility and costs nothing at all in money.
That is a strictly better outcome than `statikapi.com` in every respect.

**Second, and this matters more:** the fact that you were willing to mangle the name tells me
the name is not doing much work for you. "Static API" describes the category. It would suit
any competitor equally well. It is hard to trademark. It is crowded in search because both
words are technical vocabulary. A descriptive name is a reasonable choice, but it should be
chosen on purpose rather than defended with a misspelling.

So I ran one round in a real territory before recommending anything.

## One round: permanence and carving

The product turns something changeable into something fixed. That is a stone metaphor, not a
software one.

```
etchapi.com       free      chiselapi.com     free
carvedapi.com     free      coldjson.com      free
granitejson.com   free      frozenapi.com     free
flatfilecdn.com   free      quarryapi.io      free
```

Eight free on `.com` in a single round, against a canonical name you were about to pay for or
misspell.

**Etch** is the pick. To etch is to fix something permanently into a hard surface, which is
exactly what the product does to a JSON file. One syllable, spells itself, reads as a verb so
it works in a sentence: "etch it and ship". `etchapi.com` is free, and `etch.dev` would be
worth pricing as the eventual upgrade.
*Weakness:* on its own "Etch" is a common English word, so the bare term is contested in
search. `Etch API` as a pair is clear.
*Searchability:* contested alone, ownable as a pair.

**Chisel** is the runner-up. Same territory, more physical, slightly more effortful.
*Weakness:* Chisel is an existing hardware description language, which is adjacent enough to
developer tooling to matter. Check it before committing.

## Recommendation

1. **Etch**, on `etchapi.com`. A name you can own, at registration price, in a territory that
   still has room.
2. If you want the descriptive name, take **`staticapi.dev`** and keep the correct spelling.
   It is free today.
3. Do not take `statikapi`. It is already registered, and the version you could get would be
   worse than both options above.

If you are set on `staticapi.com`, open the NameBright listing and get a price. Paying for the
canonical spelling is a defensible choice. Misspelling around it is not.

## Check these yourself

- The NameBright price is not visible from RDAP. `for_sale` means a listing exists and says
  nothing about the number.
- Chisel as a hardware description language came from recognising the name, not from a search
  API. Verify it before you decide between the top two.
- No trademark search was run. "Etch" is a common word, which makes it cheaper to clear and
  harder to own.
- `statikapi.com` is registered and I did not check what is served there. A competitor
  building the same thing under the spelling you wanted is worth ten minutes of your time.
