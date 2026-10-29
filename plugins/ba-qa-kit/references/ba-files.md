# BA files and progress line

Shared by the BA skills (`find-gaps`, `write-questions`, `collect-answers`, `write-stories`, `track-status`, `release-note`).

## Files

- **Folder**: every BA file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else.
- **`<name>`**: the GitLab issue number without `#` (for example `412`). No ticket: a lowercase slug of the requirement (for example `login-flow`), and the progress line shows `#-`.
- **Per requirement**: `gap-report-<name>-r<n>.md` (one per round), `question-list-<name>.md` (one Questions List, rounds added inside), `user-stories-<name>-v<n>.md` (one per version). The latest is the highest `r<n>` or `v<n>`.
- **Dates** in files: `Mon DD, YYYY` (for example `Aug 02, 2026`), unless a template says otherwise.
- **Google Doc**: the Google Drive connector reads Google Docs but cannot add text inside one. A Questions List or other output the user wants in a Google Doc: save the file in `ba-output/` as usual, then give the new part as text to paste after what is already in the doc, with the doc's name. Reading a Google Doc the user gives (for example their Questions List with answers) works.

## Sources

Read the GitLab issue through the profile's board order (`project-profile.md`: glab, else Chrome, else pasted). Drive docs with the Google Drive connector, else ask the user to paste them. Any other file or link the user names (a requirement doc in the repo, a wiki page) is a source too. A source that can't be opened: ask for access or the text; never guess its content.

## Progress line

The progress line only suggests the next step; the user can run any skill at any time. Mark a step:

- **✔** if it ran in this chat, or for this round its file for `<name>` already exists in `ba-output/`: `gap-report-<name>-r<n>.md` for find-gaps, `question-list-<name>.md` for write-questions, at least one `→ Answer (<role>, <date>)` line in `question-list-<name>.md` dated on or after this round's gap report for collect-answers, `user-stories-<name>-v<n>.md` for write-stories;
- **▶** for the step the user's go runs next (this step, if it waits for go before writing);
- **○** for the others.

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ▶ write-questions · ○ collect-answers · ○ write-stories
Next: <what go does>. Reply go, tell me what to change, or stop.
```

`Round <n>`: 1 for the first run; otherwise the highest existing `gap-report-<name>-r*.md` plus 1.
