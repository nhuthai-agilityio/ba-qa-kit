---
name: write-stories
description: Writes a user story doc that dev and QA can build and test from — stories with acceptance criteria, validation and error handling, and edge cases — from the ticket, Drive docs, Gap Report and the answered Questions List; after the user's review and one go, creates or updates one ticket per story in the Backlog column, with no duplicates. Use when the Questions List has answers, when asked for user stories, acceptance criteria or A/C, or when asked to put reviewed stories on the board as tickets or issues.
---

# Write Stories

Turn the requirements and client answers into short, testable user stories, then put them on the board after one go. Never invent facts.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, sources, Google Doc, progress line) and `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (the **Board** and **Sprints** lines, reading and writing the board).

## Input and output

- **Needs** (from the user): the ticket (the parent issue); a design link (optional).
- **Reads**: the ticket, the Drive docs, the ticket's Questions List, the latest `gap-report-<name>-r<n>.md`, the design and the latest story version; for the board: the profile's Board and Sprints lines, the board's lists, the project's labels and the parent's child or linked issues (read-only).
- **Writes**: `ba-output/user-stories-<name>-v<n>.md` (a new version each time); after go, tickets (created or updated) and `Ticket: #<n>` in each story's Notes.
- **Next**: `/ba-qa-kit:track-status` to follow progress; new questions: `/ba-qa-kit:find-gaps` (loop).

## Inputs

Read all before writing:

- **The ticket** and **Google Drive docs** — the sources.
- **Questions List** with answers (`question-list-<name>.md` or the Google Doc the user gives) — answers are confirmed facts; `→ Pending` questions are open.
- **Gap Report** (the latest `gap-report-<name>-r<n>.md`) — open gaps become pending items.
- **Design** (optional) — field names, labels, messages, states. If missing, say so in the header.

If the Questions List or sources are missing, ask for them, or suggest running `/ba-qa-kit:find-gaps` first (or ask the user to paste the gaps). No Gap Report but the other inputs are present? Go on and write from the sources and the answers. Sources that can't be read: see "Sources" in `ba-files.md`.

**Board only**: the user asks to put an existing story doc on the board ("push", "to the board", "create tickets")? Skip steps 1–5 and use the latest `user-stories-<name>-v<n>.md` (or a story doc the user links, read only); the summary's first line becomes `Using: <file or doc> (<n> stories).`

## Steps

1. **List the stories**: one per user capability, in user-flow order, numbered `US-01`, `US-02`… Keep existing numbers if a previous version exists.
2. **Collect** for each story its rules, flow steps, screens and related questions.
3. **Write** each story with `assets/template.md`, keeping its section order. If the user gives another template, follow that template's sections and keep the A/C, error handling and edge-case content.
4. **Check** each story before saving, and fix what fails:
   - **Format**: the A/C starts with `The <user or role> can <capability>.`; each bullet is one full sentence with one behavior; bullets follow the flow in order; screens are named in **bold**.
   - **Content**: every answered question and rule for this feature appears in an A/C or error line; every screen state (empty, loading, error, success) is covered or raised as a question; no A/C is written from a pending question.
5. **Save the draft** (see File below). Don't paste the stories in chat; the user reviews the file.
6. **Plan the board** (read-only, nothing is written yet):
   - **Project and parent**: the profile's Board line and the parent ticket. No parent ticket? Ask for it, or for the issues to check.
   - **Backlog column**: the one in the profile's Sprints line; else read the board once. GitLab: a label list named Backlog gives its label (a list based on assignee or milestone can't be set by a label: use none). GitHub: the Backlog value of the repository's Project status field, if the repository has a Project. Jira: the Backlog status. Trello: the Backlog list. None, or it can't be set: new tickets stay in the default state; say so. Found on the board? Offer to save it in the profile.
   - **Duplicates**: US numbers restart for each requirement, so never search the whole project for `[US-nn]`. Look only at the parent's child or linked issues, matched by the `[US-nn]` title prefix. **Create**: no issue yet. **Update #n**: the issue exists and the story changed. **Skip**: no change. Two issues match one story, or the match is closed? Show it as **Check #n**; it is left out of go until the user says what to do.
   - **Labels** (see Board rules).
7. **Show the review summary**, then **stop and show the progress line**:

   ```
   Draft saved: ba-output/user-stories-412-v2.md (3 stories). Review it there.

   | US | Title | Board | Labels |
   |---|---|---|---|
   | US-01 | User can sign in with Google | Create | user story, login, pending-questions |
   | US-02 | User can log out | Update #135 | user story, login |
   | US-03 | User stays signed in | Skip (no change) | — |
   Missing labels: none · New issues go to Backlog
   ```

   The user may ask to see one ticket ("show US-01 ticket"): show only that issue text. The board can't be read: show the table without the Board column. The board can't be written (see "Writing to the board" in `project-profile.md`): say go will give ready-to-paste text.
8. **On go**, for each row:
   - **Create** the issue with `assets/ticket-template.md`, linked to the parent ticket (a child item where the tracker allows it, as on GitHub and Jira; on GitLab a relates-to link, since an issue can't be the child of an issue), with its labels and `<backlog label>`.
   - **Update** the description and add a comment with "What changed". When an A/C changed, end the comment with `QA: A/C changed. Run /ba-qa-kit:write-test-cases <n> for a new version.` (`<n>` is this story issue's number) Keep a ticked A/C checkbox ticked only when its text is unchanged. Never add or remove a list label; the issue stays in its column.
   - Write `Ticket: #<n>` into that story's **Notes** in the story doc. The go covers this.
   - **Report** each issue with its link, then show the progress line. A row that fails (for example the issue was created but a label failed): report it and go on; never retry a create. A re-run finds issues already created by their `[US-nn]` prefix, so nothing is duplicated.

## Rules

- **Clear A/C**: a teammate reading only the A/C knows the flow and the screens. One observable behavior per bullet, with real values ("an approved company email domain", "max 50 characters"), never "valid", "quickly", "properly".
- **Open items stay pending**: write `Pending Q<n> – <short title>` (`Q<n>` is question n of the Questions List; a sub-question is `Q<n><letter>`, for example `Q2a`) in error handling, edge cases or notes — never inside A/C.
- **Conflict** between design and sources: follow the sources in the A/C, and write the conflict in that story's **Notes** (`Conflict – design shows X, <source> says Y. Following <source> until confirmed.`). Also list it in chat as a new question for the next loop.
- **Questions live only in the Questions List.** The story doc has no question or pending sections. New questions found while writing are listed in chat; on **loop** they go into the Questions List (`ba-output/question-list-<name>.md`, kept by `/ba-qa-kit:write-questions`).
- **File**: save to `ba-output/user-stories-<name>-v<n>.md`; the team keeps stories in a Google Doc: also give the text to paste (see `ba-files.md`). For a new version, use the highest `-v<n>` in `ba-output/` plus 1; if the user edited an earlier version, build on that edited file. Fill the template's date from today's date.
- **Style**: basic English, short lines, exact UI labels in **bold**, real example data. Chat in the user's language; the doc and issues in English.

## Board rules

- One issue per story; the title starts with `[US-nn]`. The issue copies the story as it is (see `assets/ticket-template.md`).
- **Labels**, only if the label exists on the board; never create labels. Label names: the profile's Labels line gives the board's exact name for each role (see "Labels" in `project-profile.md`); the names below are the kit's defaults.
  - The story label (`user story`) on every story issue.
  - The feature name: the project label that matches the story's `## <FEATURE / SCREEN>` heading or the requirement name, ignoring case. No match? None.
  - The open-questions label (`pending-questions`) when the story has a `Pending Q<n>` line or a `Conflict` note.
  - Labels that don't exist are listed under "Missing labels"; the issue is created without them.
- Never close, delete or reopen issues, and never change status, column, assignee or milestone of an existing issue unless the user asks. New issues get no milestone or assignee unless the user asks.
- No passwords, tokens or personal data in issues.
- The board can't be written (see "Writing to the board" in `project-profile.md`), or a write fails: on go, give each issue as ready-to-paste text (title, labels, description, parent). Never create tickets through the tracker's page in Chrome.

## Edge cases

- **Update after new answers**: build on the latest saved version (including the user's edits) and save a new version (`-v2`, `-v3`… in the file name), keep story numbers and the user's edits, add "What changed" in 3–5 lines at the top.
- **Story seems missing from the sources**: don't add it; list it in chat as a new question.
- **Every question still pending**: write only what is confirmed; mark the rest inline as `Pending Q<n>`.
- **The user edits the file or asks for changes before go**: rebuild the summary from the latest file and show it again.

## Progress

The line and its marks are in `ba-files.md`.

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ✔ collect-answers · ▶ write-stories
Next: <n> pending, <n> new questions. Review the file, then reply go to push <n> create and <n> update to the board, tell me what to change, loop to ask the new questions, or stop.
```

After the board update, show ✔ write-stories and `Next: <n> issues need answers (label pending-questions). Run /ba-qa-kit:track-status to follow progress, or stop.`

- **go** → step 8.
- **Change request** → update the draft, then show the summary and the progress line again.
- **loop** → run `/ba-qa-kit:find-gaps` with the new questions as gaps (next round); nothing goes to the board.
- **stop** → end here; nothing goes to the board.
