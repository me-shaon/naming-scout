# Discovery

The interview exists to replace guessing. Every question here earns its place by changing
what gets generated. If a question would not change the output, do not ask it.

## Rules

**Batch.** Ask everything in one message, grouped and numbered. A naming interview
delivered one question at a time reads as an interrogation and people abandon it.

**Skip what you already have.** A user who writes "naming a Postgres query profiler for
backend engineers, wants it to feel like precision tooling, must be a `.com`" has answered
what, does, who, personality and domain mode. Ask about the remaining gaps only, confirm
your reading of the rest in one line, and generate.

**Offer defaults, do not demand decisions.** Most people naming something have no opinion
about clearance profiles or aftermarket domains until you show them the tradeoff. Propose,
explain in one line, let them override.

**Stop when you can generate.** If two more answers would only refine, generate first and
refine after. Showing territories is a faster way to elicit taste than asking about it.

## The core six

### 1. What is being named

The answer sets the clearance profile, the length tolerance, and the format risk.

company · product inside an existing company · SaaS · mobile app · CLI tool · developer
library or package · API or infrastructure service · newsletter · podcast · media or
content brand · community · agency or consultancy · course or education product ·
event or conference · open-source project · something else

Each carries different constraints. A CLI wants short and typeable. A newsletter can carry
a phrase. A library must survive an `import` statement. An agency name will be said in a
sales call for a decade.

### 2. What it does

One or two sentences, mechanism first. "Watches your Postgres slow-query log and tells you
which index is missing" is usable. "AI-powered database optimization platform" is not: it
contains no imagery, no tension, and no verb you can build a metaphor on.

If the user gives you marketing language, ask what actually happens when someone uses it.

### 3. Who it is for

Not a demographic. Ask who says the name out loud, and to whom. A name a developer types
into a terminal has different requirements from one a founder pitches to a VC, or one a
reader forwards to a colleague.

Ask about sophistication: an audience that knows the category will read a subtle metaphor.
A general audience will not. For them the name has to do less work.

### 4. Positioning

Two parts, and the second matters more:

- **Category.** What shelf does it sit on.
- **The wedge.** What is it instead of, and why would someone switch. What does it refuse
  to be.

The wedge is where distinctive names come from. "Analytics tool" generates nothing.
"Analytics for people who hate dashboards" generates a whole territory.

### 5. Personality

Give the list, let them pick two or three, and ask for one existing brand whose *tone* they
admire (in any industry). The comparison brand is the single highest-signal answer in the
whole interview, and it takes them five seconds.

serious · technical · premium · playful · irreverent · trustworthy · scientific · bold ·
minimalist · quirky · warm · austere · nostalgic · confident

Ask what tone would be *wrong*. People are much more precise about what they hate.

### 6. Constraints and style

- Length target, in syllables or characters
- Must survive being spelled aloud, or not
- Words, roots, letters, or associations to avoid, and any incumbent it must not echo
- Languages and regions it has to work in, and any it must not be offensive in
- Style preference: real word · compound · metaphor · coined · abstract brandable ·
  descriptive · imperative or phrase · no preference

"No preference" is a fine answer and often the right one. Generate across styles and let
the shortlist reveal the taste.

## The two decisions that shape the second half

### Domain mode

Ask directly, in plain language, not in jargon:

- Does it have to be a `.com`, or are other endings fine?
- Do you only want names nobody has registered, or would you buy one that is already
  taken if the price is reasonable?
- Is there a number above which you would walk away?

Map the answer to a mode from `domain-states.md`:

| Mode | Means |
|---|---|
| A. Strict | show only names not in the registry |
| B. Available + alternates | unregistered on `.com` or on a sensible alternate TLD |
| C. Include parked | show registered-but-parked names, labelled as registered |
| D. Include aftermarket | show names listed for sale, with the listing surfaced |
| E. Broad | everything, ranked and labelled by state |

Most people say `.com` reflexively and change their mind once they see what a good name in
mode D costs versus what an available name in mode A looks like. Show them both rather than
arguing about it.

### Clearance profile

Do not read the user a list of ecosystems. Propose a profile from what they are naming,
name the checks in one line, and offer to add or drop:

> For a Python library I would check the domain, GitHub, and PyPI, plus a quick search for
> an existing project with the name. Trademark and app stores are not worth the time here
> unless you plan to commercialise it. Want me to add anything?

Profiles and what each check can actually establish: `clearance-guide.md`.

## When the user brings their own name

A common request is "is `X` available" rather than "give me names". Handle it as:

1. Run the brand filter on the name they have and say plainly whether it holds up.
2. Run the clearance profile.
3. If the name is weak, or the clearance comes back badly, offer alternatives in the
   territory their name already belongs to. They chose that territory for a reason, and it
   is the fastest path to a name they will accept.

Do not skip step 1. The most useful thing you can tell someone about a name they are
attached to is a specific weakness they had not noticed, delivered before they find out
the domain costs $8,000.

## When the brief is genuinely thin

If the user will not or cannot answer, say what you are assuming and generate anyway:

> Going with: developer audience, technical-but-not-corporate tone, `.com` preferred but not
> required. Here are four territories. Tell me which two feel right and I will go deep.

Territories are a faster interview than questions. A user who cannot describe the tone they
want will recognise it instantly in a list.
