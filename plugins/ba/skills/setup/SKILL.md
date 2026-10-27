---
name: setup
description: First-run setup for the BA/QA kit. Checks the GitLab and Google Drive connectors, asks once for the GitLab board and the BA/QA Drive folders, and writes qa.config.json and the BA saved-answer files so the other skills do not ask again. Use when starting with the kit, when a teammate joins, when a skill says its config is missing, or when asked to set up or check the kit.
---

# Setup

Get a teammate ready without editing config by hand. The only sources are the GitLab board and the BA/QA Drive folders; the same two places receive the output (GitLab tickets, files in the Drive folder). Safe to re-run: it reads what exists and asks only for what is missing.

## Steps

1. **Ask the role**: BA, QA or both. Set up only what that role needs (see Files).
2. **Read what exists** in the current folder: `qa.config.json` and the `ba-output/*.json` files the role needs. A missing, unreadable or invalid file counts as missing; never fix it silently.
3. **Check connectors**: GitLab and Google Drive (QA also Claude in Chrome, only for `/qa:verify`). For each: Connected or Not connected. If not, say how to connect (see Connectors). Never connect for the user. A missing connector does not stop the setup.
4. **Check the sources**: if GitLab is connected, read the board's issue list once (read-only) to confirm the link works. Same for the Drive folder (list its files only). Per product, warn if its newest open milestone has no end date, or ended and is still open. Not connected: mark Not checked.
5. **Ask only for what is missing** (see Questions), in one short list. Reuse what step 2 found.
6. **Show the plan and ask**: each file to write with its content, marked new, changed (old → new value) or unchanged. Stop. Write only after the user says go.
7. **Write the files.** Keep fields the user did not change, including ones this skill does not know. Create `ba-output/` or the output folder if missing.
8. **Show the checklist.** Read `assets/template.md` from this skill's folder first, then use it, then the progress line.

## Files

| Role | Connectors | Files |
|---|---|---|
| BA | GitLab, Google Drive | `ba-output/track-ticket-status.json`, `ba-output/draft-release-note.json` |
| QA | GitLab, Google Drive, Claude in Chrome | `qa.config.json` |
| Both | all | all three |

`qa.config.json` (same fields the QA skills read, plus `driveFolder`). Keep every other key already in the file, such as `roles`, `forbidden`, `askFirst` and `_notes`; add a `_notes.driveFolder` line if `_notes` exists:

```json
{
  "env": { "dev": "<dev URL>", "stag": "<stag URL>" },
  "readyLabel": { "dev": "<label>" },
  "testDataPrefix": "E2E ",
  "board": "gitlab",
  "boardUrl": "<milestones list URL>",
  "outputDir": "qa-output",
  "driveFolder": "<QA Drive folder link>"
}
```

`ba-output/track-ticket-status.json`:

```json
{ "project": "<group/project>", "sprintType": "milestone", "sprintPrefixes": ["<KD>", "<F>"], "questionsList": "<doc link>", "driveFolder": "<BA Drive folder link>" }
```

`ba-output/draft-release-note.json`:

```json
{ "project": "<project name>", "links": [ { "name": "<name>", "location": "<URL or text>" } ] }
```

`sprintPrefixes`: one prefix per product that runs its own sprints in the project (milestone names look like `KD - SPR 31: <title>`). Never save a milestone number; the current sprint of each product is its newest open `SPR n`, found on each run.

If a saved-answer file already uses other keys, keep them and change only the values the user approved.

## Questions

- **Milestones** (BA, QA): the project's milestones list URL, saved as `boardUrl` for QA. The board of each sprint is its milestone page (`.../-/milestones/<n>`), found on each run, so never save one. Example: `<host>/<group>/<project>/-/milestones`. Strip any milestone number from a pasted URL. Take the project path and sprint type from it and confirm them.
- **Products** (BA): list the open milestones, group them by the prefix before ` - SPR`, and ask which products to track. Save one prefix each; they run in parallel.
- **Drive folder** (BA, QA): the link of the BA folder and/or the QA folder. For the Questions List, ask which doc in the BA folder it is.
- **Environment URLs** (QA): `dev` and `stag`. `readyLabel` only if the team marks tickets as deployed; otherwise leave it out.
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
- BA ready → suggest `find-requirement-gaps`; QA ready → suggest `/qa:test`.
