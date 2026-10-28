---
name: find-gaps
description: Reviews a feature's requirements from the team's sources (GitLab issue and the Google Docs on Drive) as a BA/QA and lists missing, unclear and conflicting points in a Gap Report. Use when asked to analyze requirements, find gaps, review a spec or check what is missing for a ticket.
---

# Find Gaps

Find what is missing, unclear or conflicting in the requirements. Never invent answers.

## Input and output

- **Needs** (from the user): the GitLab issue (link or #number); Drive docs (optional).
- **Reads**: the issue with its comments, the Drive docs it links or the user gives and those in `ba.driveFolder`, the ticket's Questions List and earlier gap reports.
- **Writes**: `ba-output/gap-report-<name>-r<n>.md`, also shown in chat.
- **Next**: `/kit:write-questions`; no gaps: `/kit:write-stories`.

## Sources

The full context is always in:

- **GitLab issue** — the ticket: description, comments, linked issues, attachments.
- **Google Drive** — the docs for the feature (PRD, specs, previous Questions List with answers).

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/kit:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.
- **`<name>`** in file names: the GitLab issue number without `#` (for example `412`). No ticket: a lowercase slug of the requirement (for example `login-flow`), and the progress line shows `#-`.
- **Files per ticket**: `gap-report-<name>-r<n>.md`, `question-list-<name>.md` (one Questions List per ticket), `user-stories-<name>-v<n>.md`. The latest is the one with the highest `r<n>` or `v<n>`.

## Steps

1. **Get the ticket.** If not given, ask: "Please provide the GitLab issue (link or #number) and the Google Drive doc(s) for this feature." Also look for the feature's docs in the BA Drive folder (`ba.driveFolder`). No Drive doc at all? Continue with the GitLab issue only and say so in the Sources line.
2. **Read the GitLab issue fully** (incl. comments) and every Drive doc it links or the user gives. Use the GitLab and Google Drive connectors; if one can't be opened (no access, private or unreachable host), ask the user to share access or paste the content. If they can give neither, stop and say no sources were available. Never copy tokens or personal data from sources into the report. List sources as S1, S2… with name and last-updated date (issue last update, doc last modified).
3. **Review each feature/screen** with the checklist. Also check:
   - Can it be written as "When `<trigger>`, the system shall `<response>`"? If not → gap.
   - Can QA test it pass/fail? Vague words (fast, easy, some, TBD) → gap.
   - Do sources disagree? → Conflict (don't pick a winner; name the newer source in the Finding column).
   - Already answered in a previous Questions List? → skip.
   - Used by **Assumption**: the sources are silent and the team must assume something to go on. Write the assumption as the finding, so the client can confirm it.
   - **Loop round**: it is one when `ba-output/` already has a `gap-report-<name>-r*.md` or the user gives an answer doc.
     - Also review the client answers (a Drive doc or pasted text) themselves. New rules, new cases or vague answers are new gaps.
     - Gap IDs continue (G-12, G-13…); report only new and still-open gaps.
4. **Output the Gap Report** (see Output), then **stop and show the progress line** (see Progress). Do not start the next step until the user replies.

## Checklist

- **Business**: goal, users/roles, scope (in/out), main flow, priority
- **Data & rules**: fields (type, required, format), business rules, statuses
- **Errors & edge cases**: validation, error messages, empty state, limits, duplicates
- **Access & security**: login, role permissions, sensitive data
- **Integration**: other systems, notifications, import/export
- **UI**: every step has a screen; loading, empty, error states
- **Non-functional**: performance, devices, language

## Output

Write the Gap Report using `assets/template.md`. A template the user provides replaces it completely.

Show the report in chat and save it to `ba-output/gap-report-<name>-r<n>.md`. `<App Name>` in the template is the repo or GitLab project name. With no gaps, still save the report: the header, the Sources line and "No gaps found". If the file already exists (same round re-run after a change request), overwrite it. Dates use `Mon DD, YYYY` (for example Aug 02, 2026).

## Progress

The progress line only suggests the next step. The user can run any skill at any time. Mark steps ✔ if they ran in this chat, ▶ for the step the user's go runs next (this step, if it waits for go before writing), and ○ for the others (not run, or not installed).

End with this progress line, then wait for the user:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ▶ write-questions · ○ collect-answers · ○ write-stories
Next: /kit:write-questions — turn the gaps into the client Questions List. Reply go, tell me what to change, or stop.
```

- `#<ticket>`: GitLab issue number, or `#-` if there is none. `<requirement>`: short feature name. `Round <n>` (also `r<n>` in the file name): 1 for the first run; otherwise the highest existing `gap-report-<name>-r*.md` in `ba-output/` plus 1.
- **go** → run `/kit:write-questions`. If that skill is not installed, say so, keep the Gap Report as the result, and stop.
- **Change request** → update the Gap Report, then show the progress line again.
- **stop** → end here.
- No gaps → say so, mark ▶ on write-stories instead, and use "Next: /kit:write-stories". **go** → run `/kit:write-stories`; if that skill is not installed, say so and stop with the Gap Report as the result.
