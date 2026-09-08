# naming-scout

Research and source for **Naming Scout**, a Claude Agent Skill that finds names worth using
and then checks whether you can actually use them.

- **[`naming-scout/`](naming-scout/)** — the skill. Copy it to `~/.claude/skills/` and start
  describing what you are naming. Full documentation in
  [`naming-scout/README.md`](naming-scout/README.md).
- **[`00-domain-research.md`](00-domain-research.md)** — the naming run the method came from:
  ~400 candidates, six rounds, availability rate as a signal.
- **[`01-naming-scout.md`](01-naming-scout.md)** — the original spec and the honest
  assessment of it as a product.

## Install

```bash
cp -r naming-scout ~/.claude/skills/
```

Needs `curl` and `jq`.
