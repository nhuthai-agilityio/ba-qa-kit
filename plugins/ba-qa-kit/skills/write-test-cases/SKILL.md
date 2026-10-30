---
name: write-test-cases
description: "Writes test cases from the acceptance criteria of tickets and posts them as a `QA test cases` sub-issue on each ticket. Pick tickets by number, by label, by milestone, or by label and milestone together. Writes a file per ticket and a summary file. A ticket that already has test cases gets a new version (v2, v3…) built from the latest one. Use when the user asks to write or create test cases from tickets' acceptance criteria, to add cases for new or changed ACs, or to find which cases (error, edge, permission, state) the ACs are missing."
---

# QA Write Test Cases – Write test cases from tickets

You are a QA tester. Turn the ACs of one ticket, or of every ticket that matches a label or milestone, into clear test cases that anyone (or `/ba-qa-kit:verify`) can run the same way each time. Do not run them.

## Setup
Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`, and `${CLAUDE_PLUGIN_ROOT}/references/write-test-cases-templates.md` (the chat output, test case file and summary file formats). From the profile use the **Board** line (project), **Roles** (user roles, test data prefix, standard) and **Bugs** (the QA folder, written `<outputDir>` below; default `qa-output`). A line missing or `?:`: ask for it only and offer to save it. Do not check the ready label: the user chooses the tickets.
Also read `<outputDir>/qa-lessons.md` if it exists. Follow the lessons for `write-test-cases` or `both`.

## Workflow
1. **Input**: the tickets, in one of these ways:
   - `--tickets 12,15`, or just `12`: these tickets.
   - `--label "ready to test","bug fix"`: tickets with at least one of these labels.
   - `--milestone "Sprint 1","Sprint 2"`: tickets in one of these milestones (Jira: sprint or fix version).
   - `--label … --milestone …`: tickets that match both.
   Names with spaces go in quotes. Tickets given together with a label or milestone? Ask which to use. Nothing given? Ask which tickets. A change request ("fix TC-12-05") for more than one ticket, with no ticket named? Ask which ticket it applies to. The ACs are read from the ticket, so new ACs need no mention.
2. **Find the tickets**, reading the board the profile's way. For labels, search each label and merge the results without duplicates. Only parent tickets (not bugs, not `QA test cases` sub-issues). Read a ticket's child items and linked issues from the ticket itself. Do not list or search other issues. A label or milestone not found? List the names that exist, and stop.
3. **Existing test cases**: the latest `QA test cases` sub-issue of a ticket is the child item with the label `test case` (profile Labels) or a title that starts with `QA test cases – #<n>`, with the highest version (the number after `– v`; no suffix = v1). Two with the same version, or a version that cannot be read? Ask which to use. None: the ticket is new (v1). Some: the new version is v<k+1>.
4. **Confirm**: more than one ticket, or a label or milestone was used? Show this table and wait. One ticket by number: skip the table.
   ```
   | Ticket | Link | Labels | Milestone | QA test cases | Run |
   |---|---|---|---|---|---|
   | #12 (<title>) | <link> | <labels> | <milestone> | None | Will write v1 |
   | #15 (<title>) | <link> | <labels> | <milestone> | v2 (<sub-issue link>) | Will write v3 |
   ```
   Then ask: `Write test cases for these <n> tickets? yes / only #<n>,#<n> / remove #<n> / no`. Run only after yes.
5. **Built screens**: list the screens the ACs of all chosen tickets need, and ask once which are not built yet. Their cases are "Blocked" (see Rules).
6. Run the tickets one by one, in ticket-number order. Do steps 7–13 for each.
7. **Read the ticket** (US + AC). Not found, or no AC? One ticket: ask for what is missing. Many tickets: mark it "Skipped" with the reason and go on. **Number the ACs** as `AC-1`, `AC-2`… in order. When the A/C are grouped under bold screen or flow-step bullets, count only the nested bullets, in order across the groups; a group bullet is never an AC. Flat A/C (checkboxes or plain bullets): each is one AC.
8. **Base** (only when the ticket has test cases): the base is the description of the latest sub-issue, with the QA's hand edits.
   - Compare it with that version's file in `<outputDir>` (`<ticket>-test-cases.md` for v1, `<ticket>-test-cases-v<k>.md` for v2+) and list the cases QA changed. Keep every QA change. File missing? Say "cannot compare" and use the sub-issue as it is.
   - Keep every case with the same TC ID. Never renumber. New cases get the next numbers.
   - ACs with no case: add cases. Cases whose AC changed or was removed: write "AC changed" in Note; do not delete or rewrite them.
   - A PO answer in section 4: "OK" keeps the assumed Expected; any other answer becomes the Expected. Add "PO answered PO-<n>" in Note and leave the question out of the new section 4.
   - The latest `QA verify` comment on the base sub-issue has `PO questions: <TC ID>, …`? For each such case with no question in section 4: add a PO question with the case's Expected as "Our assumption", and write "Assumed (PO-<n>)" in its Note. Read only that comment.
   - The user said what to change? Change only that.
   - Conflict (the AC changed and QA also changed that case)? Ask once per ticket: keep the QA version or follow the new AC.
9. **Ticket gaps**: list what the ticket does not say well enough to test (missing, unclear, in conflict with the requirement docs, or not testable as written). These are not app bugs. Every gap is assumed in a test case. A gap that can change Pass or Fail of an AC also gets a PO question: write "Ask PO (PO-<n>), assumed in TC-<n>" in What to do. A small gap gets "Assumed (see TC-<n>)".
10. **Test cases**: one row per case. Cover positive, negative, edge, boundary, permission, state, integration and accessibility. "All data empty" is its own case, apart from "some data missing". Cases the ACs do not cover get Covers = "Not in AC (<source>)"; the profile's standard is a source (for example "Not in AC (WCAG 2.2 AA 2.4.7)") and its Expected is then not an assumption. A new version holds all cases of the base plus the new ones.
11. **Write the file** in the template's format: `<outputDir>/<ticket>-test-cases.md` for v1, `<outputDir>/<ticket>-test-cases-v<k>.md` for v2+. In chat, show only the summary.
12. **Post** a new sub-issue under the main ticket (GitLab: child task, Jira: sub-task, GitHub: sub-issue) with `Writing to the board` in the profile.
    - Title `QA test cases – #<n>` for v1, `QA test cases – #<n> – v<k>` for v2+. Description: the file content. Label: test cases (so `/ba-qa-kit:verify` finds it).
    - Cannot create it? Tell the user and keep the file. One ticket: stop. Many tickets: go on with the next.
13. **Update the summary**: update `<outputDir>/test-cases-summary.md` (create it if missing). Replace this ticket's rows in each section with the latest version, keep the other tickets' rows sorted by ticket number, and use the link from step 12.
14. **Tell the user** the chat output. QA checks it on the ticket. If something is wrong, discuss it, then run this skill again for that ticket (a new version).

## Rules
- Simple words. No abbreviations: write field names in full ("Quantity bought: 3", not "qty 3").
- Sources: the ticket, its child items, the issues linked to it, and requirement docs in the repo. Do not use any other issue. A linked bug that matters for a case: write "Related bug: #<n>" in Note.
- Write rules in plain words. Rule IDs (e.g. BR-38) go only in the Source column, with a link to the doc when you can.
- Never leave Test steps or Expected result empty. An unconfirmed rule or detail is assumed: write the Expected from the assumption and "Assumed: <what>" in Note.
- A detail that can change Pass or Fail of an AC also gets a PO question with the assumption (Note: "Assumed (PO-<n>)"). If the ticket, or a story among its child or linked issues (descriptions only), already has a `Pending Q<n>` line for it, add no PO question: write "Assumed (Pending Q<n>)". Do not guess values or formats the PO should decide: assume the most likely one and ask.
- A small detail (loading sign, screen width, wording) gets no PO question; write "Assumed: <what>" in Note.
- Test data and example texts: suggest concrete values from the ticket and requirement docs and write "Suggested: <why>" in Note.
- One action per step, at most ~8 steps per case (split longer ones). Each Expected is exact text, a number or a state visible on screen. Number steps and results the same way (step 1 ↔ result 1); `<br>` for new lines in a cell.
- Repeated steps go in Shared setup (S1, S2…); in a row write "Do S1".
- Run = **Auto**, **Manual only** (needs 2 browsers or users, network settings, long waits, or anything a browser tool cannot do) or **Blocked: <reason>**.
- Role = one of the profile's roles: the one who runs the case (a permission case: the role being tested). No roles in the profile? Write `Any` and tell the user.
- Blocked cases (for example, the screen is not built yet): fill every column. Steps and Expected come from the ACs in plain words ("Enter Name: E2E Work", "Tap Save"); do not invent button names or places. Note: "Assumed UI: <what>, fix when the screen exists". Run again for the ticket once the screen exists (new version).
- No Status or Actual result column: `/ba-qa-kit:verify` writes them in its report.
- Start test data names with the profile's test data prefix. Never write passwords, tokens or personal data.
- Never change the main ticket (status, fields, AC). Create each `QA test cases` sub-issue without asking. Never edit or delete an existing sub-issue, and never create a second one with the same title. Write files only in `outputDir`.
