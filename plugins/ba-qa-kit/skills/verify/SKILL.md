---
name: verify
description: "Runs the test cases of tickets in Chrome on Dev or Stag. Pick tickets by number, by label, by milestone, or by label and milestone together. Writes a report and a summary file, and comments the result on each ticket's QA test cases sub-issue. Use when the user asks to verify, test or re-check tickets, to compare results between environments, or to check that related features are not broken (Claude in Chrome)."
---

# QA Verify – Claude in Chrome

Run the test cases of one ticket, or of every ticket that matches a label or milestone, in the user's Chrome on one env. Report what you see. Do not fix anything.

## Setup
Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`. From the profile use the **Board** line (project), **Test envs** (dev and stag URLs, their ready labels), **Roles** (user roles, test data prefix) and **Bugs** (the QA folder, written `<outputDir>` below; default `qa-output`). A line missing or `?:`: ask for it only and offer to save it. No ready label for the env: skip that check. No roles: run every case as the signed-in user; with roles, cases run one role at a time. The kit keeps no test accounts: QA signs in to the test app in Chrome.

## Workflow
1. Input: `--env` (default `dev`), related features (optional), and the tickets, in one of these ways:
   - `--tickets 12,15`, or just `12`: these tickets.
   - `--label "ready to test","bug fix"`: tickets with at least one of these labels.
   - `--milestone "Sprint 1","Sprint 2"`: tickets in one of these milestones (the tracker's sprint; Jira: sprint or fix version).
   - `--label … --milestone …`: tickets that match both.
   - Optional: `--bugs #6,#9`: bugs by others to check against these tickets.
   Names with spaces go in quotes. Tickets given together with a label or milestone? Ask which to use. No tickets, label or milestone given? Ask which tickets.
2. Find the tickets, reading the board the profile's way (the tracker's CLI or connector, else Chrome, else pasted). For labels, search each label and merge the results without duplicates. Only parent tickets (not bugs, not `QA test cases` sub-issues). A label or milestone not found? Tell the user, list the names that exist, and stop.
3. Check each ticket: it has the env's ready label (when the profile has one), and it has a `QA test cases` sub-issue. A ticket can have several versions (`QA test cases – #<n> – v2`, `– v3`…). Find the latest: among the child items of the ticket, take those with the test-cases label (`test case`; the board's name is in the profile's Labels line) or a title that starts with `QA test cases – #<n>`. The version is the number after `– v` in the title (no suffix = v1). Take the highest. Two with the same version, or a version that cannot be read? Ask the user which one to use. A ticket that fails a check is "Skipped" with the reason (no sub-issue: suggest `/ba-qa-kit:write-test-cases`). Skipped tickets show only in the chat table, not in `verify-summary.md`.
4. Confirm: more than one ticket, or a label or milestone was used? Show this table and wait. One ticket by number: skip the table. It has no `QA test cases` sub-issue? Stop and suggest `/ba-qa-kit:write-test-cases`. It is missing the ready label? Tell the user and stop unless they say go.
   ```
   | Ticket | Link | Labels | Milestone | QA test cases | Ready | Run |
   |---|---|---|---|---|---|---|
   | #12 <title> | <link> | <labels> | <milestone> | Yes (<sub-issue link>) | Yes | Will run |
   | #18 <title> | <link> | <labels> | <milestone> | No | n/a | Skipped: run /ba-qa-kit:write-test-cases first |
   | #20 <title> | <link> | <labels> | <milestone> | Yes (<sub-issue link>) | No | Skipped: missing label <ready label> |
   ```
   Ready is `Yes` or `No`. It is `n/a` when the env has no ready label, or when the ticket has no sub-issue.
   Then ask: `Run these <n> tickets on <env>? yes / remove #<n> / include #<n> / no`. Run only after yes.
5. Related features: given in the input? Use them. One ticket and none given: suggest 3–5 with a reason and wait for confirm. More than one ticket: ask once together with step 4; no answer = none.
6. Check Chrome tools (`--chrome`) and that the user is signed in to the env (a login page: see Rules). Read `<outputDir>/qa-lessons.md` if it exists and follow the lessons for `verify` or `both`.
7. Run the tickets one by one, in ticket-number order. Do steps 8–14 for each ticket.
8. Test cases: the description of the latest `QA test cases` sub-issue under the ticket (highest version; no suffix = v1) (the "Test cases" table: one row per case; steps and expected results are numbered the same).
9. Round: 1 more than the highest Round for this Env and Ticket in `<outputDir>/verify-summary.md` or in the comments `QA verify – #<n> – <env> – Round <round>` on any version of the ticket's `QA test cases` sub-issue. None yet = Round 1. The comments found here (all versions) also give the links for `Earlier rounds` in the report. A round that exists only in `verify-summary.md` has no link: write `Round <r> (v<k>) no link`.
10. Run rows with Run = `Auto`, grouped by Role (the profile's order): finish one role, then stop and ask the user to sign in as the next role in Chrome; go on after they reply. Then run the next role. Then run related features. Other rows = "Not run" + reason.
11. Ticket has a result from another env? Compare case by case.
12. Write the report to `<outputDir>/<ticket>-verify-<env>-round-<round>.md`.
13. Update the summary `<outputDir>/verify-summary.md` (create it if missing): add this round to Totals; replace this Env and Ticket's rows in Results and in Fail and Blocked. Keep other tickets and older rounds in Totals.
14. Post the report as a new comment on the latest `QA test cases` sub-issue. Do not ask. First line: `QA verify – #<n> – <env> – Round <round> – <YYYY-MM-DD>`. The comment holds the report, including the line `Earlier rounds`. Always add a new comment; never edit or delete an older one. Write with the tracker's CLI or connector; it can't write: give the comment as text to paste, and keep the files.
15. After the last ticket, show the chat report (see Report).
16. Run the search of the `log-bugs` skill for bugs by others (its section "Bugs by others"). Any Fail in any ticket, or any bug by others found? Ask once in chat: the line `Fail: <ticket and case list>. Log bugs now? yes/no` (when there are Fails) and the table of bugs by others (`Comment on these? yes / no / only <n>`). Yes: run the `log-bugs` skill for the failed cases, with the ticket, env, round and related test cases already filled. It creates the bugs without asking.
17. Any case that now Pass and has an open bug (with or without label `failed`)? Run the `log-bugs` skill for those cases without asking. It sets the label `passed` and adds a comment. Bugs by others that are already linked to a case are commented in the same way, without asking (see `log-bugs`).

## Rules
- New tab. Open only the env URL and the board. Never production.
- Look for bugs only as the `log-bugs` skill says. Never list or search the whole board.
- Start each case from fresh Start data and setup. Follow steps exactly.
- Check each step against the Expected result with the same number.
- Test data names start with the profile's test data prefix.
- Start console and network tracking before each case.
- Each Fail: screenshot, console errors, failed requests. Save screenshots in `<outputDir>` as `<ticket>-round-<round>-<case>-step<n>.jpg`.
- Login page shows? Check the URL is the profile's dev or stag URL; any other URL: stop and ask. Never type a password: stop at the login page and ask the user to sign in as the role you are running, then go on after they reply. A step cannot be done: with one ticket, stop and ask; with many tickets, mark the case Blocked and continue with the next case. The whole ticket cannot go on? Mark its remaining cases Blocked and go to the next ticket.
- Never type or write passwords, tokens or personal data. Do not take a screenshot of a sign-in form.
- Never change data you did not create. Never change the ticket (status, fields, AC) or an older comment; only add the verify comment. Write files only in `<outputDir>`.
- Never send, pay or delete unless it is a test step.

## Report
Chat, one ticket (4 lines):
```
Ticket #<n> on <env>, Round <round>: <p> Pass, <f> Fail, <b> Blocked, <r> Not run
Different from <other env>: <n>
Posted: <comment link>
Report: <outputDir>/<ticket>-verify-<env>-round-<round>.md · Summary: <outputDir>/verify-summary.md
```
Chat, more than one ticket: one table, then the summary path.
```
| Ticket | Round | Status | Posted |
|---|---|---|---|
| #12 (<title>) | 2 | <p> Pass, <f> Fail, <b> Blocked, <r> Not run | <comment link> |
| #18 (<title>) | – | Skipped: no QA test cases | – |
Summary: <outputDir>/verify-summary.md
```
Report file (also the comment text):
```
# QA verify – Ticket #<n>: <ticket title>
Env: <env> | Round: <round> | Test cases: v<k> | Date: <YYYY-MM-DD>
Earlier rounds: Round <r> (v<k>) <comment link> · … (or "none")

**Result: <p> Pass, <f> Fail, <b> Blocked, <r> Not run**

## 1. Results
| Test case | Status |
|---|---|
| <TC ID> (<test case>) | Pass / Fail / Blocked / Not run |

## 2. Impact
| Feature | OK / Broken / Not checked | What you saw |
|---|---|---|

## 3. Compare
Only when the ticket has a result from another env.
| Test case | Dev | Stag | Same / Different |
|---|---|---|---|

## 4. Findings
One row for each Fail, Blocked or Not run case. For Blocked and Not run, write the reason in Actual.
| Test case | Type | Severity | Expected | Actual | Evidence |
|---|---|---|---|---|---|
Sort the rows by Type in this order: Bug, PO question, Test limit, Env issue. Inside a Type, sort by TC ID.
Type: Bug / PO question / Test limit / Env issue. A Fail on a case whose Note says "Assumed" (any form, with or without PO-<n>) is Type PO question, not Bug: the Expected may differ from what the PO wants. Exceptions, these stay Type Bug: a clear defect (the user cannot finish the action, a field is hidden, the page hangs, or the app shows an error), and a case whose Expected has a real source (an AC, or Covers = "Not in AC (<standard>)"). Say which step failed (e.g. "Step 4: …"). Evidence: screenshot, console errors, failed requests.
Under the table write `PO questions: <TC ID>, <TC ID>` (or `PO questions: none`). `/ba-qa-kit:write-test-cases` reads this line for the next version.

## 5. Next steps
- <TC ID>: QA runs it by hand to confirm. Real bug: assign it to a developer.
```

## Summary file
`<outputDir>/verify-summary.md` covers all tickets and envs, so the user can review them in one place.
```
# QA verify summary
Updated: <date and time>
Written by /ba-qa-kit:verify. The Bug column is filled by /ba-qa-kit:log-bugs. Running it again for the same Env and Ticket adds a new Round to Totals and replaces that Env and Ticket's rows in Results and in Fail and Blocked.

## 1. Totals
| Env | Ticket | Round | Status |
|---|---|---|---|
| <env> | #<n> (<title>) | <round> | <p> Pass, <f> Fail, <b> Blocked, <r> Not run |

## 2. Results
Latest round only.
| Env | Ticket | Round | Test case | Status |
|---|---|---|---|---|
| <env> | #<n> (<title>) | <round> | <TC ID> (<test case>) | Pass / Fail / Blocked / Not run |

## 3. Fail and Blocked
Latest round only. Sort the rows by Type (Bug, PO question, Test limit, Env issue), then by TC ID.
| Env | Ticket | Test case | Status | Type | Severity | What happened | Bug | Full report |
|---|---|---|---|---|---|---|---|---|
```
