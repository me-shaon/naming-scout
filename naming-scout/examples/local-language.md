# Example: naming in a language other than English

A Bangladeshi founder naming for a Bangladeshi market. Shows the transliteration sweep, the
finding that local words are not unclaimed, a local TLD that cannot be verified, and
searchability deciding the ranking.

*Checks run 2026-09-09. Re-run before deciding.*

---

**User:** I'm building an app for small shopkeepers in Dhaka. The mudir dokan sells on credit
all day and writes it in a notebook. Half of it never gets collected. We digitise the credit
ledger so they know who owes what. Name should feel local, not like a foreign fintech app.

**Scout:** Then we should look at Bangla words, not English ones. Four questions:

1. Do you want the name written in Bangla script anywhere, or Latin letters only?
2. Bangladesh only, or Bengali speakers in West Bengal too? The vocabulary differs.
3. `.com` or `.com.bd`? A `.com.bd` reads as more local and it tells search engines you serve
   Bangladesh, which is right if you stay here and a handicap if you expand.
4. Give me five words your shopkeepers use every day that an outsider would not know. Not the
   formal word. The one they actually say.

**User:** Latin letters for the app, Bangla script for the logo. Bangladesh only for now,
maybe Kolkata later. `.com.bd` is fine, `.com` would be nice. Words: baki, khata, hishab,
halkhata, mudi.

**Scout:** That last answer is the most useful thing in this brief. I could not have generated
`halkhata`.

Checks: domain on `.com`, plus the romanisation sweep, plus trademark at the Department of
Patents, Designs and Trademarks, plus search in both Latin and Bangla script, plus both app
stores. No GitHub or npm.

## Territories

- **The ledger object.** Khata, boi, khatapatra, the red account book. Physical and familiar.
- **The debt itself.** Baki, shodh, chukti. What the shopkeeper is actually tracking.
- **Halkhata.** The Bengali new-year ritual where a shopkeeper opens a fresh ledger and
  settles the old year's debts. It is the product's entire promise in one existing word.
- **The shop.** Mudi, dokan, thela.
- **Possessive framing.** Amar (my), Notun (new). Common in Bangladeshi consumer apps and
  warm rather than corporate.

## Round 1: the single words

```
baki.com      parked      2001    Voodoo parking
hishab.com    for_sale    2014    NameBright
khata.com     registered
shodh.com     registered
bishash.com   registered
jomakhata.com registered
```

Zero free. This is worth saying to the user directly, because the assumption is always the
same: nobody will have taken a Bangla word.

They have. A domainer holding four and five letter `.com` strings does not care which language
the string comes from. `baki.com` has been parked since 2001. Across twenty Bangla commerce
words tested in a related run, eighteen were registered and two were listed for sale. None
were free.

## Round 2: compounds

```
bakiboi.com      free      amarbaki.com     free
mudikhata.com    free      notunkhata.com   free
khatapatra.com   free      lalkhatha.com    free
lalkhata.com     registered  2026-05-28   Namecheap
halkhata.com     registered  2011-07-20   Cloudflare
```

Same vocabulary, two words instead of one, and the space opens. Identical to the English
pattern.

Two of the best names are gone, and how they are gone matters:

**`halkhata.com` has been held since 2011.** `halkhata.app` went in 2024 and
`halkhataapp.com` in April 2026. Somebody else has had this idea recently, more than once.

**`lalkhata.com` was registered in May 2026**, four months before this run.

## The transliteration sweep

This is the step that does not exist in an English naming run. Bangla has no canonical Latin
spelling, so `lalkhata`, `laalkhata` and `lalkhataa` are one word to your user and three
strings to a registry.

```bash
scripts/variants.sh --set translit lalkhata | scripts/rdap.sh --tlds com
```

```
lalkhata.com      registered 2026-05-28   ← the spelling people actually type
lalkata.com       free      lalkhat.com      free
lalkhataa.com     free      lalkhhata.com    free
laalkhaataa.com   free      lelkhete.com     free
... 17 free in total
```

Every romanisation is free except the one that matters.

**Do not read that as good news.** Owning `lalkhataa.com` does not get you `lalkhata`. Your
customer types the spelling they know, lands on somebody else's domain, and you have paid $12
to learn that. The free variants here are worth nothing except as defence for a name you
already own.

The same sweep on the leader came back clean:

```
bakiboi.com      free
baakiboi.com     free      bakhiboi.com     free
bakeeboee.com    free      baaqiboi.com     free
... the whole space is open
```

That is the difference between a name you can own and a name you can only rent a corner of.

## Shortlist

**Baki Boi** (The ledger object and the debt)
"বাকি বই", the credit book. It is the physical object the shopkeeper already keeps, so the
app explains itself before it is opened. Two short syllables that a Dhaka shopkeeper reads
correctly at a glance and that a Kolkata one would too.
*Weakness:* "boi" means book, so the name is slightly literal. It also caps you at ledgers.
If you add payments or inventory later, the name lags the product.
*Searchability:* **ownable**. "Baki" alone is a common word across Bangla, Hindi, Urdu and
Arabic, so it is crowded on its own. As a pair the phrase is clear.
`.com` free · entire romanisation space free · `.com.bd` not verifiable, see below

**Halkhata** (Halkhata)
The best name in the run. Halkhata is the new-year ritual where the shopkeeper opens a fresh
ledger and settles the old year's debts. It carries the product's promise, the emotional
payoff and the category in a single word every Bangladeshi shopkeeper already knows. Nothing
an outsider could invent.
*Weakness:* the `.com` has been held since 2011 and the `.app` since 2024. Somebody registered
`halkhataapp.com` in April 2026, which suggests a competitor is circling the same idea. The
word is also tied to one day of the year, so it may read as seasonal for a daily-use app.
*Searchability:* **crowded**. Halkhata is a cultural event with press coverage every April.
You would compete with the festival for your own name, forever.
`.com` registered 2011 · `.app` registered 2024 · `halkhatha.com` free but wrongly spelled

**Amar Baki** (Possessive framing)
"My credit". Warm, first-person, and it matches how Bangladeshi consumer apps are already
named. It reads as the shopkeeper's own record rather than a service watching them.
*Weakness:* "Amar" is heavily used in Bangladeshi app naming, so it will not feel distinctive
in the store. It also sounds like a personal finance app rather than a business one.
*Searchability:* **contested**. The pattern is common enough that you would share results.
`.com` free

**Lal Khata** (The ledger object)
The red account book. Concrete, visual, and it gives you a brand colour for free.
*Weakness:* the `.com` went in May 2026 and only worse spellings remain. Buying
`lalkhataa.com` gets you a name your customers will misspell into somebody else's traffic.
*Searchability:* **contested**, and moot while the domain is held.
`.com` registered 2026-05-28 · 17 romanisation variants free and all of them worse

**Mudi Khata** (The shop)
"The grocer's ledger". The most precise name here about who it is for.
*Weakness:* it is precise in the way that limits you. A mudi is specifically a grocer, so a
pharmacy or a hardware shop would not see themselves in it. That is a real ceiling on a
product whose whole market is small retail of every kind.
*Searchability:* **ownable**.
`.com` free

**Notun Khata** (Possessive framing)
"New ledger". Clean, optimistic, and it borrows the halkhata idea without taking the word.
*Weakness:* generic enough that it could be a school notebook brand. It says nothing about
credit, which is the actual problem.
*Searchability:* **contested**.
`.com` free

**Hishab** (The ledger object)
"Accounts". One word, widely understood, and the `.com` is purchasable.
*Weakness:* it is the plainest possible word for the category, so it is the Bangla equivalent
of naming a company Accounting. Listed on NameBright since 2014, price unknown.
*Searchability:* **crowded**. Common word in four languages.
`.com` for sale

**Baki** (The debt)
The single strongest word, and unusable. Parked on Voodoo since 2001, so there is no listing
and no price. As a bare word it is also crowded in search across four languages.
`.com` parked since 2001, no listing found

## Top 3

1. **Baki Boi.** The one I would ship. The `.com` is free, the entire romanisation space is
   free, and a shopkeeper understands it without being told. It is the least ambitious name of
   the three and it is the only one you can fully own today.
2. **Halkhata.** The better name and the worse asset. Take it only if you are willing to buy a
   2011 domain and compete with a national festival for your own search term. Get a price
   before you fall for it, because you will fall for it.
3. **Mudi Khata.** Take it if you are certain the market is grocers and stays grocers.

**Boldest bet:** Halkhata. No foreign competitor could ever use this name, which is the entire
argument for it. It costs you an aftermarket negotiation and a permanent search problem.

**Safest bet:** Baki Boi on `bakiboi.com`, with `baakiboi.com` and `bakhiboi.com` registered
alongside it as the two most likely misspellings.

## Check these yourself

- **`.com.bd` could not be verified.** `.bd` has no RDAP server in the IANA bootstrap, so
  every lookup returns `unknown_no_rdap`. That means unresolved. It does not mean free. Check
  at BTCL directly, and budget for the manual registration process rather than assuming it is
  instant.
- **A `.com.bd` will geo-target you to Bangladesh.** Correct while Bangladesh is the whole
  business, and a handicap the day you open in Kolkata. If Kolkata is likely, run the `.com`
  as primary and point the `.com.bd` at it.
- **Trademark was not searched.** The Bangladeshi register at DPDT is not usefully searchable
  online, so this needs a local agent. Do it before you spend on the brand. "Halkhata" in
  particular is a common noun, which affects whether it can be registered at all.
- **Get a native speaker outside your team to react to the shortlist.** You are close to these
  words. Check that nothing carries a regional or religious association you have stopped
  hearing, and confirm the Kolkata reading if West Bengal matters later.
- **Search in Bangla script as well as Latin.** "বাকি বই" and "bakiboi" return different
  results and different competitors. Both need to lead to you.
- **App stores were not checked.** Search both for every shortlisted name and for the closest
  romanisations before you build a listing.
