---
name: write-user-stories
description: Writes a user story doc that dev and QA can build and test from — stories with acceptance criteria, validation and error handling, and edge cases — using the GitLab issue, Drive docs, Gap Report and the answered Questions List. Use when the Questions List has answers, or when asked for user stories, acceptance criteria or A/C.
---

# Write User Stories

Turn the requirements and client answers into short, testable user stories. Never invent facts.

## Inputs

Read all before writing:

- **GitLab issue** and **Google Drive docs** — the sources.
- **Questions List** with answers — answers are confirmed facts; `→ Pending` questions are open.
- **Gap Report** — open gaps become pending items.
- **Design** (optional) — field names, labels, messages, states. If missing, say so in the header.

If the Questions List or sources are missing, ask for them, or suggest running `find-requirement-gaps` first (if it is not installed, ask the user to paste the gaps). No Gap Report but the other inputs are present? Go on and write from the sources and the answers. If the GitLab or Google Drive connector is not available, ask the user to paste the content.

## Steps

1. **List the stories**: one per user capability, in user-flow order, numbered `US-01`, `US-02`… Keep existing numbers if a previous version exists.
2. **Collect** for each story its rules, flow steps, screens and related questions.
3. **Write** each story with `assets/template.md`: A/C, then validation & error handling, then edge cases.
4. **Check** each story:
   - Every answered question and rule for this feature appears in an A/C or error line.
   - Every screen state (empty, loading, error, success) is covered or raised as a question.
   - No A/C is written from a pending question.
5. **Show the draft**, then **stop and show the progress line**.

## Rules

- **Testable**: one observable result per A/C, with real values ("max 50 characters", "within 2 seconds"), never "valid", "quickly", "properly".
- **Open items stay pending**: write `Pending Q<n> – <short title>` in error handling, edge cases or notes — never inside A/C.
- **Conflict** between design and sources: follow the sources in the A/C, and write the conflict in that story's **Notes** (`Conflict – design shows X, <source> says Y. Following <source> until confirmed.`). Also list it in chat as a new question for the next loop.
- **Questions live only in the Questions List.** The story doc has no question or pending sections. New questions found while writing are listed in chat; on **loop** they go into the Questions List (the file kept by `create-question-list`, updated by that skill). If that skill is not installed, list the new questions in chat only.
- **Google Doc**: if the user gives a Google Doc link, write directly into that doc with the Google Drive connector — keep its existing content and styles, add only the new content. Show the doc name and ask before writing into it. If the doc can't be edited, give the text to paste.
- **File**: without a Google Doc, save to `ba-output/user-stories-<ticket>-v<n>.md` in the current folder (ask before saving anywhere else). Use `no-ticket` in the file name when there is no ticket. Fill the template's date from today's date, as `Mon DD, YYYY`.
- **Style**: basic English, short lines, exact UI labels in **bold**, real example data. Chat in the user's language; the doc in English.

## Edge cases

- **Update after new answers**: save a new version (`-v2`, `-v3`… in the file name), keep story numbers and the user's edits, add "What changed" in 3–5 lines at the top.
- **Story seems missing from the sources**: don't add it; list it in chat as a new question.
- **Every question still pending**: write only what is confirmed; mark the rest inline as `Pending Q<n>`.

## Progress

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ✔ collect-client-answers · ✔ write-user-stories
Next: <n> stories, <n> pending, <n> new questions. Review the draft manually, then reply go for write-stories-to-board, loop to ask the new questions, changes, or stop.
```

- Show ✔ only for steps that ran in this chat; steps that did not run, or whose skill is not installed, show ○.
- **go** → run `write-stories-to-board` (after your review). If that skill is not installed, say so and stop with the story doc as the result.
- **Change request** → update the draft, then show the progress line again.
- **loop** → run `find-requirement-gaps` with the new questions as gaps (next round). If that skill is not installed, say so and give the new questions as the result.
- **stop** → end here.
