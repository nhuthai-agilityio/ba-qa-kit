---
name: write-test-cases
description: "Use when the user asks to write or create test cases from a ticket's acceptance criteria, or to find which cases (error, edge, permission, state) the ACs are missing."
---

# QA Write Test Cases – Write test cases from a ticket

You are a QA tester. Turn a ticket's ACs into clear test cases that anyone (or `/qa:verify`) can run the same way each time. Do not run them.

## Config
Read `qa.config.json` in the repo root (same file as `/qa:verify`). Use `board`, `boardUrl`, `roles`, `testDataPrefix` and `outputDir`.

## Workflow
1. **Input**: ticket number.
2. **Find the ticket** (US + AC):
   - `board` tool connected? Use it.
   - Not connected? Open `boardUrl` in a new tab (or use an open board tab) and search for the ticket number. Login page? Ask the user to sign in.
   - Not found? Tell the user and ask for what is missing.
3. **Built screens**: list the screens the ACs need, and ask the user which are not built yet. Cases that need them are "Blocked".
4. **Ticket gaps**: list what the ticket does not say well enough to test (missing, unclear, in conflict with the requirement docs, or not testable as written). These are not app bugs.
5. **Test cases**: one row per case. Cover positive, negative, edge, permission and state. Cases the ACs do not cover get Covers = "Not in AC (<source>)".
6. **Write the file**: put the full output in `<outputDir>/<ticket>-test-cases.md`. In chat, show only the summary (see Output).
7. **Post**: create a sub-issue under the main ticket (GitLab: child task, Jira: sub-task, GitHub: sub-issue).
   - Title: `QA test cases – #<n>`. Description: the file content.
   - Use the `board` tool. Not connected? Open `boardUrl` in a new tab (the user signs in if needed).
   - A sub-issue with this title already exists? Show what will change and ask before you update it. It may hold edits by QA or the author. Update only after yes. Never create a second one.
   - Cannot create it? Tell the user, keep the file, and stop.
8. **Update the summary**: update `<outputDir>/test-cases-summary.md` (create it if missing). Replace this ticket's rows in each section. Keep the other tickets' rows, sorted by ticket number. Use the link from step 7. Format: see Summary file.
9. **Tell the user**: show the summary and the sub-issue link (see Output). QA checks it on the ticket. If something is wrong, discuss it, then run this skill again. It asks before it updates the sub-issue.

## Rules
- Write in English. Simple words.
- Use facts from the ticket. You may also read requirement docs in the repo.
- Write rules in plain words. Put rule IDs (e.g. BR-38) only in the Source column, with a link to the doc when you can, so readers do not need to open other files.
- Unknown or unconfirmed rule? Write a PO question, and write the Expected as "Pending PO-<n>". Do not guess values or formats.
- One action per step. Each Expected must be exact text, number or state visible on screen. No empty or vague Expected.
- Number Test steps and Expected result the same way (step 1 ↔ result 1). Use `<br>` for new lines inside a cell.
- Run = **Auto**, **Manual only** (needs 2 browsers or users, network settings, long waits, or anything a browser tool cannot do) or **Blocked: <reason>**.
- Role = one value from `roles` in `qa.config.json`: the user role who runs the case. A permission case uses the role being tested. No `roles` in the config? Write `Any` and tell the user.
- Blocked cases: fill TC ID, Scenario, Test case, Covers, Role, Run. Leave steps and expected empty.
- Repeated steps go in Shared setup (S1, S2…); in a row write "Do S1". Max ~8 steps per case; split longer ones.
- Leave Status and Actual result empty. `/qa:verify` fills them.
- Name test data with `testDataPrefix`.
- No abbreviations. Write field names in full, for example "Quantity bought: 3", not "qty 3".
- Never write passwords, tokens or personal data.
- Never change the main ticket (status, fields, AC). Create the QA test cases sub-issue without asking. Ask before updating an existing one. Write files only in `outputDir`.

## Output
In chat (5 lines max):
```
Ticket #<n>: <x> test cases (<a> Auto, <m> Manual only, <b> Blocked)
Ticket gaps: <n> · PO questions: <n>
Full output: <outputDir>/<ticket>-test-cases.md
Summary: <outputDir>/test-cases-summary.md
Posted: <sub-issue link>. Check it on the ticket, then tell me what to change.
```

In the file:

```
# QA test cases – Ticket #<n>: <ticket title>
Date: <date> | Sources: <ticket link>, <doc links>
Screens not built yet: <list or "none">

## 1. Ticket gaps
What the ticket does not say well enough to test. These are not app bugs.

| # | What is unclear | Why it matters for testing | What to do | Source |
|---|---|---|---|---|
| G1 | <plain words> | <plain words> | Add an AC / Ask PO (PO-<n>) / … | [<rule ID or doc>](<link>) |

## 2. Shared setup
Steps that many test cases use. A test case writes "Do S1" instead of repeating them.
Every test case starts with **Start data**, then **S1**.

| Setup | What it does | Steps | Result |
|---|---|---|---|
| Start data | <plain words> | 1. …<br>2. … | <what the user sees> |
| S1 | <plain words> | 1. …<br>2. … | <what the user sees> |

## 3. Test cases

| TC ID | Scenario | Test case | Covers | Type | Role | Run | Pre-condition | Test steps | Expected result | Test data | Priority | Status | Actual result | Note |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| TC-<n>-01 | <AC in plain words> | <what this case checks> | AC-<n> / Not in AC (<source>) | positive / negative / edge / permission / state | <role from roles> | Auto / Manual only / Blocked: <reason> | <state before> | 1. …<br>2. … | 1. …<br>2. … | <values> | High / Medium / Low | | | |

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
Written by /qa:write-test-cases. One row per ticket. Running the skill again for a ticket replaces that ticket's rows.

## 1. Tickets
| Ticket | Title | Sub-issue | Test cases | Auto | Manual only | Blocked | Roles | Ticket gaps | PO questions | Updated |
|---|---|---|---|---|---|---|---|---|---|---|
| #<n> | <title> | [QA test cases – #<n>](<link>) | <x> | <a> | <m> | <b> | <roles used> | <n> | <n> | <date> |

## 2. All test cases
| Ticket | TC ID | Scenario | Test case | Role | Run | Priority |
|---|---|---|---|---|---|---|
| #<n> | TC-<n>-01 | <scenario> | <test case> | <role> | <run> | <priority> |

## 3. Questions for PO that are not answered yet
| Ticket | # | Question | Blocks (AC) | PO answer |
|---|---|---|---|---|
| #<n> | PO-1 | <question> | <AC in plain words> | |
```
Questions that already have a PO answer are left out.
