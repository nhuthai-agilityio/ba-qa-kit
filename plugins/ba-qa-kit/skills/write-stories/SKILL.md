---
name: write-stories
description: Writes user stories with acceptance criteria, error handling and edge cases from the ticket, Drive docs, Gap Report and answered Questions List; after one go, creates or updates one GitLab issue per story in Backlog. Use when the Questions List has answers, or when asked for user stories, A/C, or to put reviewed stories on the board.
---

# Write Stories

Turn the requirements and client answers into short, testable user stories, then put them on the GitLab board after one go. Never invent facts.

Imported below: the profile reference (the **Board** and **Sprints** lines, reading and writing the board) and the BA files rules (files, sources, Google Doc, progress line).
@${CLAUDE_PLUGIN_ROOT}/references/project-profile.md
@${CLAUDE_PLUGIN_ROOT}/references/ba-files.md

## Input and output

- **Needs** (from the user): the ticket (the parent issue); a design link (optional).
- **Reads, all before writing**: the GitLab issue and Drive docs (the sources); the Questions List with answers (`question-list-<name>.md` or the Google Doc the user gives; answers are confirmed facts, `→ Pending` questions are open); the latest `gap-report-<name>-r<n>.md` (open gaps become pending items); the design (optional: field names, labels, messages, states; if missing, say so in the header); the latest story version; for the board, the profile's Board and Sprints lines, the board's lists, the project's labels and the parent's child or linked issues (read-only).
- **Writes**: `ba-output/user-stories-<name>-v<n>.md` (a new version each time); after go, GitLab issues (created or updated) and `Ticket: #<n>` in each story's Notes.
- **Next**: `/ba-qa-kit:track-status` to follow progress; new questions: `/ba-qa-kit:find-gaps` (loop).

If the Questions List or sources are missing, ask for them, or suggest running `/ba-qa-kit:find-gaps` first (or ask the user to paste the gaps). No Gap Report but the other inputs are present? Go on and write from the sources and the answers. Sources that can't be read: see "Sources" in `ba-files.md`.

**Board only**: the user asks to put an existing story doc on the board ("push", "to the board", "create tickets")? Skip steps 1–5 and use the latest `user-stories-<name>-v<n>.md` (or a story doc the user links, read only); the summary's first line becomes `Using: <file or doc> (<n> stories).`

## Steps

1. **List the stories**: one per user capability, in user-flow order, numbered `US-01`, `US-02`… Keep existing numbers if a previous version exists.
2. **Collect** for each story its rules, flow steps, screens and related questions.
3. **Write** each story with `${CLAUDE_PLUGIN_ROOT}/templates/write-stories.md`, keeping its section order. If the user gives another template, follow that template's sections and keep the A/C, error handling and edge-case content.
4. **Check** each story before saving, and fix what fails:
   - **Format**: the story starts with `<User or role> can <capability>. (US-nn)`, the same capability as its heading; the A/C are grouped under bold screen or flow-step bullets in flow order; each nested bullet is one full sentence with one behavior; screens and buttons are named in **bold**; Notes give the requirement, the source and the design.
   - **Content**: every answered question and rule for this feature appears in an A/C or error line; every screen state (empty, loading, error, success) is covered or raised as a question; no A/C is written from a pending question.
5. **Save the draft** (see File below). Don't paste the stories in chat; the user reviews the file.
6. **Board** (read-only until go): read `${CLAUDE_PLUGIN_ROOT}/references/write-stories-board.md`. Plan the board, show the review summary, then **stop and show the progress line**.
7. **On go**: follow "On go" in the board file. Its text is no longer in this conversation (a later turn, or after a compaction)? Read the file again first.

## Rules

- **Clear A/C**: a teammate reading only the A/C knows the flow and the screens. Real values, and an example when a rule is easy to misread; never "valid", "quickly", "properly".
- **Open items stay pending**: write `Pending Q<n> – <short title>` (`Q<n>` is question n of the Questions List; a sub-question is `Q<n><letter>`, for example `Q2a`) in error handling, edge cases or notes — never inside A/C.
- **Conflict** between design and sources: follow the sources in the A/C, and write the conflict in that story's **Notes** (`Conflict – design shows X, <source> says Y. Following <source> until confirmed.`). Also list it in chat as a new question for the next loop.
- **Questions live only in the Questions List.** The story doc has no question or pending sections. New questions found while writing are listed in chat; on **loop** they go into the Questions List (kept by `/ba-qa-kit:write-questions`).
- **File**: save to `ba-output/user-stories-<name>-v<n>.md`; the team keeps stories in a Google Doc: also give the text to paste (see `ba-files.md`). For a new version, use the highest `-v<n>` in `ba-output/` plus 1; if the user edited an earlier version, build on that edited file. Fill the template's date from today's date.
- **Style**: basic English, short lines, exact UI labels in **bold**, real example data. Chat in the user's language; the doc and issues in English.

## Edge cases

- **Update after new answers**: build on the latest saved version, keep story numbers and the user's edits, and add "What changed" in 3–5 lines at the top.
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

- **go** → step 7.
- **Change request** → update the draft, then show the summary and the progress line again.
- **loop** → run `/ba-qa-kit:find-gaps` with the new questions as gaps (next round); nothing goes to the board.
- **stop** → end here; nothing goes to the board.
