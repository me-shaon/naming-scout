# Example: naming in a language other than English

A Bangladeshi founder naming for a Bangladeshi market. Shows the transliteration sweep, the
fact that local words are not unclaimed, and a local TLD that cannot be verified.

*Checks run 2026-09-09. Re-run before deciding.*

---

**User:** I'm building an app for small shopkeepers in Dhaka. The mudir dokan sells on credit
all day and writes it in a notebook. Half of it never gets collected. We digitise the credit
ledger so they know who owes what. Name should feel local, not like a foreign fintech app.

**Scout:** Then we look at Bangla words, not English ones. Four questions:

1. Bangla script anywhere, or Latin letters only?
2. Bangladesh only, or Bengali speakers in West Bengal too? The vocabulary differs.
3. `.com` or `.com.bd`? A `.com.bd` reads as more local. It also tells search engines you
   serve Bangladesh, which helps if you stay and hurts if you expand.
4. Give me five words your shopkeepers use every day that an outsider would not know. The one
   they actually say, not the formal one.

**User:** Latin for the app, Bangla script for the logo. Bangladesh now, maybe Kolkata later.
`.com.bd` is fine, `.com` would be nice. Words: baki, khata, hishab, halkhata, mudi.

**Scout:** That last answer is the most useful thing in the brief. I could not have generated
`halkhata`.

Checks: `.com`, the romanisation sweep, trademark at DPDT, search in both scripts, both app
stores. No GitHub or npm.

## Territories

- **The ledger object.** Khata, boi, the red account book.
- **The debt itself.** Baki, shodh. What the shopkeeper is tracking.
- **Halkhata.** The Bengali new-year ritual where a shopkeeper opens a fresh ledger and
  settles the old year's debts. The product's whole promise in one existing word.
- **The shop.** Mudi, dokan, thela.
- **Possessive framing.** Amar (my), Notun (new). Common in Bangladeshi apps and warm rather
  than corporate.

## Round 1: single words

**0 of 6 free.**

```
baki.com      parked      2001, Voodoo parking
hishab.com    for_sale    2014, NameBright
khata.com     registered      shodh.com     registered
bishash.com   registered      jomakhata.com registered
```

Say this to the user directly, because the assumption is always the same: nobody will have
taken a Bangla word.

They have. A domainer holding four and five letter `.com` strings does not care which language
the string came from. `baki.com` has been parked since 2001. Across twenty Bangla commerce
words tested, eighteen were registered and two were listed for sale. None were free.

## Round 2: compounds

**6 of 8 free.**

```
bakiboi.com      free      amarbaki.com     free
mudikhata.com    free      notunkhata.com   free
khatapatra.com   free      lalkhatha.com    free
lalkhata.com     registered  2026-05-28, Namecheap
halkhata.com     registered  2011-07-20, Cloudflare
```

Same vocabulary, two words instead of one, and the space opens. Same pattern as English.

Two of the best names are gone, and how they went matters. `halkhata.com` has been held since
2011, `halkhata.app` since 2024, and `halkhataapp.com` since April 2026. Other people keep
having this idea. `lalkhata.com` went in May 2026, four months before this run.

## The transliteration sweep

This step does not exist in an English run. Bangla has no canonical Latin spelling, so
`lalkhata`, `laalkhata` and `lalkhataa` are one word to your user and three strings to a
registry.

```bash
scripts/variants.sh --set translit lalkhata | scripts/rdap.sh --tlds com
```

```
lalkhata.com     registered 2026-05-28   ← the spelling people type
lalkata.com      free      lalkhataa.com   free
lalkhhata.com    free      laalkhaataa.com free
... 17 free in total
```

**Do not read that as good news.** Owning `lalkhataa.com` does not get you `lalkhata`. Your
customer types the spelling they know, lands on someone else's domain, and you paid $12 to
find out. Free variants are worth something only as defence for a name you already own.

The same sweep on the leader came back clean. `bakiboi.com`, `baakiboi.com`, `bakhiboi.com`
and the rest are all free.

## Shortlist

**Baki Boi**
"বাকি বই", the credit book. The physical object the shopkeeper already keeps, so the app
explains itself before it opens. Two short syllables a Dhaka shopkeeper reads at a glance, and
a Kolkata one would too.
*Weakness:* "boi" means book, so the name is slightly literal and caps you at ledgers. Add
payments later and the name lags the product.
*Searchability:* **ownable** as a pair. "Baki" alone is common across four languages.
`.com` free · whole romanisation space free

**Halkhata**
The best name in the run. Halkhata is the new-year ritual where the shopkeeper opens a fresh
ledger and settles old debts. It carries the promise, the emotional payoff and the category in
one word every Bangladeshi shopkeeper knows. No outsider could invent it.
*Weakness:* the `.com` went in 2011 and the `.app` in 2024. Someone registered
`halkhataapp.com` in April 2026, so a competitor may be circling. The word is also tied to one
day a year, which may read as seasonal for a daily app.
*Searchability:* **crowded**. Halkhata is a festival with press coverage every April. You
would compete with it for your own name forever.
`.com` registered 2011 · `.app` registered 2024

**Amar Baki**
"My credit". Warm and first-person. Matches how Bangladeshi consumer apps are already named,
and reads as the shopkeeper's own record rather than a service watching them.
*Weakness:* "Amar" is heavily used in Bangladeshi app naming, so it will not stand out in the
store. It also sounds like personal finance rather than a business tool.
*Searchability:* **contested**.
`.com` free

**Lal Khata**
The red account book. Concrete, visual, gives you a brand colour for free.
*Weakness:* the `.com` went in May 2026 and only worse spellings remain. Buying `lalkhataa.com`
gets you a name your customers will misspell into someone else's traffic.
`.com` registered 2026-05-28

**Mudi Khata**
"The grocer's ledger". The most precise name about who it is for.
*Weakness:* precise in the way that limits you. A mudi is specifically a grocer, so a pharmacy
or a hardware shop would not see themselves in it. That is a real ceiling on a product whose
market is small retail of every kind.
*Searchability:* **ownable**.
`.com` free

**Hishab**
"Accounts". One word, widely understood, and purchasable.
*Weakness:* the plainest possible word for the category. The Bangla equivalent of calling your
company Accounting.
*Searchability:* **crowded**. Common word in four languages.
`.com` for sale since 2014

**Baki**
The strongest single word, and unusable. Parked on Voodoo since 2001, so no listing and no
price. Crowded in search across four languages.

## Top 3

1. **Baki Boi.** The one I would ship. The `.com` is free, the whole romanisation space is
   free, and a shopkeeper understands it without being told. It is the least ambitious of the
   three and the only one you can fully own today.
2. **Halkhata.** The better name and the worse asset. Take it only if you will buy a 2011
   domain and compete with a national festival for your own search term.
3. **Mudi Khata.** Only if you are certain the market is grocers and stays grocers.

**Boldest bet:** Halkhata. No foreign competitor could ever use this name. It costs you an
aftermarket negotiation and a permanent search problem.

**Safest bet:** Baki Boi on `bakiboi.com`, with `baakiboi.com` and `bakhiboi.com` alongside as
the two likely misspellings.

## Check these yourself

- **`.com.bd` could not be verified.** `.bd` has no RDAP server, so every lookup returns
  `unknown_no_rdap`. Unresolved, not free. Check at BTCL directly and budget for manual
  registration rather than assuming it is instant.
- **A `.com.bd` geo-targets you to Bangladesh.** Right while Bangladesh is the whole business,
  a handicap the day you open in Kolkata. If Kolkata is likely, run `.com` as primary.
- **Trademark was not searched.** The DPDT register is not usefully searchable online, so this
  needs a local agent. "Halkhata" is a common noun, which affects whether it can be registered
  at all.
- **Get a native speaker outside your team to react to the shortlist.** You are close to these
  words. Check for regional or religious associations you have stopped hearing.
- **Search in Bangla script as well as Latin.** "বাকি বই" and "bakiboi" return different
  results and different competitors.
- **App stores were not checked.**
