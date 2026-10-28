---
name: write-questions
description: Creates a short, clear clarification Questions List for the client or PO from a Gap Report, in the team template. Use when the user asks to create a question list, Q&A list or questions for the client, or a Gap Report is ready.
---

# Write Questions

Turn a Gap Report into short, clear questions for the client or PO. Never invent answers.

## Input and output

- **Needs** (from the user): the ticket, or the gaps pasted; a Google Doc link (optional).
- **Reads**: the latest `gap-report-<name>-r<n>.md`, the GitLab issue, the Drive docs and the ticket's Questions List.
- **Writes**: `ba-output/question-list-<name>.md`, or the Google Doc given; a loop round adds a new part to the same list.
- **Next**: send the list to the client, then `/ba:collect-answers` with their reply.

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/ba:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.
- **`<name>`** in file names: the GitLab issue number without `#` (for example `412`). No ticket: a lowercase slug of the requirement (for example `login-flow`), and the progress line shows `#-`.
- **Files per ticket**: `gap-report-<name>-r<n>.md`, `question-list-<name>.md` (one Questions List per ticket), `user-stories-<name>-v<n>.md`. The latest is the one with the highest `r<n>` or `v<n>`.

## Steps

1. **Get the Gap Report.** If none exists, run `/ba:find-gaps` first and wait at its progress line for the user's go. If that skill is not installed, ask the user to paste the gaps. A Gap Report is a list of gaps, each with an impact (High, Medium or Low), the screen or part it belongs to, and a one-line description of what is missing or unclear.
2. **Load the template** from `assets/template.md` (a template the user provides replaces it completely).
3. **Group** questions by part and screen, in user-flow order (login → home → features → settings).
4. **One question per gap**; High-impact first. Every High gap must have a question.
5. **Skip** anything the GitLab issue (read with the GitLab connector or `glab`), the Drive docs (Google Drive connector) or an earlier Questions List already answers.
6. **Loop round:** add the new questions to the same Questions List file, never a new one. Find it from the Google Doc link the user gives, otherwise `ba-output/question-list-<name>.md`; if neither exists, ask the user for the link or file. Put them under a new part `ROUND <n> — <Mon DD, YYYY>` at the end, with numbering continuing from the last question.
7. **Deliver** into the user's Google Doc if one is given (see Rules), otherwise save it to `ba-output/question-list-<name>.md`, then show the progress line.

## Question style

- **Short**: one sentence, under 20 words.
- **Concise**: no filler.
- **Clear**: one point; name the exact screen, icon or field.
- Prefer yes/no or A-or-B. Split long questions into sub-questions.

Patterns: "Is it right if we assume...?" · "RE `<X>`, we will `<Y>`, right?" · "`<Flow>`. Please help confirm." · "Please specify..." · "Please clarify..." · "`<A>` shows X, `<B>` shows Y. Which is correct?" · "What happens when...?"

## Rules

- **Template values**: `<App Name>` and `<source>` (for example UI/UX, PRD, ticket) come from the ticket or docs; ask the user if they don't name them.
- **Date**: use today's date as `Mon DD, YYYY` (for example `Aug 03, 2026`) for the title and round dates.
- **Google Doc**: only when the user gives its link. Write with the Google Drive connector: show the doc name and ask once before writing, keep its existing content and styles, and add only the new content. If the connector is missing or the doc can't be edited, say so and give the text to paste.
- If the GitLab issue or Drive docs can't be read (no connector, not signed in), ask the user to paste what is needed.

## Progress

The progress line only suggests the next step. The user can run any skill at any time. Mark steps ✔ if they ran in this chat, ▶ for the step waiting for the user's go, and ○ for the others (not run, or not installed). If the next skill is not installed, stop after delivering the list and say so instead of trying to run it.

End with this progress line:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ○ collect-answers · ○ write-stories · ○ stories-to-board
Next: send the list to the client. When they reply, paste it to run collect-answers. Reply with changes, or stop.
```

- `#<ticket>`: GitLab issue number, or `#-` if there is none. `<requirement>`: short feature name.