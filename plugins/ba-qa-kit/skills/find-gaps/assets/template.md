# Gap Report Template

Used by `find-gaps`. Replace this file to use a different template.

## Format

```
GAP REPORT — <App Name> · #<ticket>
Sources: S1 = ticket #<n> (<Mon DD, YYYY>), S2 = <Drive doc name> (<Mon DD, YYYY>), ...

<SCREEN / FEATURE>
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
```

## Rules

- Dates in Sources: the last-updated date of the ticket or doc.
- **App Name**: the project name from the profile's Board line.
- No gaps: keep the header and Sources line, then write "No gaps found".
- **Type**: Missing, Unclear, Conflicting, Assumption
- **Impact**: High (blocks dev/test), Medium, Low
- Gap IDs (G-01, G-02…) continue across sections.
- Every screen/feature section repeats the table header.
- One gap per row; every row cites its source and location.

## Example

```
GAP REPORT — ABC Application · #412
Sources: S1 = ticket #412 (Aug 02, 2026), S2 = ABC PRD on Drive (Aug 01, 2026)

AUTHENTICATION
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
| G-01 | Missing | Sign-up flow not defined — in scope? | S2 §Auth | High |

HOME
| ID | Type | Finding | Source & location | Impact |
|---|---|---|---|---|
| G-02 | Conflicting | S2 lists 3 Home tabs, S1 comment says 4 | S2 §Home, S1 comments | Medium |
```
