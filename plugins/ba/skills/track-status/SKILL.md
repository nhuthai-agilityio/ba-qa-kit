---
name: track-status
description: Daily read-only status report for the current GitLab sprint, showing how much of the sprint is done, what moved, what is blocked, stale or sent back, and which client questions hold work. Use when it is time for the daily check, or when asked for ticket status, a standup summary or what is blocked.
---

# Track Status

Run daily. Report the current sprint's tickets so the BA knows what needs action today. Never change the board.

## Input and output

- **Needs** (from the user): nothing; it runs on the current sprint.
- **Reads**: `ba.project`, `ba.sprintType`, `ba.sprintPrefixes`, the sprint's tickets and comments, the latest `ba-output/status-*.md` and each ticket's Questions List.
- **Writes**: `ba-output/status-<YYYY-MM-DD>.md`, also shown in chat. Never changes the board.
- **Next**: **update** (`/ba:write-stories`, then `/ba:stories-to-board`) or **draft** a follow-up.

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/ba:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.

## Steps

1. **Get the config** (see Config): `project`, `sprintType` (iteration or milestone) and `sprintPrefixes`. Missing? Ask once and save the answers to `ba-output/track-status.json` (no tokens or personal data). If the project path differs from the one the user names, ask again.
2. **Find the current sprint**: if `sprintType` is milestone and `sprintPrefixes` is set, each product's newest open `<prefix> - SPR <n>` milestone. Otherwise (`sprintType` is iteration, or no prefixes), the iteration or milestone whose dates include today. Note its name, start date, end date and days left. No current sprint, or the iteration or milestone can't be read? Say so and ask the user to paste the sprint board.
3. **Read all its tickets**: status, labels, assignee, last update, comments. Period: since the date of the latest `ba-output/status-*.md`, or the previous working day if there is none (on Monday, since Friday).
4. **Mark each ticket** (it can have more than one):
   - **Moved** — status changed in the period.
   - **Done** — closed or moved to the Done list in the period.
   - **Blocked** — label `blocked` or `pending-questions`, or a comment says so.
   - **Stale** — not Done, no update for 2+ working days. "Update" is the latest comment or status change, whichever is newer.
   - **Sent back** — moved backward or reopened.
   - **Late start** — still To do with under 30% of the sprint's working days left (counted from today to the end date).
5. **Measure progress** for each sprint (one per product when there are prefixes):
   - **Done %** = all tickets closed or in the Done list now (not only those done in the period) ÷ all tickets in the sprint. Count tickets, not weight or points; round to a whole number.
   - **Time used %** = working days from the sprint start up to yesterday ÷ all working days of the sprint. Today is left out because its work is not finished yet (Late start counts the days left from today).
   - **Behind** when the rounded Done % is more than 20 points under the rounded Time used %; otherwise **On track**.
   - No start or end date: show Done % only and write the fallback Progress line from the template. No tickets: write `Progress: No tickets`.
6. **Check questions.** Each requirement has its own Questions List, named after its parent ticket: `ba-output/question-list-<n>.md`, where `<n>` is the ticket's parent issue (story issues from `/ba:stories-to-board`) or the ticket itself, or the Google Doc linked in the ticket. If it is missing or has no matching Q<n>, skip that ticket and note it in the report. For each `Pending Q<n>` in a ticket's Notes, find question n (or sub-question `Q<n><letter>`, for example `Q2a`) in that ticket's list:
   - `→ Pending` → **Pending**.
   - `→ Answer …` but the ticket still says Pending → **Answered, ticket not updated**.
7. **Write the report** with `assets/template.md`. Show it in chat and save it to `ba-output/status-<YYYY-MM-DD>.md`, then show the progress line.

## Rules

- Read-only. Draft a comment or message if asked; post only after go.
- Only the current sprint's tickets.
- Every line has the issue `#` and the date of the change.
- Stale is about days without updates, never about people. Working days are Monday to Friday; public holidays are not counted unless the user says so.
- Questions: Pending for 2+ days, counted from the date the question was asked (the Questions List date, else the date of the ticket comment that first mentions it; if neither, say the age is unknown) → add "Check for a client reply", and suggest `collect-answers` if it is installed. Answered → suggest updating the user stories, then the board tickets.
- Nothing moved → write "No change today", skip Moved and Done for tickets that moved in the period (there are none), keep Needs action.
- GitLab not connected → ask the user to paste the sprint board.
- Chat in the user's language; the report in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
<sprint>   ✔ track-status
Next: <n>% done (<On track / Behind>), <n> blocked, <n> stale, <n> sent back, <n> answers to apply (the number of "Answered, ticket not updated" rows). Reply: update / draft / stop.
```

- Several products: one `<prefix> <n>% (<On track / Behind>)` per product, in the order of `sprintPrefixes`.
- **update** → suggest `/ba:write-stories` to update the user stories, then `/ba:stories-to-board` to update the board tickets. If one is not installed, stop and list what needs updating.
- **draft** → draft comments or a client follow-up; post only after go.
- **stop** → end here.
