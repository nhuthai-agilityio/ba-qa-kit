---
name: track-ticket-status
description: Daily read-only status report for the current GitLab sprint, showing what moved, what is blocked, stale or sent back, and which client questions hold work. Use when it is time for the daily check, or when asked for ticket status, a standup summary or what is blocked.
---

# Track Ticket Status

Run daily. Report the current sprint's tickets so the BA knows what needs action today. Never change the board.

## Steps

1. **First run only**, ask: the GitLab project, whether the sprint is an iteration or a milestone, and where the Questions List file is. Save the answers to `ba-output/track-ticket-status.json` (no tokens or personal data). Both this file and the report go to `ba-output/` in the current folder; create it if missing, no need to ask. Later runs read that file instead of asking. If the file can't be read or its project path differs from the one the user names, ask again.
2. **Find the current sprint** (dates include today). Note its name, end date and days left. No current sprint, or the iteration or milestone can't be read? Say so and ask the user to paste the sprint board.
3. **Read all its tickets**: status, labels, assignee, last update, comments. Period: since the date of the latest `ba-output/status-*.md`, or the previous working day if there is none (on Monday, since Friday).
4. **Mark each ticket** (it can have more than one):
   - **Moved** — status changed in the period.
   - **Done** — closed or moved to the Done list in the period.
   - **Blocked** — label `blocked` or `pending-questions`, or a comment says so.
   - **Stale** — not Done, no update for 2+ working days. "Update" is the latest comment or status change, whichever is newer.
   - **Sent back** — moved backward or reopened.
   - **Late start** — still To do with under 30% of the sprint's working days left (counted from today to the end date).
5. **Check questions.** If the Questions List file is missing or has no matching Q<n>, skip this step and note it in the report. For each `Pending Q<n>` in a ticket's Notes, find Q<n> in the Questions List:
   - `→ Pending` → **Pending**.
   - `→ Answer …` but the ticket still says Pending → **Answered, ticket not updated**.
6. **Write the report** with `assets/template.md`. Show it in chat and save it to `ba-output/status-<YYYY-MM-DD>.md` (ask before saving anywhere else), then show the progress line.

## Rules

- Read-only. Draft a comment or message if asked; post only after go.
- Only the current sprint's tickets.
- Every line has the issue `#` and the date of the change.
- Stale is about days without updates, never about people. Working days are Monday to Friday; public holidays are not counted unless the user says so.
- Questions: Pending for 2+ days, counted from the date the question was asked (the Questions List date, else the date of the ticket comment that first mentions it; if neither, say the age is unknown) → add "Check for a client reply", and suggest `collect-client-answers` if it is installed. Answered → suggest updating the user stories, then the board tickets.
- Nothing moved → write "No change today", skip Moved and Done for tickets that moved in the period (there are none), keep Needs action.
- GitLab not connected → ask the user to paste the sprint board.
- Chat in the user's language; the report in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
<sprint>   ✔ track-ticket-status
Next: <n> blocked, <n> stale, <n> sent back, <n> answers to apply (the number of "Answered, ticket not updated" rows). Reply: update / draft / stop.
```

- **update** → suggest `/ba:write-user-stories` to update the user stories, then `/ba:write-stories-to-board` to update the board tickets. If one is not installed, stop and list what needs updating.
- **draft** → draft comments or a client follow-up; post only after go.
- **stop** → end here.
