# Domain states

Registrar search boxes collapse registered, premium, and aftermarket into one red X, and
put a $10 name next to a $2,000 name without making the difference obvious. This skill does
not, because the difference is usually the actual decision.

## Why RDAP

RDAP is the registry's own protocol. `scripts/rdap.sh` asks the registry operator directly,
so the answer is the authoritative one rather than a registrar's rendering of it.

```
https://rdap.verisign.com/com/v1/domain/EXAMPLE.COM
  404 -> not in the registry
  200 -> in the registry, whatever is or is not served at the address
```

TLD-to-server mapping comes from the IANA bootstrap file, cached for a week:
`https://data.iana.org/rdap/dns.json`.

A side effect worth knowing: the query goes to the registry, not to anyone selling
domains, so no registrar sees what you searched for.

## States

| State | Means | Buy it? |
|---|---|---|
| `available` | 404 from an authoritative RDAP server. Not in the registry. | Yes, at registration price. |
| `registered` | 200. Someone holds it. Might be a live business, might be dormant. | Only via an approach to the holder. |
| `parked` | 200, nameservers belong to a parking/monetisation host. No real site. | Sometimes. Often held for ad revenue and not listed. |
| `for_sale` | 200, nameservers belong to a marketplace (Afternic, Sedo, Dan, HugeDomains…). | Yes, at the listed price. |
| `reserved` | Registry marks it reserved or blocked. | No. |
| `unknown_no_rdap` | No verified RDAP server for that TLD. | **Unresolved. Not a negative result.** |
| `unknown_error` | Rate limited, timed out, or server error. | **Unresolved. Not a negative result.** |
| `invalid` | Not a legal DNS label. | n/a |

The two `unknown_` states exist so that a failure can never be silently reported as a
success. Print them as unknown, count them separately, and tell the user what was not
resolved.

## What the states do not tell you

**Price.** RDAP has no price field. For `available`, `.com` is registration price, but many
new gTLDs have registry premium tiers where an unregistered name still costs hundreds a
year. For `for_sale`, the listing price has to be read from the marketplace.

**Whether a `for_sale` price is sane.** Marketplace listings include $50 names and $50,000
names with no signal in the DNS to distinguish them.

**Whether a `registered` holder would sell.** Many would. Registration date and registrar
hint at it: a 2003 registration on a business registrar with real nameservers is a live
business; a 2024 registration on a bulk registrar with parking nameservers is inventory.

**Trademark exposure.** Completely orthogonal. A free domain can still be an infringement.

## The heuristic that inverts

The instinct is: no website at that address, so nobody wants it.

The source research tested this. A model produced 12 names cleared on the reasoning "I
could not find an indexed website for these, which is promising". Live RDAP: **all 12 were
registered**, several since 2004 and 2013. The one name it advised against was the one that
was actually free.

"No indexed website" means parked or private, and parked is exactly what squatter-held
inventory looks like. For a short, brandable domain the heuristic runs backwards: no
indexed site raises the probability that it is expensively held, not that it is free.

**Never report availability from search results, from a model's recollection, or from a
page failing to load. Only from a registry response.**

## Modes

Set during discovery, applied when filtering results.

**A. Strict availability.** Only `available`. Right for someone who wants to register today
and move on. Costs quality: the best name in the run is often registered.

**B. Available plus alternates.** `available` on `.com` or on a sensible alternate TLD.
Pick alternates that fit the thing being named. `.dev`, `.sh`, `.io` read as native to
developers; `.co` and `.app` are broadly acceptable; `.xyz` and `.link` carry a discount
signal for a company but are fine for a side project.

**C. Include parked.** Adds `parked`, labelled as registered throughout. Useful for someone
willing to send an enquiry email. Set the expectation: many parked holders never reply,
and those who do often open high.

**D. Include aftermarket.** Adds `for_sale`, with the marketplace named. This is where the
best names usually are. Establish a walk-away number before showing prices, or every
conversation becomes about the domain rather than the name.

**E. Broad discovery.** Everything, grouped by state, ranked by name quality inside each
group. The default when the user has not decided, because it shows the tradeoff instead of
describing it.

Never flatten these into available/unavailable. The whole point is that
"registered, parked, on Afternic, 2024 registration" and "registered, in use by a company
since 2004" are different answers to the same question.

## Alternate TLD notes

`.com` still carries the strongest default-trust signal, and people type it by reflex when
they half-remember a name. That is a real cost of not having it, and it is the only real
cost. Plenty of substantial companies run on `.io`, `.dev`, `.ai`, `.so` and `.co`.

Watch for:

- **`.co`** is one keystroke from `.com`. Expect to lose some traffic permanently.
- **`.ai`** currently prices well above `.com` and reads as a specific claim about what
  the product is.
- **Country-code TLDs used as words** (`.sh`, `.gg`, `.to`, `.tv`, `.io`) are subject to a
  national registry's policy, which can change.
- **Registry premium pricing** on new gTLDs. `available` there does not mean $12.

## Verified RDAP coverage

`rdap.sh` resolves TLDs from the IANA bootstrap first. When the bootstrap has no entry — or
the bootstrap fetch itself fails on a cold cache — it falls back to a small hand-verified
list covering `.io`, `.me`, `.sh`, `.tv`, `.com`, `.net` and `.org`.

Some TLDs, `.co` among them, have no RDAP server this skill can verify. They return
`unknown_no_rdap`. Confirm those with `whois` or a registrar, and label the result as the
lower-confidence check it is.

With no network at all, every lookup returns `unknown_error` after four attempts. Nothing
is ever reported as available on a failed request.

Do not add a fallback entry without testing the candidate server against **both** a
known-registered domain and a known-free one. A server that 404s on registered domains
manufactures false availability, which is the worst failure this tool can have. During
development, `rdap.org` returned 404 for `github.io`, and a plausible-looking `.gg` server
404'd for `nic.gg`. Either would have produced confident, wrong "available" results.
