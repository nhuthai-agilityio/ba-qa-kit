---
name: track-status
description: Daily read-only status report for the current sprint, showing how much of the sprint is done, what moved, what is blocked, stale or sent back, and which client questions hold work. Use when it is time for the daily check, or when asked for ticket status, a standup summary or what is blocked.
---

# Track Status

Run daily. Report the current sprint's tickets so the BA knows what needs action today. Never change the board.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (the **Board** and **Sprints** lines, reading the board, a missing line) and `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, sources).

## Input and output

- **Needs** (from the user): nothing; it runs on the current sprint.
- **Reads**: the profile's Board and Sprints lines, the sprint's tickets and comments, the latest `ba-output/status-*.md` and each ticket's Questions List.
- **Writes**: `ba-output/status-<YYYY-MM-DD>.md`, also shown in chat. Never changes the board.
- **Next**: reply `update` at the progress line (`/ba-qa-kit:write-stories`, which also updates the board tickets), or `draft` for comments or a client follow-up.

## Steps

1. **Get the sprint setup** from the profile: the project (Board line); milestones or iterations, and the product prefixes (Sprints line). Missing or `?:`: ask for that line only and offer to save it in the profile.
2. **Find the current sprint**: milestones with prefixes: each product's newest open `<prefix> - SPR <n>` milestone. Otherwise (iterations, or no prefixes), the iteration or milestone whose dates include today. Note its name, start date, end date and days left. No `<prefix> - SPR <n>` sprints (Trello, or another naming): ask how the team marks the current sprint and offer to save it in the Sprints line. No current sprint, or the iteration or milestone can't be read? Say so and ask the user to paste the sprint board.
3. **Read all its tickets**: status, labels, assignee, last update, comments. Period: since the date of the latest `ba-output/status-*.md`, or the previous working day if there is none (on Monday, since Friday).
4. **Mark each ticket** (it can have more than one):
   - **Moved** — status changed in the period.
   - **Done** — closed or moved to the Done list in the period.
   - **Blocked** — label `blocked`, or the profile's open-questions label (default `pending-questions`), or a comment says so.
   - **Stale** — not Done, no update for 2+ working days. "Update" is the latest comment or status change, whichever is newer.
   - **Sent back** — moved backward or reopened.
   - **Late start** — still To do with under 30% of the sprint's working days left (counted from today to the end date).
5. **Measure progress** for each sprint (one per product when there are prefixes):
   - **Done %** = work tickets closed or in the Done list now (not only those done in the period) ÷ all work tickets in the sprint. Count tickets, not weight or points; round to a whole number. Work tickets leave out bugs (label `Bug`, any case, or a title starting `[Bug]`), issues that only collect bugs, and `QA test cases` sub-issues; open bugs are counted on their own line.
   - **Time used %** = working days from the sprint start up to yesterday ÷ all working days of the sprint. Today is left out because its work is not finished yet (Late start counts the days left from today).
   - **Behind** when the rounded Done % is more than 20 points under the rounded Time used %; otherwise **On track**.
   - No start or end date: show Done % only and write the fallback Progress line from the template. No tickets: write `Progress: No tickets`.
6. **Check questions.** Each requirement has its own Questions List, named after its parent ticket: `ba-output/question-list-<n>.md`, where `<n>` is the ticket's parent issue (story issues from `/ba-qa-kit:write-stories`) or the ticket itself, or the Google Doc linked in the ticket. If it is missing or has no matching Q<n>, skip that ticket and note it in the report. For each `Pending Q<n>` in a ticket's Notes, find question n (or sub-question `Q<n><letter>`, for example `Q2a`) in that ticket's list:
   - `→ Pending` → **Pending**.
   - `→ Answer …` but the ticket still says Pending → **Answered, ticket not updated**.
7. **Write the report** with `assets/template.md`. Show it in chat and save it to `ba-output/status-<YYYY-MM-DD>.md`, then show the progress line.

## Rules

- Read-only. Draft a comment or message if asked; post only after go.
- Only the current sprint's tickets.
- Every line has the issue `#` and the date of the change.
- Stale is about days without updates, never about people. Working days are Monday to Friday; public holidays are not counted unless the user says so.
- Questions: Pending for 2+ days, counted from the date the question was asked (the Questions List date, else the date of the ticket comment that first mentions it; if neither, say the age is unknown) → add "Check for a client reply", and suggest `/ba-qa-kit:collect-answers`. Answered → suggest updating the user stories, then the board tickets.
- Nothing moved → write "No change today", skip Moved and Done for tickets that moved in the period (there are none), keep Needs action.
- The board can't be read (see "Reading the board" in `project-profile.md`): ask the user to paste the sprint board.
- Chat in the user's language; the report in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
<sprint>   ✔ track-status
Next: <n>% done (<On track / Behind>), <n> blocked, <n> stale, <n> sent back, <n> answers to apply (the number of "Answered, ticket not updated" rows). Reply: update / draft / stop.
```

- Several products: one `<prefix> <n>% (<On track / Behind>)` per product, in the profile's order.
- **update** → suggest `/ba-qa-kit:write-stories` to update the user stories and, after go, the board tickets.
- **draft** → draft comments or a client follow-up; post only after go.
- **stop** → end here.
