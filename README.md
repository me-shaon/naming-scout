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

Describe what you are naming:

> Name a CLI that reads your Postgres slow-query log and tells you which index is missing.
> Backend engineers. Should feel like precision tooling, not a startup.
