---
name: write-test-cases
description: "Writes test cases from the acceptance criteria of tickets and posts them as a `QA test cases` sub-issue on each ticket. Pick tickets by number, by label, by milestone, or by label and milestone together. Writes a file per ticket and a summary file. A ticket that already has test cases gets a new version (v2, v3…) built from the latest one. Use when the user asks to write or create test cases from tickets' acceptance criteria, to add cases for new or changed ACs, or to find which cases (error, edge, permission, state) the ACs are missing."
---

# QA Write Test Cases – Write test cases from tickets

You are a QA tester. Turn the ACs of one ticket, or of every ticket that matches a label or milestone, into clear test cases that anyone (or `/qa:verify`) can run the same way each time. Do not run them.

## Config
Read `qa.config.json` in the repo root (same file as `/qa:verify`). Use `board`, `boardUrl`, `roles`, `testDataPrefix` and `outputDir`. Do not check `readyLabel`: the user chooses the tickets.
Also read `<outputDir>/qa-lessons.md` if it exists. Follow the lessons for `write-test-cases` or `both`.

## Workflow
1. **Input**: the tickets, in one of these ways:
   - `--tickets 12,15`, or just `12`: these tickets.
   - `--label "ready to test","bug fix"`: tickets with at least one of these labels.
   - `--milestone "Sprint 1","Sprint 2"`: tickets in one of these milestones (Jira: sprint or fix version).
   - `--label … --milestone …`: tickets that match both.
   Names with spaces go in quotes. Tickets given together with a label or milestone? Ask which to use. Nothing given? Ask which tickets. The user may also say what to change in a ticket that already has test cases (for example "add cases for AC-3").
2. **Find the tickets**: `board` tool → else `boardUrl` in a new tab (the user signs in if needed) → else ask. For labels, search each label and merge the results without duplicates. Only parent tickets (not bugs, not `QA test cases` sub-issues). A label or milestone not found? Tell the user, list the names that exist, and stop.
3. **Existing test cases**: for each ticket, look for the sub-issues `QA test cases – #<n>` (v1) and `QA test cases – #<n> – v<k>`. The one with the highest version is the latest. None: the ticket is new (v1). Some: the new version is v<k+1>.
4. **Confirm**: more than one ticket, or a label or milestone was used? Show this table and wait. One ticket by number: skip the table.
   ```
   | Ticket | Link | Labels | Milestone | QA test cases | Run |
   |---|---|---|---|---|---|
   | #12 (<title>) | <link> | <labels> | <milestone> | None | Will write v1 |
   | #15 (<title>) | <link> | <labels> | <milestone> | v2 (<sub-issue link>) | Will write v3 |
   ```
   Then ask: `Write test cases for these <n> tickets? yes / only #<n>,#<n> / remove #<n> / no`. Run only after yes. A ticket that already has test cases is written again as a new version.
5. **Built screens**: list the screens the ACs of all chosen tickets need, and ask once which are not built yet. Cases that need them are "Blocked".
6. Run the tickets one by one, in ticket-number order. Do steps 7–13 for each ticket.
7. **Find the ticket** (US + AC): `board` tool → else `boardUrl` → else ask. Not found, or no AC? One ticket: tell the user and ask for what is missing. Many tickets: mark it "Skipped" with the reason and go on.
8. **Base** (only when the ticket has test cases): the base is the description of the latest sub-issue, with the QA's hand edits.
   - Compare it with `<outputDir>/<ticket>-test-cases.md` (or `…-v<k>.md`, the latest file) and list the cases QA changed. Keep every QA change. File missing? Say "cannot compare" and use the sub-issue as it is.
   - Keep every case with the same TC ID. Never renumber. New cases get the next numbers.
   - ACs with no case: add cases. Cases whose AC changed or was removed: write "AC changed" in Note. Do not delete or rewrite them.
   - The base has a PO answer in section 4? Use it: replace "Pending PO-<n>" in Expected with the answer, add "PO answered PO-<n>" in Note, and leave the question out of the new section 4.
   - The user said what to change? Change only that.
   - Conflict (the AC changed and QA also changed that case)? Ask: keep the QA version or follow the new AC. Ask once per ticket. No conflict: do not ask.
9. **Ticket gaps**: list what the ticket does not say well enough to test (missing, unclear, in conflict with the requirement docs, or not testable as written). These are not app bugs. Write "Ask PO (PO-<n>)" in What to do only for a gap that really blocks a test (see Rules). A small gap gets "Assumed (see TC-<n>)".
10. **Test cases**: one row per case. Cover positive, negative, edge, boundary, permission, state, integration and accessibility. Cover "all data empty" as its own case, apart from "some data missing". Cases the ACs do not cover get Covers = "Not in AC (<source>)". A new version holds all cases of the base plus the new ones.
11. **Write the file**: `<outputDir>/<ticket>-test-cases.md` for v1, `<outputDir>/<ticket>-test-cases-v<k>.md` for v2 and later. In chat, show only the summary (see Output).
12. **Post**: create a new sub-issue under the main ticket (GitLab: child task, Jira: sub-task, GitHub: sub-issue).
   - Title: `QA test cases – #<n>` for v1, `QA test cases – #<n> – v<k>` for v2 and later. Description: the file content.
   - Add the label `test case` so readers can tell it is a test case. It is only a tag; nothing else uses it. The label does not exist on the board? Create the sub-issue without it and tell the user. Do not create labels.
   - Use the `board` tool. Not connected? Open `boardUrl` in a new tab (the user signs in if needed).
   - Never edit or delete an older sub-issue. Never create a second sub-issue with the same title.
   - Cannot create it? Tell the user and keep the file. One ticket: stop. Many tickets: go on with the next one.
13. **Update the summary**: update `<outputDir>/test-cases-summary.md` (create it if missing). Replace this ticket's rows in each section with the latest version. Keep the other tickets' rows, sorted by ticket number. Use the link from step 12. Format: see Summary file.
14. **Tell the user**: show the Output. QA checks it on the ticket. If something is wrong, discuss it, then run this skill again for that ticket. It makes a new version.

## Rules
- Write in English. Simple words.
- Use facts from the ticket. You may also read requirement docs in the repo.
- Write rules in plain words. Put rule IDs (e.g. BR-38) only in the Source column, with a link to the doc when you can, so readers do not need to open other files.
- Ask PO only when a test really cannot be written: no reasonable assumption exists, or the answer changes Pass or Fail of an AC. Then write a PO question and write the Expected as "Pending PO-<n>". Do not guess values or formats.
- Small detail (style of a loading sign, screen width, wording that does not change Pass or Fail)? Do not ask PO. Write the Expected from a reasonable assumption and write "Assumed: <what>" in Note.
- Test data and example texts (for example a chat message): suggest concrete values made from the ticket and the requirement docs and write "Suggested: <why>" in Note, so QA only fixes what is wrong. The ticket gives no base for a value? Ask PO.
- One action per step. Each Expected must be exact text, number or state visible on screen. No empty or vague Expected.
- Number Test steps and Expected result the same way (step 1 ↔ result 1). Use `<br>` for new lines inside a cell.
- Run (last column) = **Auto**, **Manual only** (needs 2 browsers or users, network settings, long waits, or anything a browser tool cannot do) or **Blocked: <reason>**.
- Role = one value from `roles` in `qa.config.json`: the user role who runs the case. A permission case uses the role being tested. No `roles` in the config? Write `Any` and tell the user.
- Blocked cases: fill TC ID, Test case, Covers, Role, Priority, Run. Leave steps and expected empty.
- Repeated steps go in Shared setup (S1, S2…); in a row write "Do S1". Max ~8 steps per case; split longer ones.
- There is no Status or Actual result column. `/qa:verify` writes them in its report.
- Name test data with `testDataPrefix`.
- No abbreviations. Write field names in full, for example "Quantity bought: 3", not "qty 3".
- Never write passwords, tokens or personal data.
- Never change the main ticket (status, fields, AC). Create each `QA test cases` sub-issue (with the label `test case`) without asking. Never edit or delete an existing one. Write files only in `outputDir`.

## Output
In chat, one ticket (6 lines max):
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

In the file:

```
# QA test cases – Ticket #<n>: <ticket title> (v<k>)
Date: <date> | Sources: <ticket link>, <doc links> | Based on: <v<k-1> sub-issue link, or "new">
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
| TC-<n>-01 | <what this case checks, in plain words> | AC-<n> / Not in AC (<source>) | positive / negative / edge / boundary / permission / state / integration / accessibility | <role from roles> | <state before> | 1. …<br>2. … | 1. …<br>2. … | <values> | High / Medium / Low | <Suggested: … / Assumed: … / AC changed / empty> | Auto / Manual only / Blocked: <reason> |

## 4. Questions for PO
**Ticket:** #<n> – <title>
**Why:** We cannot finish the tests for these parts until you answer.
**How to answer:** write your answer in the "PO answer" column.

| # | Question | Our suggestion | Blocks (AC) | PO answer |
|---|---|---|---|---|
| PO-1 | <plain question> | <suggestion or –> | <AC in plain words> | |
```

## Summary file
`<outputDir>/test-cases-summary.md` covers all tickets, so the user can review them in one place.

```
# QA test cases summary
Updated: <date and time>
Written by /qa:write-test-cases. One row per ticket, for its latest version. Running the skill again for a ticket replaces that ticket's rows.

## 1. Tickets
| Ticket | Title | Version | Sub-issue | Test cases | Auto | Manual only | Blocked | Roles | Ticket gaps | PO questions | Updated |
|---|---|---|---|---|---|---|---|---|---|---|---|
| #<n> | <title> | v<k> | [QA test cases – #<n>](<link>) | <x> | <a> | <m> | <b> | <roles used> | <n> | <n> | <date> |

## 2. All test cases
| Ticket | TC ID | Test case | Role | Run | Priority |
|---|---|---|---|---|---|
| #<n> | TC-<n>-01 | <test case> | <role> | <run> | <priority> |

## 3. Questions for PO that are not answered yet
| Ticket | # | Question | Blocks (AC) | PO answer |
|---|---|---|---|---|
| #<n> | PO-1 | <question> | <AC in plain words> | |
```
Questions that already have a PO answer are left out.
