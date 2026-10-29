# Setup Checklist Template

Used by `setup`. Replace this file to use a different checklist.

## Format

```markdown
Setup · <BA / QA / both>

Access
- <✔ / ✖ / ○> glab: <logged in, can write / logged in, read only / not logged in: <fix> / not installed / host not reachable: VPN?>
- <✔ / ✖ / ○> Chrome: <answers / not started with --chrome>
- <✔ / ✖ / ○> Board: <readable / not readable: <why>>

Profile in CLAUDE.md: <written / unchanged / not written>
Still to answer: <the ?: lines in plain words, or "nothing">
Labels missing on the board: <list, or "none">
Warnings: <milestones with no end date or ended and still open, or "none">
```

## Rules

- ✔ ready, ✖ missing, ○ not needed for this job.
- Keep it under 15 lines. No secrets, no personal data, no production URLs.

## Example

```markdown
Setup · both

Access
- ✔ glab: logged in, can write
- ✖ Chrome: not started with --chrome (needed for /ba-qa-kit:verify)
- ✔ Board: readable

Profile in CLAUDE.md: written
Still to answer: stag URL, release note build links
Labels missing on the board: test case, passed, not-a-bug
Warnings: ABC - SPR 4 has no end date
```
