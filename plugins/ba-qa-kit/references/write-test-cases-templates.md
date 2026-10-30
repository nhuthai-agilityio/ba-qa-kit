# Test case formats

Used by `/ba-qa-kit:write-test-cases`: the chat output, the test case file (also the description of the `QA test cases` sub-issue) and the summary file.

## Chat output
One ticket (6 lines max):
```
Ticket #<n> (<title>), v<k>: <x> test cases (<a> Auto, <m> Manual only, <b> Blocked)
Ticket gaps: <n> · PO questions: <n>
QA edits kept: <TC IDs or "none" or "cannot compare">
Full output: <outputDir>/<file>
Summary: <outputDir>/test-cases-summary.md
Posted: <sub-issue link>. Check it on the ticket, then tell me what to change.
```
More than one ticket: one table, then the summary path.
```
| Ticket | Version | Test cases | Gaps | PO questions | Posted |
|---|---|---|---|---|---|
| #12 (<title>) | v1 | <x> (<a> Auto, <m> Manual only, <b> Blocked) | <n> | <n> | <sub-issue link> |
| #18 (<title>) | – | Skipped: no AC | – | – | – |
Summary: <outputDir>/test-cases-summary.md
```

## Test case file
```
# QA test cases – Ticket #<n>: <ticket title> (v<k>)
Date: <YYYY-MM-DD> | Sources: <ticket link>, <doc links> | Based on: <v<k-1> sub-issue link, or "new">
Screens not built yet: <list or "none">

## 1. Ticket gaps
What the ticket does not say well enough to test. These are not app bugs.

| # | What is unclear | Why it matters for testing | What to do | Source |
|---|---|---|---|---|
| G1 | <plain words> | <plain words> | Add an AC / Ask PO (PO-<n>) / Assumed (see TC-<n>) | [<rule ID or doc>](<link>) |

## 2. Shared setup
Steps that many test cases use. A test case writes "Do S1" instead of repeating them.
Every test case starts with **Start data**, then **S1**.

| Setup | What it does | Steps | Result |
|---|---|---|---|
| Start data | <plain words> | 1. …<br>2. … | <what the user sees> |
| S1 | <plain words> | 1. …<br>2. … | <what the user sees> |

## 3. Test cases

| TC ID | Test case | Covers | Type | Role | Pre-condition | Test steps | Expected result | Test data | Priority | Note | Run |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TC-<n>-01 | <what this case checks, in plain words> | AC-<n> / Not in AC (<source>) | positive / negative / edge / boundary / permission / state / integration / accessibility | <role from roles> | <state before> | 1. …<br>2. … | 1. …<br>2. … | <values> | High / Medium / Low | <Suggested: … / Assumed: … / Assumed (PO-<n>) / Assumed (Pending Q<n>) / Assumed UI: … / Related bug: #<n> / AC changed / empty> | Auto / Manual only / Blocked: <reason> |

## 4. Questions for PO
**Ticket:** #<n> – <title>
**Why:** The test cases use the assumption below. Please confirm it or tell us what you want instead.
**How to answer:** write "OK" in the "PO answer" column if you agree with the assumption, or write the answer you want. We will update the test cases.

| # | Question | Our assumption (used in the test cases) | Blocks (AC) | PO answer |
|---|---|---|---|---|
| PO-1 | <plain question> | <the assumption written in the test cases> | <AC in plain words> | |
```

## Summary file
`<outputDir>/test-cases-summary.md` covers all tickets, so the user can review them in one place.

```
# QA test cases summary
Updated: <date and time>
Written by /ba-qa-kit:write-test-cases. One row per ticket, for its latest version. Running the skill again for a ticket replaces that ticket's rows.

## 1. Tickets
| Ticket | Title | Version | Sub-issue | Test cases | Auto | Manual only | Blocked | Roles | Ticket gaps | PO questions | Updated |
|---|---|---|---|---|---|---|---|---|---|---|---|
| #<n> | <title> | v<k> | [QA test cases – #<n>](<link>) | <x> | <a> | <m> | <b> | <roles used> | <n> | <n> | <YYYY-MM-DD> |

## 2. All test cases
| Ticket | TC ID | Test case | Role | Run | Priority |
|---|---|---|---|---|---|
| #<n> | TC-<n>-01 | <test case> | <role> | <run> | <priority> |

## 3. Questions for PO that are not answered yet
| Ticket | # | Question | Our assumption | Blocks (AC) | PO answer |
|---|---|---|---|---|---|
| #<n> | PO-1 | <question> | <assumption> | <AC in plain words> | |
```
Questions that already have a PO answer are left out.
