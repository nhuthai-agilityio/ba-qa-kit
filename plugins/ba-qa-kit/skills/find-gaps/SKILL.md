---
name: find-gaps
description: Reviews a feature's requirements (the ticket, Drive docs and any doc the user names) as a BA/QA and lists missing, unclear and conflicting points in a Gap Report. Use when asked to analyze requirements, find gaps, review a spec or check what is missing for a ticket.
---

# Find Gaps

Find what is missing, unclear or conflicting in the requirements. Never invent answers.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (the profile's **Board** and **Docs** lines, how to read the board, what to do when a line is missing) and `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, sources, progress line).

## Input and output

- **Needs** (from the user): the ticket (link or #number), or the requirement text; other docs (optional).
- **Reads**: the issue with its comments and linked issues, the Drive docs it links or that are in the Docs folder, any doc the user names, the ticket's Questions List and earlier gap reports.
- **Writes**: `ba-output/gap-report-<name>-r<n>.md`, also shown in chat.
- **Next**: `/ba-qa-kit:write-questions`; no gaps: `/ba-qa-kit:write-stories`.

## Steps

1. **Get the requirement.** Not given? Ask for the ticket (link or #number) and any docs for the feature. Look for the feature's docs in the Docs folder too. No doc at all: go on with the issue only and say so in the Sources line.
2. **Read every source** (see "Sources" in `ba-files.md`): the issue fully (description, comments, linked issues), the docs. List them as S1, S2… with name and last-updated date. Never copy tokens or personal data from a source into the report. No source could be read: stop and say so.
3. **Review each feature or screen** with the checklist. Also check:
   - Can it be written as "When `<trigger>`, the system shall `<response>`"? If not → gap.
   - Can QA test it pass/fail? Vague words (fast, easy, some, TBD) → gap.
   - Do sources disagree? → Conflicting. Don't pick a winner; name the newer source in the Finding.
   - Already answered in the Questions List? → skip.
   - The sources are silent and the team must assume something to go on → **Assumption**: write the assumption as the finding, so the client can confirm it.
   - **Loop round** (`ba-output/` already has a `gap-report-<name>-r*.md`, or the user gives answers): also review the client's answers. New rules, new cases or vague answers are new gaps. Gap IDs continue (G-12, G-13…); report only new and still-open gaps.
4. **Write the Gap Report** with `assets/template.md` (a template the user gives replaces it). `<App Name>` is the project from the profile's Board line. Show it in chat and save it; a re-run of the same round after a change overwrites the file. No gaps: still save the header, the Sources line and "No gaps found".
5. **Stop and show the progress line.** Do not start the next step until the user replies.

## Checklist

- **Business**: goal, users/roles, scope (in/out), main flow, priority
- **Data & rules**: fields (type, required, format), business rules, statuses
- **Errors & edge cases**: validation, error messages, empty state, limits, duplicates
- **Access & security**: login, role permissions, sensitive data
- **Integration**: other systems, notifications, import/export
- **UI**: every step has a screen; loading, empty, error states
- **Non-functional**: performance, devices, language

## Progress

The line and its marks are in `ba-files.md`. This step's:

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ▶ write-questions · ○ collect-answers · ○ write-stories
Next: /ba-qa-kit:write-questions — turn the gaps into the client Questions List. Reply go, tell me what to change, or stop.
```

- **go** → run `/ba-qa-kit:write-questions`.
- **Change request** → update the Gap Report, then show the progress line again.
- **stop** → end here.
- No gaps → say so, put ▶ on write-stories, and use "Next: /ba-qa-kit:write-stories". **go** → run it.
