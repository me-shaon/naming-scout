# Naming in a language other than English

A Bangladeshi founder naming a shop product may want `dokan` rather than `shop`. A Brazilian
founder may want `caixa`. This is usually a good instinct and it carries specific costs that
an English-only naming process never surfaces.

Use this whenever the user's market is not primarily English-speaking, whenever they mention
a local audience, and whenever they offer a word from their own language. Ask early. It
changes the territories, the domain strategy and the clearance profile.

## Why a local word is often the right answer

**It means something instantly to the people you are selling to.** `Dokan` needs no
explanation to a Bangladeshi shopkeeper. `Shop` is generic in every market at once.

**It signals you are one of them.** A local word tells the user this was built for their
market rather than translated into it. For a product competing with a foreign incumbent that
is the whole positioning.

**English words are exhausted and local words feel unclaimed.** That second half is usually
wrong, and the next section is the evidence.

**Local words travel further than founders expect.** Alibaba, Xiaomi, Nubank, Rappi, Grab,
Gojek and Paytm all crossed borders. A local word survives export when it is short and
phonetically simple in the target language. It fails when it needs a sound the new market
does not have.

## The finding that surprises people

Transliterated single words are **not** an unmined space on `.com`.

Checked live on 2026-09-09:

```
dokan.com     registered 2002      haat.com     registered
dukan.com     registered 2000      khata.com    registered
dukaan.com    registered 1999      thela.com    registered
dokaan.com    for_sale   2001      mudi.com     registered
getdokan.com  registered 2018      bazar.com    registered
```

Of the twenty commerce words tested from Bangla, eighteen were registered and two were listed
for sale. Not one was free.

Domainers hold short strings regardless of which language they come from. A four-letter
romanised word is a four-letter `.com`, and every one of those went years ago. The intuition
that "nobody will have taken a Bangla word" is wrong. Tell the user before they get
attached.

**Where the room actually is.** Compounds. `jhurihat.com`, `tokribazar.com` and
`nokshiapp.com` were all free in the same run. Same vocabulary, same market, two words instead
of one. This mirrors the English pattern exactly.

## Transliteration is the real problem

A word from a non-Latin script has no canonical spelling in Latin letters. `dokan`, `dukan`,
`dokaan` and `dukaan` are one word to a speaker and four different strings to a domain
registry, a search engine and an app store.

That has three consequences.

**Your users will type all of them.** Every spelling you do not own is a share of your direct
traffic going somewhere else, including to a competitor or a parking page.

**Search will not merge them.** These are separate query strings. Ranking for one does not
rank you for the others. Your brand search traffic gets split at exactly the point where it
should be concentrated.

**Somebody may already hold the variant you did not check.** In the run above, `dokaan.com`
was listed on Afternic and `getdokan.com` was in active use.

Run the sweep before you commit to a spelling:

```bash
scripts/variants.sh --set translit dokan | scripts/rdap.sh --tlds com,com.bd
```

The `translit` set applies the substitutions that romanisations actually disagree on. Long and
short vowels, aspirated consonants (`kh`/`k`, `gh`/`g`, `bh`/`b`, `th`/`t`), `sh` against `s`,
`z` against `j`, `v` against `w` against `b`, `q` against `k`, and a trailing vowel appearing
or disappearing. It covers Bangla, Hindi, Urdu, Arabic, Persian, Turkish, Thai and Korean
romanisation, which all break the same way.

**Choose the spelling your audience types, then buy the two closest neighbours.** Do not try
to own all of them. Pick the dominant spelling by searching each variant and seeing which one
the search engine treats as primary, then defend the two most likely misspellings.

## Domains for a local market

**The local ccTLD is often the right primary.** `.com.bd` for a Bangladeshi product carries
more trust locally than a `.com` and the vocabulary is far less mined. It also geo-targets
you, which is correct for a local product and wrong for a global one. See the TLD section in
`search-and-seo.md` before recommending it.

**Many local registries have no RDAP, so this skill cannot verify them.** Confirmed on
2026-09-09: `.bd`, `.pk`, `.lk`, `.np` and `.my` have no RDAP server in the IANA bootstrap.
`.in` and `.id` do. Those without return `unknown_no_rdap`, which means unresolved and never
means free. Send the user to the registry's own search, and say plainly that you could not
check it.

**Local registries often have manual registration.** Several South Asian ccTLDs require
paperwork, a local presence, or a wait. Factor that into the recommendation rather than
treating registration as instant.

**Native-script domains are defensive, not primary.** 94 internationalised TLDs have RDAP.
Almost nobody types a native-script URL on a phone keyboard, so register the script version to
stop somebody else having it, and run the business on the romanised one.

## Checks that change in a non-English market

| Check | What is different |
|---|---|
| **Meaning** | Get a native speaker to react to it. Not a translation tool. You are checking for slang, regional variation, a religious or caste association, and whether it sounds like something a grandmother would say. This is the check with the highest chance of catching a real problem. |
| **Regional variation** | A word can be neutral in one region and loaded in another that shares the language. Bangla differs between Dhaka and Kolkata. Spanish differs across every market. Ask which regions matter. |
| **Trademark** | Search the local register, not only USPTO and EUIPO. Many are not searchable online at all, which means a local agent. Say so rather than implying the name is clear. |
| **Search** | Search in the native script as well as in every romanisation. Different results, different competitors. |
| **Script rendering** | If the brand will appear in the native script, check that it sets well in a logo and does not break at small sizes. Some scripts have complex ligatures that render badly in common fonts. |
| **Vowel length** | Bangla, Hindi, Arabic and Japanese distinguish long and short vowels that Latin letters lose. Two different words can romanise identically. Confirm the intended word is the one being read. |

## A territory worth adding for these briefs

Add **native vocabulary** to the territory set, and ask the user for it directly. They are the
only person who can supply it.

> Give me five words your customers use every day that an outsider would not know. Not the
> formal word. The one they actually say.

That question produces better material than any list you could generate, because it returns
words with the right register. `Haat` for a village market carries something `bazar` does not.
The user knows the difference and you do not.

Then treat those words the way any other territory gets treated. Generate inside them, filter
for brand quality, and check availability. Expect the single words to be gone and the
compounds to be open.

## The tension to raise, once

A local word makes you unmistakably local. That is either the point or a ceiling, and the user
should decide which rather than discover it in year three.

Ask once, plainly:

> If this works, do you want to sell it in Indonesia and Nigeria too, or is Bangladesh the
> whole business? A Bangla name is an advantage in Dhaka and a translation problem in Lagos.

Both answers are fine. Take the answer and stop discussing it.
