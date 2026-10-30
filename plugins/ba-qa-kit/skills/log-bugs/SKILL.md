---
name: log-bugs
description: "Logs bugs from failed /ba-qa-kit:verify cases as child items of the ticket, follows them across rounds, and records verify mistakes as incident records. Use when the user asks to log, write or draft bug reports, or says a logged bug is not a real bug (review)."
---

# QA Log Bugs – Log bugs and learn from verify mistakes

You are a QA tester. Turn failed cases into bug issues so QA can check them by hand. When QA finds that a "bug" was a mistake in the test case or in the verify run, find the cause and record it so it does not happen again. Do not fix the app.

## Setup
Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`, and `${CLAUDE_PLUGIN_ROOT}/references/log-bugs-templates.md` (bug, incident record and lessons file). From the profile use the **Board** line (project), **Test envs**, **Roles** (the standard) and **Bugs** (who checks bugs, written `<qaAssignee>` below, and the QA folder, written `<outputDir>`; default `qa-output`). No standard: an Expected with no source is a PO question (see step 3). Nobody named to check bugs: create the bug unassigned and say so. A line missing or `?:`: ask for it only and offer to save it.

## Modes
- **Log** (default): called by `/ba-qa-kit:verify` after the user said yes, or by the user with failed cases or a description.
- **Review**: `/ba-qa-kit:log-bugs review #<bug issue>`. QA says the bug is not real.
- **Link**: `/ba-qa-kit:log-bugs link TC-1-09=#6`. The user names a bug by others for a case. Do the steps of "Bugs by others" for it, without the table.

## Log workflow
1. **Input**: failed cases from `/ba-qa-kit:verify` in this chat (ticket, env, round, cases) and any cases that now Pass; or the user's description. The user may also give `--bugs #6,#9` (see "Bugs by others"). Missing ticket number, env or steps? Ask. The version `v<k>` of the test cases is in the verify report (`Test cases: v<k>`). No verify report? Use the latest `QA test cases` sub-issue (highest version; ask if unclear).
2. **Lessons**: read `<outputDir>/qa-lessons.md` if it exists. A lesson matches a failed case? Say so in the bug's "For QA" note.
3. **Bug or PO question?** Take the Type from the Findings of the verify report.
   - Type `PO question`: do not log a bug and do not make up PO numbers. Tell the user `skipped: <TC ID> is a PO question (see the verify report)`.
   - Type `Bug` with an Expected that is only assumed (the Note says "Assumed"): this is a clear defect (the user cannot finish the action, a field is hidden, the page hangs, or the app shows an error). Log it with `assumed, not in AC` as the source of the Expected, and keep step 4 of "For QA".
   - No verify report? Decide the same way: a rule that is not confirmed and is not a clear defect is a PO question.
4. **Find existing bugs**: for each case, search the child items of the ticket with the label `Bug` or a title that starts with `[Bug]`, whose description has `Related test case: <TC ID>`. Bugs that others logged are in "Bugs by others". Label names: use the board's own (profile Labels line), matched without regard to case.
   - Open bug, case still Fail: no new bug. Comment `Round <round> (<env>, v<k>): still Fail`, add label `failed`, remove `passed`.
   - Closed bug without `not-a-bug`, case Fail again: reopen it, add `failed`, remove `passed`, comment `Round <round> (<env>, v<k>): Fail again after the fix`. Keep its assignee.
   - Closed bug with `not-a-bug`: do not log or reopen. Tell the user, and point to the incident record and `qa-lessons.md`.
   - Open bug with label `passed`, case Pass again: do nothing. Tell the user `bug #<n> already passed, waiting for QA to close`.
   - Open bug without `passed`, case now Pass: remove `failed`, add `passed`, comment `Round <round> (<env>, v<k>): Pass`. Do not close it. Tell QA to check it and close it.
   - No bug yet, case Fail: look at "Bugs by others" first. No candidate there: go to step 5.
5. **Draft** each new bug with the bug template. One bug per file: `<outputDir>/<ticket>-bug-<NN>.md`.
6. **Create** the bug as a child item of the ticket (GitLab: child item, Jira: sub-task, GitHub: sub-issue), with "Writing to the board" in the profile. Title: the `[Bug] …` line. Label: `Bug`. Assignee: `<qaAssignee>`, if any. Description: the file content. Do not ask.
7. **Summary**: fill the Bug column in `<outputDir>/verify-summary.md` (Fail and Blocked table) for these cases.
8. **Tell the user**, one line for each case: `<TC ID>: new bug <link>` / `updated bug #<n> (still Fail)` / `reopened bug #<n>` / `bug #<n> now Pass, please check and close` / `bug #<n> already passed, waiting for QA to close` / `commented on bug #<n> (<TC ID>)` / `skipped: bug #<n> was not a bug`.

## Review workflow
1. Read the bug issue, the case in the `QA test cases` sub-issue of the version in that round's verify report, the verify report of that round in `<outputDir>`, and `qa-lessons.md`.
2. Ask QA what they saw when they ran the steps by hand. One question at a time.
3. Talk with QA to find the cause: test case wrong (missing step, wrong Expected, wrong test data), verify run wrong (checked too early, wrong element, wrong role, not signed in), environment (dirty data, env down), tool limit (the browser tool cannot do it), PO rule not confirmed. Show the evidence from the report. QA confirms the cause. Do not guess.
4. Write the incident record `<outputDir>/incidents/<ticket>-incident-<NN>.md`.
5. Add a row to `<outputDir>/qa-lessons.md` (create it if missing): ID `L-<NNN>`, Applies to (`write-test-cases` / `verify` / `both`), Feature, Lesson (one sentence: what to do next time), Incident record, Added.
6. Ask: `Comment on bug #<n> with the cause and close it as not a bug? yes/no`. Yes: comment with the cause and the record path, add label `not-a-bug`, close it. Always ask before closing.
7. Tell QA the record path and the lesson ID. The test case is wrong? Suggest `/ba-qa-kit:write-test-cases <ticket>` to fix it.

## Bugs by others
Bugs that others logged are never changed, only commented, and only after the user confirms.
- **Where to look**: only these, for the tickets of this run. Never list or search the whole board. Only open bugs.
  - child items of the ticket with label `Bug` or a title that starts with `[Bug]`, that this skill did not log;
  - issues linked to the ticket (related, blocks…) with the same label or title;
  - bugs the user named (`--bugs`, `link`), the `Related bug: #<n>` note of a case, and the Bug column of `verify-summary.md`.
- **Match**: Strong when the bug mentions the TC ID (description or a comment), the user named it, or two or more of these are the same as in the case: the Expected message, the input value in the steps, the field names. Weak when only one is.
- **Ask once** (together with `Log bugs now?` when `/ba-qa-kit:verify` calls this skill). Strong first.
  ```
  | # | Bug (link) | Status | Case (this run) | Result | Match | Why |
  |---|---|---|---|---|---|---|
  | 1 | #6 <title> <link> | Open | TC-1-09 <test case> | Pass | Strong | Same message and same value 1000 |
  Comment on these? yes / no / only 1,3
  ```
  A Fail case with a candidate waits for the answer: yes = comment on that bug, no new bug; no = create a new bug as usual.
- **After yes**: add a comment only: `QA verify – Round <round> (<env>, v<k>): <TC ID> <result>` and `Verify comment: <link>`. A Fail adds `Step <n>: <what>`. Do not change labels, state or description. Write `#<n> (by others)` in the Bug column of `verify-summary.md`. After no: write `not related #<n>` there and do not ask again for that pair.
- **Later rounds**: a bug whose comments already hold the TC ID, or that the Bug column marks as by others, is linked: comment without asking and tell the user. `verify-summary.md` stays on one machine, so a bug may show no sign of an earlier confirmation on another machine; then ask again with the table.

## Rules
- Simple words. Title says what is wrong, not how to fix it. Steps start from a clear state and can be followed by someone new.
- Expected must name its source (AC, rule ID, design, or the profile's standard). No source? It is a PO question. Only exception: a clear defect (step 3).
- Only facts you saw or the user gave. Do not guess the cause.
- Never write passwords, tokens or personal data. Blur them in screenshots.
- GitLab labels are case-sensitive: use the board's exact name for each role (profile Labels line). A label does not exist (`Bug`, `failed`, `passed`, `not-a-bug`)? Do the work without it and tell the user which label to create.
- Never change the ticket or issues you did not log. On a bug you logged you may only: comment, add or remove `failed` and `passed`, add `not-a-bug`, reopen it, and close it after yes. On a bug someone else logged you may only add a comment, after the user confirmed. Write files only in `outputDir`.

## Severity
- **Critical**: blocks a main flow, data loss or security issue, no workaround.
- **High**: main feature wrong, workaround is hard.
- **Medium**: feature wrong, easy workaround.
- **Low**: text, layout or small issue.
