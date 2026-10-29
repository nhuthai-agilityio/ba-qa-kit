---
name: write-questions
description: Creates a short, clear clarification Questions List for the client or PO from a Gap Report, in the team template. Use when the user asks to create a question list, Q&A list or questions for the client, or a Gap Report is ready.
---

# Write Questions

Turn a Gap Report into short, clear questions for the client or PO. Never invent answers: an assumption is always sent to the client to confirm and is never recorded as an answer.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, sources, Google Doc, progress line) and `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (reading the board).

## Input and output

- **Needs** (from the user): the ticket, or the gaps pasted; a Google Doc link (optional).
- **Reads**: the latest `gap-report-<name>-r<n>.md`, the GitLab issue, the Drive docs, the design (if any) and the ticket's Questions List.
- **Writes**: `ba-output/question-list-<name>.md`; a loop round adds a new part to the same list. The team keeps the list in a Google Doc? Also the new part as text to paste there (see `ba-files.md`).
- **Next**: send the list to the client, then `/ba-qa-kit:collect-answers` with their reply.

## Steps

1. **Get the Gap Report.** If none exists, run `/ba-qa-kit:find-gaps` first and wait at its progress line for the user's go. Or ask the user to paste the gaps. A Gap Report is a list of gaps, each with an impact (High, Medium or Low), the screen or part it belongs to, and a one-line description of what is missing or unclear.
2. **Load the template** from `assets/template.md` (a template the user provides replaces it completely).
3. **Group** questions by part and screen, in user-flow order (login → home → features → settings).
4. **One question per gap**; High-impact first. Every High gap must have a question, in the list or under "Ask the team first". A team point the team can't answer becomes a client question in the next round.
5. **Skip** anything the GitLab issue, the docs (see "Sources" in `ba-files.md`), the design or an earlier Questions List already answers. A point the team can answer (tech, small UI details) is not a client question: decide it as an assumption, or list it in chat under "Ask the team first" (see Progress).
6. **Loop round:** add the new questions to the same Questions List file, never a new one. Find it in `ba-output/question-list-<name>.md`, else read the Google Doc the user links; neither: ask for the link or file. Put them under a new part `ROUND <n> — <Mon DD, YYYY>` at the end, with numbering continuing from the last question.
7. **Check before sending** each question, and reword it until all four pass: Do I know the requirement? Is the name the same as in the requirement? Is it yes/no or A-or-B (open only when no answer can be assumed)? Can the client answer in 10 seconds? A "no" to the first check can't be fixed by rewording: move the point to "Ask the team first". Say in chat how many questions were reworded.
8. **Deliver**: save `ba-output/question-list-<name>.md`. A Google Doc was given: also give the new part as text to paste after its current content. Then show the progress line.

## Question rules

1. **Know the project first.** Read the requirement and the design before writing. Unsure? Ask the team first (in chat), then the client.
2. **One name for one thing.** Use the feature and screen names from the requirement, the same everywhere, so the client doesn't think they are different things.
3. **Ask only what the client knows**: needs, habits, business rules, deadlines. Decide small details yourself and write them as assumptions.
4. **Prefer yes/no assumptions.** Give an answer, then ask the client to confirm. Instead of "Is Export a separate screen?", write "We assume Export is a separate screen from Reports. Is that right?"
5. **Use the client's words** and real situations. No technical words ("tap", "API", "modal", "validation").
6. **Easy to answer.** If the client can't answer in 10 seconds, add an example or a suggested answer, or offer A or B.
7. **Short and clear**: one point per question, under 20 words where possible; split long ones into sub-questions.

Patterns: "We assume `<X>`. Is that right?" · "When `<real situation>`, we will `<Y>`. Is that right?" · "`<A>` shows X, `<B>` shows Y. We will follow `<A>`. Is that right?" · "Should `<X>` be A or B? We suggest A." Open questions ("What should happen when…? For example …") only when no answer can be assumed.

## Rules

- **Template values**: `<App Name>` is the project name from the profile's Release note line, else the ticket or docs; `<source>` (for example UI/UX, PRD, ticket) comes from the sources. Ask the user if neither names them.
- **Date**: today's date for the title and round dates.
- **Google Doc**: see `ba-files.md`.

## Progress

The line and its marks are in `ba-files.md`.

If there are team points, show them just before the progress line, one line each:

```
Ask the team first
- <screen or part>: <point> (gap <n>, <impact>)
```

End with this progress line:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ○ collect-answers · ○ write-stories
Next: send the list to the client. When they reply, paste it to run /ba-qa-kit:collect-answers. Reply with changes, or stop.
```

