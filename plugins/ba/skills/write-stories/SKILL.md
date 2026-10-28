---
name: write-stories
description: Writes a user story doc that dev and QA can build and test from — stories with acceptance criteria, validation and error handling, and edge cases — using the GitLab issue, Drive docs, Gap Report and the answered Questions List. Use when the Questions List has answers, or when asked for user stories, acceptance criteria or A/C.
---

# Write Stories

Turn the requirements and client answers into short, testable user stories. Never invent facts.

## Input and output

- **Needs** (from the user): the ticket; a design link and a Google Doc link (optional).
- **Reads**: the GitLab issue, the Drive docs, the ticket's Questions List, the latest `gap-report-<name>-r<n>.md`, the design and the latest story version.
- **Writes**: `ba-output/user-stories-<name>-v<n>.md` (a new version each time), or the Google Doc given.
- **Next**: review the draft, then `/ba:stories-to-board`; new questions: `/ba:find-gaps` (loop).

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/ba:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.
- **`<name>`** in file names: the GitLab issue number without `#` (for example `412`). No ticket: a lowercase slug of the requirement (for example `login-flow`), and the progress line shows `#-`.
- **Files per ticket**: `gap-report-<name>-r<n>.md`, `question-list-<name>.md` (one Questions List per ticket), `user-stories-<name>-v<n>.md`. The latest is the one with the highest `r<n>` or `v<n>`.

## Inputs

Read all before writing:

- **GitLab issue** and **Google Drive docs** — the sources.
- **Questions List** with answers (`question-list-<name>.md` or the Google Doc the user gives) — answers are confirmed facts; `→ Pending` questions are open.
- **Gap Report** (the latest `gap-report-<name>-r<n>.md`) — open gaps become pending items.
- **Design** (optional) — field names, labels, messages, states. If missing, say so in the header.

If the Questions List or sources are missing, ask for them, or suggest running `/ba:find-gaps` first (if it is not installed, ask the user to paste the gaps). No Gap Report but the other inputs are present? Go on and write from the sources and the answers. If the GitLab or Google Drive connector is not available, ask the user to paste the content.

## Steps

1. **List the stories**: one per user capability, in user-flow order, numbered `US-01`, `US-02`… Keep existing numbers if a previous version exists.
2. **Collect** for each story its rules, flow steps, screens and related questions.
3. **Write** each story with `assets/template.md`, keeping its section order. If the user gives another template, follow that template's sections and keep the A/C, error handling and edge-case content.
4. **Check** each story before saving, and fix what fails:
   - **Format**: the A/C starts with `The <user or role> can <capability>.`; each bullet is one full sentence with one behavior; bullets follow the flow in order; screens are named in **bold**.
   - **Content**: every answered question and rule for this feature appears in an A/C or error line; every screen state (empty, loading, error, success) is covered or raised as a question; no A/C is written from a pending question.
5. **Save the draft** (see File below), **show it**, then **stop and show the progress line**. Later edits update the saved file.

## Rules

- **Clear A/C**: a teammate reading only the A/C knows the flow and the screens. One observable behavior per bullet, with real values ("an approved company email domain", "max 50 characters"), never "valid", "quickly", "properly".
- **Open items stay pending**: write `Pending Q<n> – <short title>` (`Q<n>` is question n of the Questions List; a sub-question is `Q<n><letter>`, for example `Q2a`) in error handling, edge cases or notes — never inside A/C.
- **Conflict** between design and sources: follow the sources in the A/C, and write the conflict in that story's **Notes** (`Conflict – design shows X, <source> says Y. Following <source> until confirmed.`). Also list it in chat as a new question for the next loop.
- **Questions live only in the Questions List.** The story doc has no question or pending sections. New questions found while writing are listed in chat; on **loop** they go into the Questions List (`ba-output/question-list-<name>.md`, kept by `/ba:write-questions`). If that skill is not installed, list the new questions in chat only.
- **Google Doc**: only when the user gives its link. Write with the Google Drive connector: show the doc name and ask once before writing, keep its existing content and styles, and add only the new content. If the connector is missing or the doc can't be edited, say so and give the text to paste.
- **File**: without a Google Doc, save to `ba-output/user-stories-<name>-v<n>.md`. Older runs saved stories with no ticket as `user-stories-no-ticket-v<n>.md`; if no `<name>` file exists, look for that one too. For a new version, use the highest `-v<n>` in `ba-output/` plus 1; if the user edited an earlier version, build on that edited file. Fill the template's date from today's date, as `Mon DD, YYYY`.
- **Style**: basic English, short lines, exact UI labels in **bold**, real example data. Chat in the user's language; the doc in English.

## Edge cases

- **Update after new answers**: build on the latest saved version (including the user's edits) and save a new version (`-v2`, `-v3`… in the file name), keep story numbers and the user's edits, add "What changed" in 3–5 lines at the top.
- **Story seems missing from the sources**: don't add it; list it in chat as a new question.
- **Every question still pending**: write only what is confirmed; mark the rest inline as `Pending Q<n>`.

## Progress

The progress line only suggests the next step. The user can run any skill at any time. Mark steps ✔ if they ran in this chat, ▶ for the step the user's go runs next (this step, if it waits for go before writing), and ○ for the others (not run, or not installed).

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ✔ collect-answers · ✔ write-stories · ▶ stories-to-board
Next: <n> stories, <n> pending, <n> new questions. Review the draft manually, then reply go to put the stories on the board, loop to ask the new questions, changes, or stop.
```

- **go** → suggest `/ba:stories-to-board` to put the stories on the board (after your review). If it is not installed, stop with the story doc as the result.
- **Change request** → update the draft, then show the progress line again.
- **loop** → run `/ba:find-gaps` with the new questions as gaps (next round). If that skill is not installed, say so and give the new questions as the result.
- **stop** → end here.
