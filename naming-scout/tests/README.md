# Tests

Two layers, because the skill has two kinds of failure.

## `run.sh`, the deterministic layer

Scripts, the report renderer, and docs consistency.

```bash
./tests/run.sh              # offline. no registry traffic. run this on every change.
./tests/run.sh --network    # adds ~20 live RDAP lookups against known-taken domains.
```

Exit status is the failure count.

The network suite guards one specific disaster: an RDAP server that returns 404 for a
domain that is actually registered, which turns into a confident "available" and sends
someone off to register a name they cannot have. Every control in it is a domain known to
be taken. Run it after touching the server map or the override list.

## `cases/`, the judgement layer

Nine briefs covering the paths that behave differently: each project type, a user who
arrives with a name already, a non-English market, and a first direction that fails. Each
case says what the run must do and what fails it. Grade against `rubric.md`.

This layer is manual on purpose. It catches naming that is generic, checks that were run
for no reason, and confidence the evidence does not support. None of that is greppable.
