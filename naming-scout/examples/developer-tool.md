# Example: developer tool (CLI)

Shows: GitHub/npm/PyPI clearance mattering, availability rate driving a TLD decision, and
short single words being gone as GitHub orgs.

*Checks run 2026-09-08. Domain and namespace states change. Re-run before deciding.*

---

**User:** I need a name for a CLI that reads your Postgres slow-query log and tells you
which index is missing. For backend engineers. Should feel like precision tooling, not a
startup.

**Scout:** Enough to work from. Three things before I generate:

1. `.com`, or is a developer-native TLD fine? `.dev` and `.sh` read as native to this
   audience and are far less mined.
2. Will you publish it as a package? If yes, which ecosystems — npm, PyPI, both?
3. Length: it gets typed a lot. Aiming for one word under 8 characters, or is a two-word
   compound acceptable?

**User:** `.com` would be nice but I'm not precious. Probably a Go binary with a Homebrew
tap, but I'd like npm and PyPI free so I can add installers later. Short is better.

**Scout:** Clearance profile: domain (`.com`, `.dev`, `.sh`), GitHub org, npm, PyPI, and a
search pass. Skipping trademark and app stores — no commercial launch, no mobile.

## Territories

The product's job is *finding the hidden expensive thing in a system you cannot see into*.
That is not a database metaphor, it is a depth metaphor.

- **Depth sounding** — the instruments sailors used to find the bottom before sonar. A
  weighted line dropped into water you cannot see through. Maps almost exactly.
- **Diagnostics** — vitals, triage, symptoms. Fits, but every observability tool is here
  already, so expect to sound like the category.
- **Divining** — finding water underground. Slightly mystical, which cuts against
  "precision tooling", but generates well.
- **Craft/sharpening** — whetstone, hone, grindstone. Fits "make the slow thing fast".
- **Cartography of the plan tree** — atlas, contour, seam.

## Round 1 — 24 names across all five, checked on `.com` and `.dev`

```
.com   1 / 24 available   (4%)
.dev  14 / 24 available   (58%)
```

That 4% is the finding. Real-word compounds on `.com` are exhausted — this is not about
these particular names, it is that every English compound of two common words was
registered between 1995 and 2010. `whetstone.com` 1995, `waterline.com` 2000,
`soundings.com` 1995.

The decision this forces: either move to `.dev`/`.sh`, or accept the aftermarket. For a CLI
whose users live in a terminal, `.dev` costs almost nothing in credibility.

Notable round-1 results:

```
slipstream.com   for_sale     1996   BrandBucket listing
honestone.com    for_sale     2002   Sedo parking
apexline.com     for_sale     2019   Afternic
whetstone.dev    for_sale     2026   Afternic  (registered and flipped this year)
deadreckon.dev   unknown      —      429 after 4 attempts, unresolved
```

`deadreckon.dev` is unresolved, not available. Google's registry rate-limited it.

## Round 2 — going deeper in depth sounding

Rate held: `.com` 1/22, `.dev` 11/22. Same conclusion, more confidently.

## Round 3 — the strongest stems, short forms

```
leadsman.dev    available     leadsman.sh   available     leadsman.com   registered 1999
bythemark.dev   available     bythemark.sh  available     bythemark.com  registered 2008
sounder.dev     available     sounder.sh    available     sounder.com    registered 1995
dowse.dev       available     dowse.sh      available     dowse.com      registered 1999
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

Every single-word GitHub login is claimed. That is the norm, not bad luck: GitHub logins for
real English words went years ago, and most are squatted or dormant. Plan on `leadsman-dev`,
`getleadsman`, or a personal-account repo. It is not a blocker for a CLI, where the install
command and the binary name matter more than the org slug.

## Shortlist

**Leadsman** — *Depth sounding*
The leadsman is the crew member who drops the weighted line and calls the depth. That is
precisely this tool's role: not the navigator, the person who reports what is under you.
Two syllables, spells itself, no collision in developer tooling.
*Weakness:* the reference is invisible unless you know it. Non-nautical users hear "lead"
as sales lead first, which is an unfortunate first association in a B2B-adjacent space.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI free · GitHub taken

**By the Mark** — *Depth sounding*
The leadsman's actual call: "by the mark, twain" — the depth read off the knots. It names
the output rather than the operator, which is the more accurate framing for a reporting
tool. Highest ceiling here.
*Weakness:* three words. As a CLI binary it has to collapse to `bythemark` or `btm`, and
neither is good. Better suited to a hosted product than a terminal command.
`.dev` free · `.sh` free · `.com` registered 2008 · npm free · PyPI free

**Sounder** — *Depth sounding*
The instrument itself, and a real word an engineer reads correctly on first sight. Shortest
of the three, best as a typed command: `sounder analyze`.
*Weakness:* also a bird, also an audio device, and "sounder" reads as a comparative
adjective ("sounder judgment") on first pass. PyPI is taken, so a Python installer needs a
different distribution name.
`.dev` free · `.sh` free · `.com` registered 1995 · npm free · **PyPI taken** · GitHub taken

**Dowse** — *Divining*
Five letters, one syllable, unclaimed on both developer TLDs, and the metaphor is exactly
right: finding what is underground by reading surface signals.
*Weakness:* dowsing is pseudoscience. For a tool selling itself on precision, naming it
after the archetypal unscientific method is a real tension. Some engineers will read it as
a joke, which may be fine or may be fatal depending on how serious the positioning is.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI taken (as `dowser`)

**Plumbrod / Soundingline / Keelline** — same territory, `.dev` free, all weaker on the
say-aloud test. Listed for completeness, not recommended.

## Top 3

1. **Sounder** — the one I would ship. It types well, reads correctly cold, and the
   metaphor survives without explanation. Drop it if the PyPI collision matters more than
   I think.
2. **Leadsman** — better metaphor, worse first impression. Pick it if your audience skews
   toward people who enjoy a name that rewards knowing something.
3. **Dowse** — best shape of all three. Pick it only if the pseudoscience association reads
   as confident rather than careless in your positioning.

**Best unconventional:** By the Mark. A phrase name in developer tooling is rare enough to
be memorable, and phrases are the one territory permutation tools cannot reach — which is
why `.com` availability there ran an order of magnitude higher than for compounds. It costs
you the clean binary name.

**Safest:** Sounder on `sounder.dev`, GitHub org `sounder-dev`, npm `sounder`, Python
package published as `sounder-cli`.

## Not verified

- Search pass done on the names alone, not on "name + postgres". A same-category collision
  could still exist; check before you announce.
- `deadreckon.dev` from round 1 is still unresolved (rate limit), not available.
- No trademark search. Correct for a hobby CLI, wrong the moment you charge for it.
- GitHub `taken` results are org existence only. Several are dormant accounts, which does
  not help — GitHub rarely releases them.
