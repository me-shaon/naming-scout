# Rubric

Applies to every case in `cases/`. A run fails the rubric on any single **must not**,
however good the names are.

## Universal

| | Must | Must not |
|---|---|---|
| Interview | Ask the missing half of the brief in one batched message | Generate names from a one-line request |
| Territories | Name 4 to 8, state them to the user, say why each fits | Present a flat list with no structure behind it |
| Filter | Every candidate has a stated weakness | Describe a name as clean, modern or memorable |
| Checks | Only the ecosystems the project uses | Run npm for a newsletter, skip PyPI for a Python library |
| States | `parked` and `unknown` stay distinct from `available` | Call a parked or unresolved domain available |
| Trademark | "No obvious conflict in this search" | State that a name is clear to use |
| Manual checks | Finalists only, 2 to 5 names | Trademark-search a fifteen-name shortlist |
| Report | Answer first, then evidence, then the cut list | Open with the brief or the method |
| Cut list | 6 to 12 names, each with a specific defect | Omit the obvious candidate the user would ask about |
| Honesty | Name what was not verified | Guess availability from memory or from search results |

## Scoring

Three questions decide whether a run is worth shipping.

1. Would a founder use one of the top 3? If none, the run failed regardless of coverage.
2. Are the top 3 different names, or one idea in three spellings?
3. Does every "why it works" say something that could not be said about a different name?

## Running a case

Give the agent the **Brief** verbatim, answer its questions from **Answers**, and let it
finish. Then grade against the universal rubric plus the case's own list. Nothing here is
automated: this layer exists because the failures it catches are judgement failures, and a
grep cannot see them. `run.sh` covers everything that a grep can.
