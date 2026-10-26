---
name: create-question-list
description: Creates a short, clear clarification question list for the client or PO from a Gap Report, in the team template. Use when the user asks to create a question list, Q&A list or questions for the client, or a Gap Report is ready.
---

# Create Question List

## Steps

1. **Get the Gap Report.** If none exists, run `find-requirement-gaps` first and wait at its progress line for the user's go. If that skill is not installed, ask the user to paste the gaps.
2. **Load the template** from `assets/template.md` (a template the user provides replaces it completely).
3. **Group** questions by part and screen, in user-flow order (login → home → features → settings).
4. **One question per gap**; High-impact first. Every High gap must have a question.
5. **Skip** anything the GitLab issue, Drive docs or an earlier Questions List already answers.
6. **Loop round:** add the new questions to the same Questions List file, never a new one. Put them under a new part `ROUND <n> — <Mon DD, YYYY>` at the end, with numbering continuing from the last question.
7. **Deliver** into the user's Google Doc if one is given (see Rules), otherwise save it to `ba-output/question-list-<ticket>.md` in the current folder (ask before saving anywhere else), then show the progress line.

## Question style

- **Short**: one sentence, under 20 words.
- **Concise**: no filler.
- **Clear**: one point; name the exact screen, icon or field.
- Prefer yes/no or A-or-B. Split long questions into sub-questions.

Patterns: "Is it right if we assume...?" · "RE `<X>`, we will `<Y>`, right?" · "`<Flow>`. Please help confirm." · "Please specify..." · "Please clarify..." · "`<A>` shows X, `<B>` shows Y. Which is correct?" · "What happens when...?"

## Rules

- **Date**: use today's date for the title and round dates.
- **Google Doc**: if the user gives a Google Doc link, write directly into that doc with the Google Drive connector — keep its existing content and styles, add only the new content. If the connector is missing, not signed in, or the doc can't be edited, say so and give the text to paste. If the GitLab issue or Drive docs can't be read, ask the user to paste what is needed.

## Progress

End with this progress line:

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ○ collect-client-answers · ○ write-user-stories
Next: send the list to the client. When they reply, paste it to run collect-client-answers. Reply with changes, or stop.
```

- `#<ticket>`: GitLab issue number, or `#-` if there is none. `<requirement>`: short feature name.
- Show ✔ only for steps that ran in this chat; otherwise ○.