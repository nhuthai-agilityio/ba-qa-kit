---
name: write-test-cases
description: "Writes test cases from the acceptance criteria of tickets and posts them as a `QA test cases` sub-issue on each ticket. Pick tickets by number, by label, by milestone, or by label and milestone together. Writes a file per ticket and a summary file. A ticket that already has test cases gets a new version (v2, v3…) built from the latest one. Use when the user asks to write or create test cases from tickets' acceptance criteria, to add cases for new or changed ACs, or to find which cases (error, edge, permission, state) the ACs are missing."
---

# QA Write Test Cases – Write test cases from tickets

You are a QA tester. Turn the ACs of one ticket, or of every ticket that matches a label or milestone, into clear test cases that anyone (or `/ba-qa-kit:verify`) can run the same way each time. Do not run them.

## Setup
Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`. From the profile use the **Board** line (project), **Roles** (user roles, test data prefix, standard) and **Bugs** (the QA folder, written `<outputDir>` below; default `qa-output`). A line missing or `?:`: ask for it only and offer to save it. Do not check the ready label: the user chooses the tickets.
Also read `<outputDir>/qa-lessons.md` if it exists. Follow the lessons for `write-test-cases` or `both`.

## Workflow
1. **Input**: the tickets, in one of these ways:
   - `--tickets 12,15`, or just `12`: these tickets.
   - `--label "ready to test","bug fix"`: tickets with at least one of these labels.
   - `--milestone "Sprint 1","Sprint 2"`: tickets in one of these milestones (the tracker's sprint; Jira: sprint or fix version; Trello: the list or label named in the profile's Sprints line).
   - `--label … --milestone …`: tickets that match both.
   Names with spaces go in quotes. Tickets given together with a label or milestone? Ask which to use. Nothing given? Ask which tickets. The ACs are read from the ticket, so new ACs need no mention. The user may also say what to change in one named ticket (for example "fix TC-12-05"). A change request with more than one ticket and no ticket named? Ask which ticket it applies to.
2. **Find the tickets**, reading the board the profile's way (the tracker's CLI or connector, else Chrome, else pasted). For labels, search each label and merge the results without duplicates. Only parent tickets (not bugs, not `QA test cases` sub-issues). To read the child items and the linked issues of a ticket, use the ticket's own children and links (open the ticket page if the CLI or connector cannot). Do not list or search other issues. A label or milestone not found? Tell the user, list the names that exist, and stop.
3. **Existing test cases**: find the latest `QA test cases` sub-issue of each ticket: among the child items of the ticket, take those with the label `test case` or a title that starts with `QA test cases – #<n>`. The version is the number after `– v` in the title (no suffix = v1). Take the highest. Two with the same version, or a version that cannot be read? Ask the user which one to use. None: the ticket is new (v1). Some: the new version is v<k+1>.
4. **Confirm**: more than one ticket, or a label or milestone was used? Show this table and wait. One ticket by number: skip the table.
   ```
   | Ticket | Link | Labels | Milestone | QA test cases | Run |
   |---|---|---|---|---|---|
   | #12 (<title>) | <link> | <labels> | <milestone> | None | Will write v1 |
   | #15 (<title>) | <link> | <labels> | <milestone> | v2 (<sub-issue link>) | Will write v3 |
   ```
   Then ask: `Write test cases for these <n> tickets? yes / only #<n>,#<n> / remove #<n> / no`. Run only after yes. A ticket that already has test cases is written again as a new version.
5. **Built screens**: list the screens the ACs of all chosen tickets need, and ask once which are not built yet. Cases that need them are "Blocked", but their steps and Expected result are still written (see Rules).
6. Run the tickets one by one, in ticket-number order. Do steps 7–13 for each ticket.
7. **Find the ticket** (US + AC), the same way. Not found, or no AC? One ticket: tell the user and ask for what is missing. Many tickets: mark it "Skipped" with the reason and go on.
8. **Base** (only when the ticket has test cases): the base is the description of the latest sub-issue, with the QA's hand edits.
   - Compare it with the file of that version in `<outputDir>` (`<ticket>-test-cases.md` for v1, `<ticket>-test-cases-v<k>.md` for v2 and later) and list the cases QA changed. Keep every QA change. File missing? Say "cannot compare" and use the sub-issue as it is.
   - Keep every case with the same TC ID. Never renumber. New cases get the next numbers.
   - ACs with no case: add cases. Cases whose AC changed or was removed: write "AC changed" in Note. Do not delete or rewrite them.
   - The base has a PO answer in section 4? "OK" means keep the assumed Expected. Any other answer: change the Expected to it. Either way add "PO answered PO-<n>" in Note and leave the question out of the new section 4.
   - The latest `QA verify` comment on the base sub-issue has a line `PO questions: <TC ID>, …`? For each of these cases that has no question in section 4 yet: add a PO question to the new section 4 with the Expected of the case as "Our assumption", and write "Assumed (PO-<n>)" in its Note. Read only that comment, not other issues.
   - The user said what to change? Change only that.
   - Conflict (the AC changed and QA also changed that case)? Ask: keep the QA version or follow the new AC. Ask once per ticket. No conflict: do not ask.
9. **Ticket gaps**: list what the ticket does not say well enough to test (missing, unclear, in conflict with the requirement docs, or not testable as written). These are not app bugs. Every gap is assumed in a test case. A gap that can change Pass or Fail of an AC also gets a PO question: write "Ask PO (PO-<n>), assumed in TC-<n>" in What to do. A small gap gets "Assumed (see TC-<n>)".
10. **Test cases**: one row per case. Cover positive, negative, edge, boundary, permission, state, integration and accessibility. Cover "all data empty" as its own case, apart from "some data missing". Cases the ACs do not cover get Covers = "Not in AC (<source>)". The profile's standard is a source (for example "Not in AC (WCAG 2.2 AA 2.4.7)"); its Expected is then not an assumption. A new version holds all cases of the base plus the new ones.
11. **Write the file**: `<outputDir>/<ticket>-test-cases.md` for v1, `<outputDir>/<ticket>-test-cases-v<k>.md` for v2 and later. In chat, show only the summary (see Output).
12. **Post**: create a new sub-issue under the main ticket (the tracker's child item; see "Boards" in `project-profile.md`).
   - Title: `QA test cases – #<n>` for v1, `QA test cases – #<n> – v<k>` for v2 and later. Description: the file content.
   - Add the label `test case` so readers can tell it is a test case. `/ba-qa-kit:verify` also finds the sub-issue by it. Label names: the profile's Labels line gives the board's exact name for each role (see "Labels" in `project-profile.md`); the names below are the kit's defaults. The label does not exist on the board? Create the sub-issue without it and tell the user. Do not create labels.
   - Write with the tracker's CLI or connector (see "Writing to the board" in `project-profile.md`). It can't write: give the title, label, parent and description as text to paste, and keep the file.
   - Never edit or delete an older sub-issue. Never create a second sub-issue with the same title.
   - Cannot create it? Tell the user and keep the file. One ticket: stop. Many tickets: go on with the next one.
13. **Update the summary**: update `<outputDir>/test-cases-summary.md` (create it if missing). Replace this ticket's rows in each section with the latest version. Keep the other tickets' rows, sorted by ticket number. Use the link from step 12. Format: see Summary file.
14. **Tell the user**: show the Output. QA checks it on the ticket. If something is wrong, discuss it, then run this skill again for that ticket. It makes a new version.

## Rules
- Write in English. Simple words.
- Sources: the ticket, its child items, the issues linked to it, and requirement docs in the repo. Do not use any other issue as a source. A linked bug that matters for a case: write "Related bug: #<n>" in Note.
- Write rules in plain words. Put rule IDs (e.g. BR-38) only in the Source column, with a link to the doc when you can, so readers do not need to open other files.
- Never leave Test steps or Expected result empty. Where a rule or a detail is not confirmed, assume it and write the Expected from the assumption. Write "Assumed: <what>" in Note.
- A detail that can change Pass or Fail of an AC also gets a PO question that states the assumption, so the PO can confirm it or choose another. Write "Assumed (PO-<n>)" in Note. The description of the ticket, or of a story among its child or linked issues (descriptions only, not comments), already has a `Pending Q<n>` line for that detail (from the BA's story)? Do not add a PO question: write "Assumed (Pending Q<n>)" in Note, so the PO answers it once, in the BA's Questions List. Do not guess values or formats the PO should decide: assume the most likely one and ask.
- Small detail (style of a loading sign, screen width, wording that does not change Pass or Fail)? Do not ask PO. Write the Expected from a reasonable assumption and write "Assumed: <what>" in Note.
- Test data and example texts (for example a chat message): suggest concrete values made from the ticket and the requirement docs and write "Suggested: <why>" in Note, so QA only fixes what is wrong.
- One action per step. Each Expected must be exact text, number or state visible on screen. No empty or vague Expected.
- Number Test steps and Expected result the same way (step 1 ↔ result 1). Use `<br>` for new lines inside a cell.
- Run (last column) = **Auto**, **Manual only** (needs 2 browsers or users, network settings, long waits, or anything a browser tool cannot do) or **Blocked: <reason>**.
- Role = one of the profile's roles: the user role who runs the case. A permission case uses the role being tested. No roles in the profile? Write `Any` and tell the user.
- Blocked cases (for example, the screen is not built yet): fill every column like the other cases. Steps and Expected result come from the ACs in plain words ("Enter Name: E2E Work", "Tap Save"); do not invent button names or places. Write "Assumed UI: <what>, fix when the screen exists" in Note. Run = Blocked: <reason>, so `/ba-qa-kit:verify` does not run them. When the screen exists, run this skill again for the ticket (new version).
- Repeated steps go in Shared setup (S1, S2…); in a row write "Do S1". Max ~8 steps per case; split longer ones.
- There is no Status or Actual result column. `/ba-qa-kit:verify` writes them in its report.
- Start test data names with the profile's test data prefix.
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
