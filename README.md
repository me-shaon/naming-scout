# naming-scout

**Naming Scout** is a Claude Agent Skill. It finds names worth using, then tells you the
truth about whether you can use them.

Concept clustering instead of keyword permutation, registry-level RDAP instead of registrar
search boxes, and an HTML report that opens in your browser.

Full documentation: **[`naming-scout/README.md`](naming-scout/README.md)**

## Install

```bash
cp -r naming-scout ~/.claude/skills/
```

Needs `curl` and `jq`.

## Use

Describe what you are building:

> I'm building a budgeting app for freelancers. The problem is irregular income. You make
> £9k one month and £900 the next, so normal budgeting apps are useless. We smooth it out
> and tell you what you can safely pay yourself each month. Need a name.

It interviews you, works through metaphor territories, checks only what your project needs,
and opens a report in your browser. Worked runs for a startup, a consumer brand, a
newsletter, a funded B2B company and a developer tool are in
[`naming-scout/examples/`](naming-scout/examples/).
