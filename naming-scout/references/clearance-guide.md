# Clearance guide

Clearance answers "can this name be used", which is a different question from "is the
domain free". Run only the checks the project needs, and report each one at the confidence
its method actually supports.

## Profiles

Defaults, not rules. Propose one, explain it in a line, let the user change it.

| Profile | Checks | Skip |
|---|---|---|
| **Open-source library** | domain, GitHub, the relevant registry (npm / PyPI / crates / RubyGems / Maven / NuGet), search | trademark, app stores, most socials |
| **Developer tool or CLI** | domain, GitHub, npm + PyPI (name collisions bite even if you never publish), Homebrew formula, search | app stores, trademark unless commercial |
| **Technical product / SaaS** | domain, GitHub org, search, trademark, one or two socials | package registries unless shipping a client library |
| **Consumer product or app** | domain, app stores, trademark, socials, search | package registries, GitHub |
| **Company** | domain, trademark, search, socials, business registry in the home jurisdiction | package registries, app stores |
| **Newsletter / media / podcast** | domain, socials, search, podcast directories if audio | package registries, app stores, GitHub |
| **Community** | domain, socials, Discord/Slack vanity, search | package registries, app stores |
| **Agency / consultancy** | domain, trademark, search, LinkedIn, local business registry | everything technical |
| **Course / education** | domain, socials, search, marketplace listings | package registries, app stores |

Adjust on the specifics rather than the label. A newsletter that will ship a CLI later
should check npm now, and it costs one call. A hobby project does not need trademark work.

## Automated checks

`scripts/clearance.sh --checks github,npm,pypi,crates,rubygems,dockerhub NAME...`

| Check | Method | Confidence | Notes |
|---|---|---|---|
| GitHub org/user | `api.github.com/users/NAME` | High | 60 req/hr unauthenticated. Export `GITHUB_TOKEN` for 5000. A 403 is `unknown`, not free. |
| npm | `registry.npmjs.org/NAME` | High | Also check the scoped form if the user plans `@org/name`. |
| PyPI | `pypi.org/pypi/NAME/json` | High | PyPI normalises `-`/`_`/`.` and case, so `my-tool` and `my_tool` collide. |
| crates.io | `crates.io/api/v1/crates/NAME` | High | Crates use `_`, not `-`. |
| RubyGems | `rubygems.org/api/v1/gems/NAME.json` | High | |
| Docker Hub | `hub.docker.com/v2/users/NAME` then `/v2/orgs/NAME` | High | The `/repositories/` endpoint returns 200 for every name and cannot be used. |

Registries not automated, and how to check by hand: Maven Central (`search.maven.org`,
groupId matters more than artifactId), NuGet (`nuget.org/packages/NAME`), Packagist
(needs `vendor/package`, so check the vendor namespace), Go (no registry at all: check
`pkg.go.dev` and the module path you would use), Homebrew (`brew search NAME`).

## Checks with no reliable API

These four need judgment, and every one of them is a place where an overconfident answer
does real damage.

### Trademark

The check with the most real-world consequence, and the one no naming tool bundles.

What you can do: search the relevant public registers, which for most users means USPTO
TESS/`tmsearch.uspto.gov` (US), EUIPO eSearch (EU), and the UK IPO. Look for live marks in
the classes the user's product would fall into, and for confusingly similar marks, not only
identical strings.

What you can report:

> No obvious conflict found in a search of live US marks for this term. This is not a
> clearance opinion and does not cover common-law rights, pending applications not yet
> published, foreign registrations, or confusingly similar marks I did not think to search.

What you must never write: "trademark is clear", "no trademark conflict", "safe to use",
or anything a reader could take as legal advice.

Escalate explicitly. If the user is launching commercially, raising money, or spending on
the brand, tell them a trademark attorney's clearance search is the step that actually
protects them, and that it is cheap relative to a rebrand.

Names most likely to be a problem: anything close to an established mark in an adjacent
category, common words used in the sense the incumbent uses them, and anything that sounds
like a larger company when spoken. Flag those in the report even when the search comes back
empty.

### Social handles

Status codes lie here, in both directions. Bot detection, login walls, geographic blocks,
and soft-reserved handles mean a 404 is usually trustworthy and a 200 often is not.

Report as `probably free`, `taken`, or `uncertain`, never as a verified state. Say which
platform gave which answer and that the method is unreliable.

Do not build handle checking into the scripts. It would produce a confident-looking column
of wrong answers, which is worse than no column. If the user needs certainty, the honest
answer is to open the signup page.

Practical guidance worth more than the check itself: pick a handle pattern you can hold
across platforms (`getname`, `nameapp`, `name_hq`) and accept that the bare handle is gone
on the older platforms for any real word.

### App stores

Search the App Store and Google Play for the name and for close variants. Both stores
enforce name uniqueness at listing time and both reject names that infringe existing marks,
so a collision here is a hard blocker for a mobile product and irrelevant for everything
else.

An app with the same name in a different category is usually survivable. An app with the
same name in the same category is not.

### Search presence

Search the name alone, and the name plus the category. You are looking for: an existing
company that owns the term, an established meaning that fights the positioning, and how
hard it would be to rank.

Absence of results is weak evidence of anything. It means the term is not indexed, which is
also true of every name held privately, every pre-launch company, and every brand too new
to have coverage. Report search as a signal, never as a verdict, and never treat it as
availability. The source research has a worked case of exactly that mistake:
`domain-states.md`.

## Reporting

For each check, give the state, the confidence, and where it came from:

```
GitHub org   free       high     github.com/lodestar unclaimed
npm          taken      high     npmjs.com/package/lodestar (last publish 2019)
Trademark    no obvious conflict  low   searched live US marks, classes 9 and 42
X handle     uncertain  low      profile page returned 200 behind a login wall
```

Three rules:

1. Never let `unknown` render as free. Rate limits and blocks are unknowns.
2. Never present a low-confidence check with the same weight as a high-confidence one.
3. Say what you did not check and why, so the user knows the shape of the gap.

An abandoned npm package from 2019 blocking a name is a fact worth reporting alongside the
status: it is technically taken, and in practice it may still be a problem for discovery
even though the name cannot be published under.
