---
name: collect-answers
description: Collects the client's or PO's answers to a Questions List (pasted text, email, Slack thread, GitLab comment or Drive doc), matches each answer to its question, flags unclear or conflicting answers, and writes the answers directly into the Questions List. Use when the user shares a client reply or asks to collect, record or update answers.
---

# Collect Answers

Write the client's answers directly into the Questions List. Never invent or guess an answer.

## Steps

1. **Get the reply and the list.** If not given, ask: "Please paste the client's reply (or share the link) and the Questions List it answers." Read links with the connected app (Slack, Gmail, GitLab, Google Drive); if one can't be opened, ask the user to paste it.
2. **Match** each part of the reply to a question number. If the client didn't use numbers, match by content. If a part fits no question or more than one, mark it **Unmatched**.
3. **Classify** each question:
   - **Answered** — clear and complete.
   - **Partly answered** — vague ("as usual", "ok", "maybe") or covers only part → add a follow-up.
   - **Not answered** — nothing in the reply → Pending.
   - **Conflict** — disagrees with the GitLab issue, a Drive doc or an earlier answer.
4. **Show a short summary in chat** (one line per question: number, status, note), plus any Unmatched parts, and name the file or doc that will be updated. Then **stop and show the progress line**. Do not change the file until the user replies; their **go** covers writing to that file or doc.
5. **On go, update the Questions List** following the Answers section of `assets/template.md` in the `write-questions` skill. If that skill or file is not installed, say so and use this shape: under each question, `Answer (<who>, <Mon DD, YYYY>): <client's words>`. Do not create a new file. If the file or doc can't be edited (e.g. no access), give the user the updated text to paste.

## Rules

- Keep the client's words; add who answered and the date as `Mon DD, YYYY` (e.g. `Oct 26, 2026`).
- Skip passwords, tokens and personal data (names, emails, phone numbers) from the reply; write "[removed]" instead.
- Never renumber or delete questions.
- A vague answer is never treated as Answered.
- Never pick a side in a Conflict; ask the user, and write it only after they decide.
- Unmatched parts stay in chat; they are not written to the file.
- A new answer to an already answered question is added as a new Answer line, not replacing the old one.
- If the Questions List is a Google Doc, write into it with the Google Drive connector and keep its formatting. Ask before writing to a Google Doc or to a file outside the current folder.
- Chat in the user's language; the Questions List in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time; skills that are not installed are shown as ○.

After the summary:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ▶ collect-answers · ○ write-stories
Next: write the answers into the Questions List. Reply go, tell me what to change, or stop.
```

After the update:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ✔ collect-answers · ○ write-stories
Next: <n> pending, <n> follow-ups, <n> conflicts. Reply loop to find new gaps (Round <n+1>), go for write-stories, or stop.
```

- **loop** → run `find-gaps` again with the updated Questions List as a source (next round). Suggest loop when there are follow-ups, conflicts or answers that add new rules; suggest go when all High questions are answered.
- `#<ticket>`: GitLab issue number. `<requirement>`: short feature name.
- **go** → do the next step (after the update: `write-stories`). If that skill (or `find-gaps` for loop) is not installed, tell the user it isn't installed and stop.
- **Change request** → fix it, then show the progress line again.
- **stop** → end here.
