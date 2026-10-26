# Gap Report Template

Used by `find-requirement-gaps`. Place in the skill's `assets/` folder. Replace this file to use a different template.

## Format

```
GAP REPORT — <App Name> · #<GitLab issue>
Sources: S1 = GitLab #<issue> (<date>), S2 = <Drive doc name> (<date>), ...

<SCREEN / FEATURE>
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
```

## Rules

- **Type**: Missing, Unclear, Conflicting, Assumption
- **Impact**: High (blocks dev/test), Medium, Low
- Gap IDs (G-01, G-02…) continue across sections.
- One gap per row; every row cites its source and location.

## Example

```
GAP REPORT — ABC Application · #412
Sources: S1 = GitLab #412 (Aug 02), S2 = ABC PRD on Drive (Aug 01)

AUTHENTICATION
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
| G-01 | Missing | Sign-up flow not defined — in scope? | S2 §Auth | High |

HOME
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
| G-02 | Conflicting | S2 lists 3 Home tabs, S1 comment says 4 | S2 §Home, S1 comments | Medium |
```
