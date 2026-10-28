---
name: setup
description: First-run setup for the BA/QA kit. Checks the GitLab and Google Drive connectors, asks once for the GitLab board and the BA/QA Drive folders, and writes one shared qa.config.json (plus the BA saved-answer copies) so the other skills do not ask again. Use when starting with the kit, when a teammate joins, when a skill says its config is missing, or when asked to set up or check the kit.
---

# Setup

Get a teammate ready without editing config by hand. The only sources are the GitLab board and the BA/QA Drive folders. BA files are written to `ba-output/` in the current folder; GitLab tickets are written by the skills that create them. Safe to re-run: it reads what exists and asks only for what is missing.

## Input and output

- **Needs** (from the user): the role (BA, QA or both) and the answers it is missing.
- **Reads**: `qa.config.json`, the `ba-output/*.json` copies, the connectors, and the GitLab board and Drive folders (read-only).
- **Writes**: `qa.config.json`, `ba-output/track-status.json` and `ba-output/release-note.json`, after go.
- **Next**: BA: `/ba:find-gaps`; QA: `/qa:write-test-cases`.

## Steps

1. **Ask the role**: BA, QA or both. Set up only what that role needs (see Files).
2. **Read what exists** in the current folder: `qa.config.json` and, for BA, the `ba-output/*.json` copies. A missing file counts as missing. An unreadable or invalid file also counts as missing: show the problem, and replace it only after the user says go.
3. **Check connectors**: GitLab and Google Drive (QA also Claude in Chrome, only for `/qa:verify`). For each: Connected or Not connected. If not, say how to connect (see Connectors). Never connect for the user. A missing connector does not stop the setup.
4. **Check the sources**: if GitLab is connected, read the board's issue list once (read-only) to confirm the link works. Same for the Drive folder (list its files only). Per product, note a warning if its newest open milestone has no end date, or ended and is still open; the checklist shows them. Not connected: mark Not checked.
5. **Ask only for what is missing** (see Questions), in one short list. Reuse what step 2 found.
6. **Show the plan and ask**: each file to write with its content, marked new, changed (old → new value) or unchanged. Stop. Write only after the user says go.
7. **Write the files.** Keep fields the user did not change, including ones this skill does not know. Create `ba-output/` or the output folder if missing.
8. **Show the checklist.** Read `assets/template.md` from this skill's folder first, then use it, then the progress line.

## Files

One shared config, `qa.config.json`, holds every answer for both roles. The BA skills read its `ba` section first; the `ba-output` copies are a fallback for older setups.

| Role | Connectors | Writes |
|---|---|---|
| BA | GitLab, Google Drive | the `ba` section of `qa.config.json`, then the two `ba-output` copies |
| QA | GitLab, Google Drive, Claude in Chrome | the top-level fields of `qa.config.json` |
| Both | all | all of it |

`qa.config.json` (the QA fields keep the shape `/qa:verify` and `/qa:write-test-cases` already read, plus `qaAssignee`, `qaDriveFolder` and `ba`). Keep every other key already in the file, such as `forbidden`, `askFirst` and `_notes`; add `_notes` lines for `qaAssignee`, `qaDriveFolder` and `ba` if `_notes` exists. An older `ba.questionsList` is no longer read by any skill; keep it and tell the user they can delete it. The QA skills read this file from the repo root, so tell the user to start `claude` in the repo root, or in the folder where the file is.

The shape is in `assets/qa.config.example.json`. Read it from this skill's folder before writing; replace each `<placeholder>` with the user's value, and drop `readyLabel`, `qaAssignee` and the optional `ba` parts that have no value.

Copies, written only for BA, with the same values as the `ba` section:
- `ba-output/track-status.json`: `project`, `sprintType`, `sprintPrefixes`, `driveFolder`.
- `ba-output/release-note.json`: `project` and `links` from `releaseNote`.

Older setups saved these as `ba-output/track-ticket-status.json` and `ba-output/draft-release-note.json`. If a new file is missing, read the old one; write only the new name.

`sprintPrefixes`: one prefix per product that runs its own sprints in the project (milestone names look like `KD - SPR 31: <title>`). Never save a milestone number; each product's current sprint is its newest open `SPR n`, found on each run.

If a copy already uses other keys, keep them and change only the values the user approved. The shared file is the source of truth and the user may edit any value in it by hand: never overwrite a value they changed. If a copy differs from the `ba` section, refresh the copy from the section (after the usual ask), not the other way round.

## Questions

- **Milestones** (BA, QA): the project's milestones list URL, saved as `boardUrl` for QA. The board of each sprint is its milestone page (`.../-/milestones/<n>`), found on each run, so never save one. Example: `<host>/<group>/<project>/-/milestones`. Strip any milestone number from a pasted URL. Take the project path and sprint type from it and confirm them.
- **Products** (BA): list the open milestones, group them by the prefix before ` - SPR`, and ask which products to track. Save one prefix each; they run in parallel.
- **Backlog column** (BA): read the project board's lists once (read-only; setup writes nothing to GitLab) and suggest the label of the label list named Backlog; the user confirms. `/ba:stories-to-board` puts new story issues there. No such list, or it is not label-based? Leave `backlogLabel` out; new issues then show in the Open list.
- **Drive folder** (BA, QA): the link of the BA folder and/or the QA folder. Never save a Questions List: each ticket has its own (`ba-output/question-list-<name>.md` or a Google Doc), found on each run.
- **Environment URLs** (QA): `dev` and `stag`. `readyLabel` only if the team marks tickets as deployed; otherwise leave it out.
- **Roles** (QA): the user roles of the app, for example Owner and Member. `/qa:write-test-cases` and `/qa:verify` read them; without them test cases use `Any`.
- **QA assignee** (QA): the GitLab username (the handle only, never an email or full name) of the person tickets are assigned to for QA. Optional; leave it out if the team has no fixed QA.
- **Test data prefix** (QA, default `E2E `) and **output folder** (QA, default `qa-output`).
- **Release note** (BA): project name for the subject, and the build links (name and location, copied as text).

## Connectors

| Connector | If missing |
|---|---|
| GitLab | Settings → Connectors → add GitLab, sign in with your own account (Reporter access or higher), restart the session. |
| Google Drive | Settings → Connectors → add Google Drive, allow the BA/QA folders. |
| Claude in Chrome | Install the extension, sign in, start Claude Code with `--chrome`. |

## Rules

- Environment URLs are dev and stag only. A URL the user calls live or production is not saved; ask for the dev or stag URL.
- Never write passwords, tokens, API keys, sender names or personal data, and never open a link other than the read-only checks in step 4.
- Read-only on GitLab and Drive. Setup creates no tickets, labels, comments or Drive files; it only records where the other skills send theirs.
- Never write or overwrite a file before the user says go. Re-running with no change writes nothing.
- Write only in the current folder (`qa.config.json`, `ba-output/`, the output folder).
- Chat in the user's language; the files in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
Setup · <role>   ✔ setup
Next: <n> connectors missing, <n> fields missing. Reply: fix, run <skill>, or stop.
```

- **fix** → ask again only for the missing items, then plan and ask before writing.
- BA ready → suggest `/ba:find-gaps`; QA ready → suggest `/qa:write-test-cases`.
