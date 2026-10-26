---
name: track-ticket-status
description: Daily status report for the tickets in the current GitLab sprint — what moved, what is blocked, stale or sent back, and which client questions are holding work. Read-only. Use when it is time for the daily check, after tickets are on the board, or when asked for ticket status, a standup summary or what is blocked.
---

# Track Ticket Status

Run daily. Report the current sprint's tickets so the BA knows what needs action today. Never change the board.

## Steps

1. **First run only**, ask: the GitLab project, whether the sprint is an iteration or a milestone, and where the Questions List file is. Save the answers to `ba-output/track-ticket-status.json` (no tokens or personal data); later runs read that file instead of asking.
2. **Find the current sprint** (dates include today). Note its name, end date and days left. No current sprint, or the iteration or milestone can't be read? Say so and ask the user to paste the sprint board.
3. **Read all its tickets**: status, labels, assignee, last update, comments. Period: since the date of the latest `ba-output/status-*.md`, or the previous working day if there is none (on Monday, since Friday).
4. **Mark each ticket** (it can have more than one):
   - **Moved** — status changed in the period.
   - **Done** — closed or in the Done list.
   - **Blocked** — label `blocked` or `pending-questions`, or a comment says so.
   - **Stale** — not Done, no update for 2+ working days.
   - **Sent back** — moved backward or reopened.
   - **Late start** — still To do with under 30% of the sprint left.
5. **Check questions.** If the Questions List file is missing or has no matching Q<n>, skip this step and note it in the report. For each `Pending Q<n>` in a ticket's Notes, find Q<n> in the Questions List:
   - `→ Pending` → **Pending**.
   - `→ Answer …` but the ticket still says Pending → **Answered, ticket not updated**.
6. **Write the report** with `assets/template.md`. Show it in chat and save it to `ba-output/status-<YYYY-MM-DD>.md` (ask before saving anywhere else), then show the progress line.

## Rules

- Read-only. Draft a comment or message if asked; post only after go.
- Only the current sprint's tickets.
- Every line has the issue `#` and the date of the change.
- Stale is about days without updates, never about people. Working days are Monday to Friday; public holidays are not counted unless the user says so.
- Questions: Pending for 2+ days → add "Check for a client reply and run `collect-client-answers`". Answered → suggest `write-user-stories`, then `write-stories-to-board`.
- Nothing moved → write "No change today", skip Moved and Done, keep Needs action.
- GitLab not connected → ask the user to paste the sprint board.
- Chat in the user's language; the report in English.

## Progress

```
<sprint>   ✔ track-ticket-status
Next: <n> blocked, <n> stale, <n> sent back, <n> answers to apply. Reply update, draft, or stop. Run again tomorrow. At the end of the sprint, run draft-release-note if it is installed.
```

- **update** → run `write-user-stories`, then `write-stories-to-board`. If one is not installed, say so and stop there.
- **draft** → draft comments or a client follow-up; post only after go.
- **stop** → end here.
