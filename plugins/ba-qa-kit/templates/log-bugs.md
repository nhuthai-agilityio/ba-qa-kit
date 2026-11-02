# Bug formats

Used by `/ba-qa-kit:log-bugs`: the bug, the incident record and the lessons file.

## Bug template
```
### [Bug] <what is wrong, where>
Ticket: #<n> | Env: <dev / stag> | Round: <round> | Severity: <level> | Reproduced by hand: Not yet – QA to confirm

Preconditions
- <logged in as ...>
- <data needed>

Steps
1. ...
2. ...

**Expected:** <result> (source: <AC / rule ID / design / standard / assumed, not in AC>)

**Actual:** <result>

**Evidence:** <screenshot>, <console errors>, <failed requests>

**Related test case:** <TC ID> (<test case>) in <link to the QA test cases sub-issue of the version that was run>

**Found by:** /ba-qa-kit:verify, Round <round>

---
For QA (<qaAssignee>)
1. Run the steps by hand.
2. Real bug: assign this issue to a developer.
3. Not a bug (the verify run or the test case was wrong): tell Claude with `/ba-qa-kit:log-bugs review #<this issue>`.
4. Source is "assumed, not in AC"? Confirm the Expected with the PO. Write this step only for such a bug.
```

## Incident record template
```
# Incident record <ticket>-<NN>: <short title>
Date: <YYYY-MM-DD> | Ticket: #<n> | Env: <env> | Round: <round>
Bug issue: #<n> | Test case: <TC ID> | Cause: <test case / verify run / environment / tool limit / PO rule>

## What happened
<what verify or the test case did, and what it reported>

## Why
<the real cause, and what QA saw by hand>

## Fix
<what was done: bug closed, case run again in Round <n>, test case updated>

## How to avoid
<one clear rule for next time>
Added as lesson L-<NNN> in `qa-lessons.md`.
```

## Lessons file
`<outputDir>/qa-lessons.md`. `/ba-qa-kit:write-test-cases` and `/ba-qa-kit:verify` read it before they start.
```
# QA lessons
| ID | Applies to | Feature | Lesson | Incident record | Added |
|---|---|---|---|---|---|
| L-001 | verify | <feature> | <what to do next time> | `incidents/<ticket>-incident-<NN>.md` | <YYYY-MM-DD> |
```
