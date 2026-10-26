---
name: find-requirement-gaps
description: Reviews a feature's requirements from the team's sources (GitLab issue and the Google Docs on Drive) as a BA/QA and lists missing, unclear and conflicting points in a Gap Report. Use when asked to analyze requirements, find gaps, review a spec or check what is missing for a ticket.
---

# Find Requirement Gaps

Find what is missing, unclear or conflicting in the requirements. Never invent answers.

## Sources

The full context is always in:

- **GitLab issue** — the ticket: description, comments, linked issues, attachments.
- **Google Drive** — the docs for the feature (PRD, specs, previous Questions List with answers).

## Steps

1. **Get the ticket.** If not given, ask: "Please provide the GitLab issue (link or #number) and the Google Drive doc(s) for this feature." No Drive doc at all? Continue with the GitLab issue only and say so in the Sources line.
2. **Read the GitLab issue fully** (incl. comments) and every Drive doc it links or the user gives. Use the GitLab and Google Drive connectors; if one can't be opened, ask the user to share access or paste the content. List sources as S1, S2… with name and date.
3. **Review each feature/screen** with the checklist. Also check:
   - Can it be written as "When `<trigger>`, the system shall `<response>`"? If not → gap.
   - Can QA test it pass/fail? Vague words (fast, easy, some, TBD) → gap.
   - Do sources disagree? → Conflict (don't pick a winner; note the newer one).
   - Already answered in a previous Questions List? → skip.
   - Used by **Assumption**: the sources are silent and the team must assume something to go on. Write the assumption as the finding, so the client can confirm it.
   - **Loop round** (after client answers): also review the answers themselves — new rules, new cases or vague answers they bring are new gaps. Gap IDs continue (G-12, G-13…); report only new and still-open gaps.
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

Show the report in chat and save it to `ba-output/gap-report-<ticket>-r<n>.md` in the current folder. Ask before saving anywhere else. Dates use `Mon DD, YYYY` (for example Aug 02, 2026).

## Progress

End with this progress line, then wait for the user:

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ○ create-question-list · ○ collect-client-answers · ○ write-user-stories
Next: create-question-list — turn the gaps into the client question list. Reply go, tell me what to change, or stop.
```

- `#<ticket>`: GitLab issue number. `<requirement>`: short feature name. `Round <n>`: 1 for the first run, +1 for each loop.
- **go** → run `create-question-list`. If that skill is not installed, say so, keep the Gap Report as the result, and stop.
- **Change request** → update the Gap Report, then show the progress line again.
- **stop** → end here.
- No gaps → say so and use "Next: write-user-stories".
