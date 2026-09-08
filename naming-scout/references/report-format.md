# Report format

The report is the deliverable. It should be readable in five minutes and defensible in a
conversation with someone who disagrees.

**It ships as an HTML page, not as terminal text.** Build the JSON described by
`scripts/report.sh --schema`, render it, and it opens in the browser:

```bash
scripts/report.sh report.json
```

`examples/report-data.example.json` is a complete payload from a real run. The sections
below describe what goes in each field; the page lays them out, colour-codes every state,
and hides anything you leave empty.

In the terminal, say only your recommendation and the one thing that would change it, then
give the path. The page carries the detail.

## Sections

### 1. Brief

Three or four lines of what you worked from, including the assumptions you made where the
user did not answer. This is where a misunderstanding gets caught before it costs the user
a decision.

### 2. Territories

Each territory: what it is, why it fits this brief, and its availability rate.

```
Navigation  — instruments for finding your way when the obvious signal fails.
              Fits because the product's job is orientation, not measurement.
              12/26 available (46%). Unmined.

Reference   — the product as a book you keep on the desk.
              Fits the teaching half of the positioning.
              3/24 available (13%). The umbrella words are gone everywhere.
```

The rates are one of the more useful things in the report. They tell the user which
directions still have room, which is exactly what they need if they reject the shortlist.

### 3. Shortlist

8–15 candidates, ranked. Each entry:

```
**Lodestar**
Territory:  Navigation
Why:        A lodestar is what you steer by when the instruments fail, which is the
            product's actual job for a founder mid-decision. The word is old enough to
            read as established rather than trendy, and it survives being said aloud in
            a boardroom without explanation.
Weakness:   One of the more reached-for navigation words. Two other companies use it in
            adjacent categories, so it will not feel uniquely yours in year one.
.com:       registered 2001, in use — a US consultancy
Alternates: lodestar.dev available · uselodestar.com available
GitHub:     free · npm: taken (stub package, last publish 2016)
Search:     dominated by the consultancy on the exact term
Verdict:    Strong name, contested namespace. Worth it only if you will run on .dev.
```

Non-negotiable: **every entry has a stated weakness**. An entry with no weakness has not
been examined, and it reads as sales copy.

Cut the entry down to what is relevant. A newsletter shortlist has no GitHub line.

### 4. Top 3

Three names with a sentence each on why they are top, plus the one thing that would make
you drop each. Say which you would pick and why. A recommendation the user can argue with
is more useful than a menu.

### 5. Best unconventional option

The name with the highest ceiling and the highest risk. Usually from the territory the user
would not have asked for: an imperative, a coined word, a phrase, something that needs a
tagline. Say plainly what it demands from them, because it is usually more marketing work
in exchange for a name nobody else could have.

Omit the section if the run genuinely produced nothing unconventional, and say so rather
than promoting a safe name into the slot.

### 6. Safest option

Lowest clearance risk, cleanest namespace, least explanation cost. Often not the most
exciting name, and that is the point: it is the answer to "I need to ship next week".

### 7. What was not verified

Explicit, not a footnote:

```
- .co results are unresolved: no RDAP server this tool can verify. Confirm at a registrar.
- Trademark: searched live US marks in classes 9 and 42, no obvious conflict. Not a
  clearance opinion. Get an attorney search before you spend on the brand.
- Social handles not checked. Status codes are unreliable enough that I would rather you
  open the signup pages than trust a number from me.
- 3 domain lookups returned rate-limit errors and are unknown, not available:
  <names>. Re-run scripts/rdap.sh to resolve.
```

## Tone

Write as an advisor who will be held to it.

- "Registered since 2004 by a live consultancy" beats "unavailable".
- "This needs a tagline to mean anything" beats "highly brandable".
- "I would pick Lodestar and run it on .dev" beats presenting three options equally.

Avoid: clean, modern, sleek, catchy, memorable, powerful, versatile, and any adjective that
would apply equally to a different name. Every claim should be falsifiable.

## Length

The report should be as long as the number of names you would defend, and no longer. A
run that produced six good names produces a six-name report. Padding it to fifteen with
material you would cut in conversation is the single fastest way to make the whole thing
feel machine-generated.

If you cannot fill a shortlist you believe in, say so and run another round in a different
territory. That is a better outcome than a long list of near-misses.
