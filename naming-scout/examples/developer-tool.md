# Example: developer tool (CLI)

Shows GitHub, npm and PyPI clearance mattering. Shows availability rate deciding the TLD.
Shows that short real words are gone as GitHub orgs.

*Checks run 2026-09-08. Domain and namespace states change. Re-run before deciding.*

---

**User:** I need a name for a CLI that reads your Postgres slow-query log and tells you
which index is missing. For backend engineers. Should feel like precision tooling, not a
startup.

**Scout:** Enough to work from. Three things before I generate:

1. Does it have to be `.com`, or is a developer TLD fine? `.dev` and `.sh` read as native to
   this audience and are far less mined.
2. Will you publish it as a package? If so, which ecosystems?
3. It gets typed a lot. Are you after one word under 8 characters, or is a two-word compound
   acceptable?

**User:** `.com` would be nice but I'm not precious. Probably a Go binary with a Homebrew
tap, but I'd like npm and PyPI free so I can add installers later. Short is better.

**Scout:** Checks: domain on `.com`, `.dev` and `.sh`, plus GitHub org, npm, PyPI and a
search pass. Skipping trademark and app stores. No commercial launch, no mobile.

## Territories

The tool finds an expensive thing hidden inside a system you cannot see into. That is not a
database metaphor. It is a depth metaphor.

- **Depth sounding.** The instruments sailors used to find the bottom before sonar. A
  weighted line dropped into water you cannot see through. The mapping is almost exact.
- **Diagnostics.** Vitals, triage, symptoms. It fits the job. Every observability tool is
  already here, so the names will sound like the category rather than like you.
- **Divining.** Finding water underground by reading the surface. Generates well. Fights the
  precision positioning.
- **Craft and sharpening.** Whetstone, hone, grindstone. Fits "make the slow thing fast".
- **Cartography.** Atlas, contour, seam. The query plan read as terrain.

## Round 1: 24 names across all five, on `.com` and `.dev`

```
.com   1 / 24 free   (4%)
.dev  14 / 24 free   (58%)
```

The 4% is the finding. It has nothing to do with these particular names. Every two-word
compound of common English words was registered between 1995 and 2010. `whetstone.com` in
1995. `waterline.com` in 2000. `soundings.com` in 1995.

That forces a choice. Move to `.dev` and `.sh`, or accept the aftermarket. For a CLI whose
users live in a terminal, `.dev` costs almost nothing in credibility.

Notable results:

```
slipstream.com   for_sale     1996   BrandBucket listing
honestone.com    for_sale     2002   Sedo parking
apexline.com     for_sale     2019   Afternic
whetstone.dev    for_sale     2026   Afternic. Registered and flipped this year.
deadreckon.dev   unknown        -    429 after 4 attempts
```

`deadreckon.dev` did not resolve. Google's registry rate-limited it. That is not the same as
free.

## Round 2: deeper into depth sounding

The rate held. 1/22 on `.com`, 11/22 on `.dev`. Same conclusion, more confidence.

## Round 3: the strongest stems as short words

```
leadsman.dev    free          leadsman.sh   free          leadsman.com   registered 1999
bythemark.dev   free          bythemark.sh  free          bythemark.com  registered 2008
sounder.dev     free          sounder.sh    free          sounder.com    registered 1995
dowse.dev       free          dowse.sh      free          dowse.com      registered 1999
plumb.dev       registered    plumb.sh      registered    plumb.com      registered 1996
fathom.dev      registered    fathom.sh     registered    fathom.com     registered 1995
```

## Namespace clearance

```
name        github   npm     pypi
leadsman    taken    free    free
bythemark   taken    free    free
sounder     taken    free    taken
dowser      taken    free    taken
plumb       taken    taken   taken
sonde       taken    taken   taken
```

Every single-word GitHub login is claimed. That is normal, not bad luck. Logins for real
English words went years ago and most sit dormant. Plan on `leadsman-dev`, `getleadsman`, or
a repo under your personal account. It does not block a CLI. The install command and the
binary name matter more than the org slug.

## Shortlist

**Sounder** (Depth sounding)
A sounder is the instrument that measures depth. Engineers read the word correctly the first
time. It is the shortest of the finalists and the best to type: `sounder analyze`.
*Weakness:* it is also a bird and a piece of audio equipment. Read cold it can land as a
comparative adjective, as in "sounder judgment". PyPI already holds the name, so a Python
installer needs a different one.
*Searchability:* **contested**. Shares the term with a seabird and with audio hardware.
"sounder postgres" is clean, so expect to lose the bare term for the first year.
`.dev` free · `.sh` free · `.com` registered 1995 · npm free · **PyPI taken** · GitHub taken

**Leadsman** (Depth sounding)
The leadsman drops the weighted line and calls out the depth. He is not the navigator. He
reports what is under you. That is this tool's job. Two syllables that spell themselves. No
other developer tool uses the word.
*Weakness:* you have to know the word for the name to mean anything. Anyone who does not
will hear "lead" as a sales lead, which is an unhelpful first association here.
*Searchability:* **ownable**. Almost nothing else uses the word, so you would be the first
result within weeks. This is the strongest search position in the run.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI free · GitHub taken

**By the Mark** (Depth sounding)
The leadsman's actual call. "By the mark, twain" is the depth read off the knots in the line.
The name points at the reading rather than the person taking it, which is what a reporting
tool produces. Highest ceiling in the run.
*Weakness:* three words. As a binary it collapses to `bythemark` or `btm`. Neither is good
to type. It suits a hosted product better than a command line.
`.dev` free · `.sh` free · `.com` registered 2008 · npm free · PyPI free

**Dowse** (Divining)
Five letters, one syllable, free on both developer TLDs. To dowse is to find what is
underground by reading the surface. That is what the tool does to a query plan.
*Weakness:* dowsing is pseudoscience. This tool sells precision. Naming it after the
best-known unscientific method is a real conflict. Some engineers will read it as a joke,
which may be fine or may be fatal depending on how serious the positioning is.
*Searchability:* **contested**. Dowsing has a large existing body of results, so the developer
sense would have to be built from nothing.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI taken as `dowser`

**Plumbrod, Soundingline, Keelline.** Same territory. `.dev` free. All three are worse to say
out loud. Listed for completeness, not recommended.

## Top 3

1. **Sounder.** The one I would ship. It types well, reads correctly cold, and the metaphor
   survives with no explanation. Drop it if the PyPI collision matters more than I think.
2. **Leadsman.** The better metaphor. The worse first impression. Take it if your audience
   enjoys a name that rewards knowing something.
3. **Dowse.** The best-shaped word of the three. Take it only if the pseudoscience reference
   reads as confident rather than careless.

**Boldest bet:** By the Mark. Phrase names are rare in developer tooling, so people remember
them. Phrases are also the one territory permutation tools cannot reach, which is why
availability there ran an order of magnitude above compounds. It costs you the clean binary
name.

**Safest bet:** Sounder on `sounder.dev`. GitHub org `sounder-dev`, npm `sounder`, Python
package published as `sounder-cli`.

## Check these yourself

- Search covered the names alone, not the name plus postgres. A collision inside the
  category could still exist. Check before you announce.
- `deadreckon.dev` is still unresolved from round 1. It is not available.
- No trademark search was run. That is fine for a hobby CLI. It stops being fine the day you
  charge for it.
- A GitHub result of `taken` means the org exists. Several are dormant accounts, which does
  not help. GitHub rarely releases them.
