---
name: collect-answers
description: Collects the client's or PO's answers to a Questions List (pasted text, email, Slack thread, ticket comment or Drive doc), matches each answer to its question, flags unclear or conflicting answers, and writes the answers directly into the Questions List. Use when the user shares a client reply or asks to collect, record or update answers.
---

# Collect Answers

Write the client's answers directly into the Questions List. Never invent or guess an answer.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, sources, Google Doc, progress line) and `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (reading the board).

## Input and output

- **Needs** (from the user): the client's reply (pasted text or a Slack, email, ticket or Drive link).
- **Reads**: the reply, the ticket's Questions List, and the ticket and Drive docs (to find conflicts).
- **Writes**: the answers into `ba-output/question-list-<name>.md`, after go; never a new file. The team keeps the list in a Google Doc? Also the answer lines as text to paste there.
- **Next**: `/ba-qa-kit:find-gaps` for a new round (loop), or `/ba-qa-kit:write-stories`.

## Steps

1. **Get the reply and the list.** If not given, ask: "Please paste the client's reply (or share the link)." The Questions List is `ba-output/question-list-<name>.md`, else the Google Doc the user links (read it); neither: ask for it. A ticket link: read it the board's way (`project-profile.md`). A Slack, Gmail or Drive link: with that connector if this session has it. Anything that can't be opened: ask the user to paste it.
2. **Match** each part of the reply to a question number (`Q<n>`, or `Q<n><letter>` for a sub-question). If the client didn't use numbers, match by content. If a part fits no question or more than one, mark it **Unmatched**.
3. **Classify** each question:
   - **Answered** — clear and complete.
   - **Partly answered** — vague ("as usual", "ok", "maybe") or covers only part → add a follow-up.
   - **Not answered** — nothing in the reply → Pending.
   - **Conflict** — disagrees with the ticket, a Drive doc or an earlier answer.
4. **Show a short summary in chat** (one line per question: number, status, note), plus any Unmatched parts, and name the file or doc that will be updated. Then **stop and show the progress line**. Do not change the file until the user replies; their **go** covers writing to that file or doc.
5. **On go, update the Questions List** following the Answers section of `${CLAUDE_PLUGIN_ROOT}/skills/write-questions/assets/template.md`: under each question or sub-question, `→ Answer (<role>, <Mon DD, YYYY>): <client's words>`. Do not create a new file. The list lives in a Google Doc: update the local copy (create it from the doc if missing) and give the answer lines, each under its question number, as text to paste into the doc.
6. **Check the file** after writing: read it again and confirm every answer line and every follow-up named in the summary is there, under the right number. Something missing: add it, and say what was fixed. Report only what the file holds.

## Rules

- Keep the client's words; add the answerer's role (for example PO, never a personal name; not stated: `Client`) and the date.
- Skip passwords, tokens and personal data (names, emails, phone numbers) from the reply; write "[removed]" instead.
- Never renumber or delete questions.
- A vague answer is never treated as Answered.
- Never pick a side in a Conflict; ask the user, and write it only after they decide.
- Unmatched parts stay in chat; they are not written to the file.
- A new answer to an already answered question is added as a new Answer line, not replacing the old one.
- Chat in the user's language; the Questions List in English.

## Progress

The line and its marks are in `ba-files.md`.

After the summary:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ▶ collect-answers · ○ write-stories
Next: write the answers into the Questions List. Reply go, tell me what to change, or stop.
```

After the update:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ✔ collect-answers · ▶ write-stories
Next: <n> pending, <n> follow-ups, <n> conflicts. Reply loop to find new gaps (Round <n+1>), go for /ba-qa-kit:write-stories, or stop.
```

- **loop** → run `/ba-qa-kit:find-gaps` again with the updated Questions List as a source (next round). Suggest loop when there are follow-ups, conflicts or answers that add new rules; suggest go when all High questions are answered.
- **go** → do the next step (after the update: `/ba-qa-kit:write-stories`).
- **Change request** → fix it, then show the progress line again.
- **stop** → end here.
