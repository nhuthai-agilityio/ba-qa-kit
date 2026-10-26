---
name: create-question-list
description: Creates a short, clear clarification question list for the client or PO from a Gap Report, in the team template. Use when the user asks to create a question list, Q&A list or questions for the client, or a Gap Report is ready.
---

# Create Question List

## Steps

1. **Get the Gap Report.** If none exists, run `find-requirement-gaps` first and wait at its progress line for the user's go. If that skill is not installed, ask the user to paste the gaps. A Gap Report is a list of gaps, each with an impact (High, Medium or Low), the screen or part it belongs to, and a one-line description of what is missing or unclear.
2. **Load the template** from `assets/template.md` (a template the user provides replaces it completely).
3. **Group** questions by part and screen, in user-flow order (login → home → features → settings).
4. **One question per gap**; High-impact first. Every High gap must have a question.
5. **Skip** anything the GitLab issue (read with the GitLab connector or `glab`), the Drive docs (Google Drive connector) or an earlier Questions List already answers.
6. **Loop round:** add the new questions to the same Questions List file, never a new one. Find it from the Google Doc link the user gives, otherwise in `ba-output/` (if several `question-list-*.md` files exist, pick the one matching the ticket or requirement, else ask); if none exists, ask the user for the link or file. Put them under a new part `ROUND <n> — <Mon DD, YYYY>` at the end, with numbering continuing from the last question.
7. **Deliver** into the user's Google Doc if one is given (see Rules), otherwise save it to `ba-output/question-list-<name>.md` in the current folder (ask before saving anywhere else), then show the progress line.

## Question style

- **Short**: one sentence, under 20 words.
- **Concise**: no filler.
- **Clear**: one point; name the exact screen, icon or field.
- Prefer yes/no or A-or-B. Split long questions into sub-questions.

Patterns: "Is it right if we assume...?" · "RE `<X>`, we will `<Y>`, right?" · "`<Flow>`. Please help confirm." · "Please specify..." · "Please clarify..." · "`<A>` shows X, `<B>` shows Y. Which is correct?" · "What happens when...?"

## Rules

- **Template values**: `<App Name>` and `<source>` (for example UI/UX, PRD, ticket) come from the ticket or docs; ask the user if they don't name them.
- **Date**: use today's date as `Mon DD, YYYY` (for example `Aug 03, 2026`) for the title and round dates.
- **File name**: `<name>` is the GitLab issue number, or a lowercase slug of the requirement (for example `login-flow`) if there is no ticket, so the same requirement always gives the same file.
- **Google Doc**: if the user gives a Google Doc link, write directly into that doc with the Google Drive connector — confirm once before editing an existing doc, keep its existing content and styles, add only the new content. If the connector is missing, not signed in, or the doc can't be edited, say so and give the text to paste. If the GitLab issue or Drive docs can't be read (no connector, not signed in), ask the user to paste what is needed.

## Progress

The progress line only suggests the next step. The user can run any skill at any time; skills that are not installed are shown as ○. If the next skill is not installed, stop after delivering the list and say so instead of trying to run it.

End with this progress line:

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ○ collect-client-answers · ○ write-user-stories
Next: send the list to the client. When they reply, paste it to run collect-client-answers. Reply with changes, or stop.
```

- `#<ticket>`: GitLab issue number, or `#-` if there is none (the file name then uses the requirement slug). `<requirement>`: short feature name.
- Show ✔ only for steps that ran in this chat; otherwise ○.