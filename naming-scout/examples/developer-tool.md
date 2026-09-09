# Example: developer tool (CLI)

GitHub, npm and PyPI decide the answer. Availability rate decides the TLD. Short real words
turn out to be gone as GitHub orgs.

*Checks run 2026-09-08. Re-run before deciding.*

---

**User:** I need a name for a CLI that reads your Postgres slow-query log and tells you which
index is missing. For backend engineers. Should feel like precision tooling, not a startup.

**Scout:** Three things first:

1. Does it have to be `.com`, or is a developer TLD fine? `.dev` and `.sh` read as native here
   and are far less mined.
2. Will you publish it as a package? Which ecosystems?
3. It gets typed a lot. One word under 8 characters, or is a compound acceptable?

**User:** `.com` would be nice but I'm not precious. Go binary with a Homebrew tap, but I'd
like npm and PyPI free for later installers. Short is better.

**Scout:** Checks: domain on `.com`, `.dev` and `.sh`, plus GitHub, npm, PyPI and a search
pass. No trademark or app stores. No commercial launch, no mobile.

## Territories

The tool finds an expensive thing hidden inside a system you cannot see into. That is a depth
metaphor, not a database one.

- **Depth sounding.** The instruments sailors used before sonar. A weighted line dropped into
  water you cannot see through.
- **Diagnostics.** Vitals, triage, symptoms. Fits the job. Every observability tool already
  lives here, so the names sound like the category rather than like you.
- **Divining.** Finding water underground by reading the surface. Fights the precision
  positioning.
- **Craft and sharpening.** Whetstone, hone, grindstone.
- **Cartography.** Atlas, contour, seam. The query plan read as terrain.

## Round 1: 24 names, `.com` and `.dev`

```
.com    1 / 24 free    (4%)
.dev   14 / 24 free   (58%)
```

The 4% has nothing to do with these particular names. Every two-word compound of common
English words was registered between 1995 and 2010. `whetstone.com` in 1995. `waterline.com`
in 2000. `soundings.com` in 1995.

So the choice is `.dev` and `.sh`, or the aftermarket. For a CLI whose users live in a
terminal, `.dev` costs nothing in credibility.

```
slipstream.com   for_sale     1996   BrandBucket
whetstone.dev    for_sale     2026   registered and flipped this year
deadreckon.dev   unknown         -   429 after 4 attempts
```

`deadreckon.dev` did not resolve. Google's registry rate-limited it. Not the same as free.

## Rounds 2 and 3

Round 2 held the same rate: 1/22 on `.com`, 11/22 on `.dev`.

Round 3 tested the strongest stems as short words and added `.sh`.

```
leadsman    .dev free   .sh free   .com registered 1999
bythemark   .dev free   .sh free   .com registered 2008
sounder     .dev free   .sh free   .com registered 1995
dowse       .dev free   .sh free   .com registered 1999
plumb       all three registered
fathom      all three registered
```

## Namespace clearance

```
name        github   npm     pypi
leadsman    taken    free    free
bythemark   taken    free    free
sounder     taken    free    taken
dowse       taken    free    taken
plumb       taken    taken   taken
```

Every single-word GitHub login is claimed. Normal, not bad luck. Logins for real English words
went years ago and most sit dormant. Plan on `leadsman-dev` or a repo under your personal
account. It does not block a CLI, where the install command and the binary name matter more
than the org slug.

## Shortlist

**Sounder**
A sounder is the instrument that measures depth. Engineers read the word correctly the first
time. Shortest of the finalists and the best to type: `sounder analyze`.
*Weakness:* also a bird and a piece of audio equipment. Read cold it can land as a comparative
adjective, as in "sounder judgment". PyPI already holds the name.
*Searchability:* **contested**. Shares the term with a seabird and audio hardware. "sounder
postgres" is clean, so expect to lose the bare term for the first year.
`.dev` free · `.sh` free · `.com` registered 1995 · npm free · **PyPI taken** · GitHub taken

**Leadsman**
The leadsman drops the weighted line and calls out the depth. He is not the navigator. He
reports what is under you. That is this tool's job. Two syllables that spell themselves, and
no other developer tool uses the word.
*Weakness:* you have to know the word for the name to mean anything. Anyone who does not will
hear "lead" as a sales lead.
*Searchability:* **ownable**. Almost nothing else uses the word. The strongest search position
in the run.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI free · GitHub taken

**Dowse**
Five letters, one syllable, free on both developer TLDs. To dowse is to find what is
underground by reading the surface.
*Weakness:* dowsing is pseudoscience. This tool sells precision. Naming it after the
best-known unscientific method is a real conflict, and some engineers will read it as a joke.
*Searchability:* **contested**. Dowsing has a large existing body of results.
`.dev` free · `.sh` free · `.com` registered 1999 · npm free · PyPI taken as `dowser`

**By the Mark**
The leadsman's actual call. "By the mark, twain" is the depth read off the knots in the line.
It names the reading rather than the person taking it, which is what a reporting tool produces.
*Weakness:* three words. As a binary it collapses to `bythemark` or `btm`. Neither is good to
type. Better suited to a hosted product.
`.dev` free · `.sh` free · `.com` registered 2008 · npm free · PyPI free

## Top 3

1. **Sounder.** The one I would ship. Types well, reads correctly cold, and the metaphor
   survives with no explanation. Drop it if the PyPI collision matters more than I think.
2. **Leadsman.** Better metaphor, worse first impression. Take it if your audience enjoys a
   name that rewards knowing something.
3. **Dowse.** Best-shaped word of the three. Only if the pseudoscience reference reads as
   confident rather than careless.

**Boldest bet:** By the Mark. Phrase names are rare in developer tooling, so people remember
them. It costs you the clean binary name.

**Safest bet:** Sounder on `sounder.dev`. GitHub org `sounder-dev`, npm `sounder`, Python
package published as `sounder-cli`.

## Check these yourself

- Search covered the names alone, not the name plus postgres. A collision inside the category
  could still exist.
- `deadreckon.dev` is still unresolved from round 1. Not available.
- No trademark search. Fine for a hobby CLI. Not fine the day you charge for it.
- A GitHub result of `taken` means the org exists. Several are dormant, which does not help.
  GitHub rarely releases them.
