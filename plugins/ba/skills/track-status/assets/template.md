# Status Report Template

Used by `track-status`. Replace this file to use a different template.

## Format

```markdown
# <App Name> – <Sprint> – Daily Status
Date: <Mon DD, YYYY> · Sprint ends <Mon DD> (<n> days left) · Since: <Mon DD>

## Summary
<n> tickets · <n> Done · <n> In progress · <n> To do · <n> Blocked · <n> Stale · <n> Sent back · <n> Late start
Progress: <done>/<total> done (<n>%) · <n>% of sprint time used · <On track / Behind>

## Needs action
| Issue | Type | Status | Why | Suggested action |
|---|---|---|---|---|

## Moved
- #<n> <title>: <from> → <to> (<Mon DD>)

## Done
- #<n> <title> (<Mon DD>)

## Questions holding work
| Question | Issue | Status | Action |
|---|---|---|---|
```

## Rules

- Summary: status counts (Done, In progress, To do) add up to the tickets total; Blocked, Stale, Sent back and Late start are flags and can overlap.
- **Progress**: one line per sprint. With several products, start each line with the sprint name (`KD - SPR 31: 6/10 done (60%) · …`). Behind = Done % more than 20 points under time used.
- **Needs action** order: Blocked, Sent back, Stale, Late start.
- **Questions** status: Pending, or Answered (ticket not updated).
- Type: Story (`[US-nn]`), Task or Bug.
- Drop empty sections, keep Summary. Nothing moved → one line "No change today."

## Example

```markdown
# HR App – Sprint 12 – Daily Status
Date: Nov 10, 2026 · Sprint ends Nov 14 (4 days left) · Since: Nov 9

## Summary
4 tickets · 1 Done · 2 In progress · 1 To do · 1 Blocked · 1 Stale · 1 Sent back · 0 Late start
Progress: 1/4 done (25%) · 56% of sprint time used · Behind

## Needs action
| Issue | Type | Status | Why | Suggested action |
|---|---|---|---|---|
| #134 | Story | Blocked | Pending Q2 | Check for a client reply |
| #136 | Story | Sent back | QA → In progress (Nov 10): A/C 2 failed | Ask dev if A/C 2 is clear |
| #137 | Task | Stale | No update since Nov 4 | Ask the assignee |

## Moved
- #136 [US-03] Manager can reject a request: QA → In progress (Nov 10)

## Done
- #135 [US-02] Manager can approve a request (Nov 10)

## Questions holding work
| Question | Issue | Status | Action |
|---|---|---|---|
| Q2 Sick leave notice | #134 | Pending 5 days | Check for a client reply |
| Q10 Sick leave limit | #137 | Answered (Nov 9), ticket not updated | Update the user stories, then the board tickets |
```
