---
name: verify
description: "Runs the test cases of tickets on Dev or Stag in Chrome, and in the project's other browsers when this machine can drive them. Pick tickets by number, by label, by milestone, or by label and milestone together. Checks results against the test cases, the AC and past incidents, writes a report and a summary file, and comments the result on each ticket's QA test cases sub-issue. Use when the user asks to verify, test or re-check tickets, to compare results between environments, or to check that related features are not broken (Claude in Chrome, or a browser's MCP)."
---

# QA Verify – Claude in Chrome

Run the test cases of one ticket, or of every ticket that matches a label or milestone, in the user's Chrome on one env. Report what you see. Do not fix anything.

## Setup
Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`, and `${CLAUDE_PLUGIN_ROOT}/templates/verify.md` (the chat report, report file and summary file formats). From the profile use the **Board** line (project), **Test envs** (dev and stag URLs, their ready labels), **Roles** (user roles, test data prefix), **Browsers** (the browsers the project supports, then the screen widths) and **Bugs** (the QA folder, written `<outputDir>` below; default `qa-output`). A line missing or `?:`: ask for it only and offer to save it. No Browsers line: Chrome only, do not ask. Chrome runs through Claude in Chrome. Another listed browser runs only when this session has an MCP that drives it (opens a page, resizes, reads the page); otherwise its cases are `Not run` with a reason from `templates/verify.md`. Browsers other than Chrome run `compatibility` cases only; a step their tools cannot do: `Not run: <reason>`. Chat messages follow the user's language; files and comments are in English. No ready label for the env: skip that check. No roles: run every case as the signed-in user; with roles, cases run one role at a time. The kit keeps no test accounts: QA signs in to the test app in each browser.
@${CLAUDE_PLUGIN_ROOT}/references/ticket-selection.md

## Workflow
1. Input: `--env` (default `dev`), related features (optional), `--bugs #6,#9` (optional: bugs by others to check against these tickets), and the tickets as in "Input" of the imported ticket rules.
2. Find the tickets as in "Find the tickets" of the ticket rules.
3. Check each ticket: it has the env's ready label (when the profile has one), and a `QA test cases` sub-issue (the latest, as in the ticket rules). A ticket that fails a check is "Skipped" with the reason (no sub-issue: suggest `/ba-qa-kit:write-test-cases`). Skipped tickets show only in the chat table, not in `verify-summary.md`.
4. Confirm as in the ticket rules. One ticket by number: with no `QA test cases` sub-issue stop and suggest `/ba-qa-kit:write-test-cases`, and with no ready label tell the user and stop unless they say go. The table:
   ```
   | Ticket | Link | Labels | Milestone | QA test cases | Ready | Run |
   |---|---|---|---|---|---|---|
   | #12 <title> | <link> | <labels> | <milestone> | Yes (<sub-issue link>) | Yes | Will run |
   | #18 <title> | <link> | <labels> | <milestone> | No | n/a | Skipped: run /ba-qa-kit:write-test-cases first |
   | #20 <title> | <link> | <labels> | <milestone> | Yes (<sub-issue link>) | No | Skipped: missing label <ready label> |
   ```
   Ready is `n/a` when the env has no ready label, or when the ticket has no sub-issue. Then ask: `Run these <n> tickets on <env>? yes / remove #<n> / include #<n> / no`. Run only after yes.
5. Related features: given in the input? Use them. One ticket and none given: suggest 3–5 with a reason and wait for confirm. More than one ticket: ask once together with step 4; no answer = none.
6. Check Chrome tools (`--chrome`); missing: stop and tell the user to start `claude --chrome`. The Browsers line has another browser? For each, check whether this session has MCP tools that drive it, and the OS it needs (read only, install nothing). Before the first run, send the one message `templates/verify.md` ("Browser readiness") describes, with its one question. Check that the user is signed in to the env in each browser you will use (a login page: see Rules). Read `<outputDir>/qa-lessons.md` if it exists and follow the lessons for `verify` or `both`, and their incident records.
7. Run the tickets one by one, in ticket-number order. Do steps 8–14 for each ticket.
8. Test cases: the "Test cases" table in the description of the latest `QA test cases` sub-issue (one row per case; steps and expected results are numbered the same). Also read the ticket's AC. A Fail on a case that differs from its AC is Type Spec mismatch.
9. Round (a comment titled `… – reported by QA – <date>` is not a round): 1 more than the highest Round for this Env and Ticket in `<outputDir>/verify-summary.md` or in the comments `QA verify – #<n> – <env> – Round <round>` on any version of the ticket's `QA test cases` sub-issue. None yet = Round 1. The comments found here also give the links for `Earlier rounds` in the report. A round that exists only in `verify-summary.md` has no link: write `Round <r> (v<k>) no link`.
10. Run rows with Run = `Auto`, grouped by Role (the profile's order): finish one role, then stop and ask the user to sign in as the next role in Chrome; go on after they reply. Then run related features. Other rows = "Not run" + reason.
   - `responsive` case: resize the window to its width, run it, then restore the size; it cannot be resized: Blocked (reason: window cannot be resized). At that width also check: no horizontal scroll (page script: `document.documentElement.scrollWidth <= window.innerWidth`), nothing cut off or overlapping, the main action reachable.
   - `accessibility` case: keyboard only (Tab, Shift+Tab, Enter, Esc), check focus. Also read the page tree (`read_page`): names on fields and buttons, roles, alt on images, heading order. Reflow: at 320 px wide there is no horizontal scroll. Never judge colour contrast by eye or a screen reader: Manual only.
   - `compatibility` case: Chrome runs everything first. Then, for each listed browser whose tools are connected, run the case there, after the user signed in there. Never run browsers at the same time. A browser not connected or not able to run on this machine: `Not run: <reason>` (reasons in the template). Steps 12–14 write these cases as `Not run: <reason>`; step 15 may overwrite only those rows. Never write a result the user did not give.
11. Ticket has a result from another env? Compare case by case.
12. Write the report (template format) to `<outputDir>/<ticket>-verify-<env>-round-<round>.md`.
13. Update `<outputDir>/verify-summary.md` (create it if missing): add this round to Totals; replace this Env and Ticket's rows in Results and in Fail and Blocked. Keep other tickets and older rounds in Totals.
14. Post the report as a new comment on the latest `QA test cases` sub-issue, with glab (see "Writing to the board" in the profile). Do not ask. First line: `QA verify – #<n> – <env> – Round <round> – <YYYY-MM-DD>`. The comment holds the report, including the line `Earlier rounds`. Cannot write? Give the comment as text to paste and keep the files.
15. After the last ticket, any `compatibility` case still `Not run`? Results from another machine:
   - Ask once, grouped per browser (ticket, TC ID, steps, Expected): `Did you test these on another machine (for example Safari on a Mac)? Reply per case: Pass / Fail <what you saw, no personal data> / skip`. Never ask per ticket. Leave out any password, token, email or name in the reply before you write it.
   - Record Pass or Fail with Run by `Reported by QA` and Evidence `reported by QA, <browser>`. Skip or no reply stays `Not run: <reason>`.
   - Overwrite only those rows (Results, Findings, and the Run by and Result of the Browsers table as the template says) in each answered ticket's report file and summary.
   - Recompute its counts in the report, in Totals and in the Fail and Blocked rows of `verify-summary.md` (`log-bugs` reads them).
   - Post one extra comment on its sub-issue: `QA verify – #<n> – <env> – Round <round> – reported by QA – <YYYY-MM-DD>`. A new comment, never edit the first; it is not a round, step 9 ignores it. Show its text in chat, then post it like step 14: do not ask (see "Writing to the board" in the profile reference, which also says what to do when the write is refused or the go gate holds it).
   Then show the chat report. Share line on (or missing): add `Reply share to put the verify reports and the summary in the repo.` (see "Sharing files" in the profile reference).
16. Run the search of the `log-bugs` skill for bugs by others (its section "Bugs by others"). Any Fail in any ticket, or any bug by others found? Ask once in chat: the line `Fail: <ticket and case list>. Log bugs now? yes/no` (when there are Fails) and the table of bugs by others (`Comment on these? yes / no / only <n>`). Yes: run the `log-bugs` skill for the failed cases, with the ticket, env, round and related test cases already filled. It creates the bugs without asking. A Fail reported by QA has no screenshot: ask the user for a short note and tell them these bugs need their own evidence.
17. Any case that now Pass and has an open bug (with or without label `failed`)? Run the `log-bugs` skill for those cases without asking. It sets the label `passed` and adds a comment. Bugs by others already linked to a case are commented the same way (see `log-bugs`).
18. Fail or Blocked left? Ask: `Re-run <n> cases as Round <r+1>? yes / later`. Yes: run only those and repeat steps 12–17. In step 15 a case with a recorded result is not asked again; one still Not run is asked once more.

## Rules
- New tab. Open only the env URL and the board. Never production.
- Look for bugs only as the `log-bugs` skill says. Never list or search the whole board.
- Start each case from fresh Start data and setup. Follow steps exactly. Check each step against the Expected result with the same number, the AC and the incident rules.
- Test data names start with the profile's test data prefix.
- Start console and network tracking before each case.
- Each Fail: screenshot, console errors, failed requests. Save screenshots in `<outputDir>` as `<ticket>-round-<round>-<case>-step<n>.jpg`.
- Login page shows (in any browser)? Check the URL is the profile's dev or stag URL; any other URL: stop and ask. Never type a password: stop at the login page and ask the user to sign in as the role you are running, then go on after they reply. In any browser, when the user cannot sign in: its cases are `Not run: cannot sign in to <browser>`. Never take a screenshot of a sign-in form.
- A step cannot be done: with one ticket, stop and ask; with many tickets, mark the case Blocked and continue with the next case. The whole ticket cannot go on? Mark its remaining cases Blocked and go to the next ticket.
- Never write passwords, tokens or personal data. Never change data you did not create. Never change the ticket (status, fields, AC); only add the verify comment, never edit or delete an older one. Write files only in `<outputDir>`.
- Never send, pay or delete unless it is a test step.
