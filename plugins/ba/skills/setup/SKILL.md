---
name: setup
description: First-run setup for the BA/QA kit. Checks the GitLab, Google Drive and Claude in Chrome connectors, asks for the project details once, and writes qa.config.json and the BA saved-answer files so the other skills do not ask again. Use when starting with the kit, when a teammate joins, when a skill says its config is missing, or when asked to set up or check the kit.
---

# Setup

Get a teammate ready to use the kit without editing config by hand. Safe to re-run: it reads what exists first and asks only for what is missing.

## Steps

1. **Ask the role first**: BA, QA or both. Set up only what that role needs (see Role table). Skip everything else.
2. **Read what exists** before asking anything, in the current folder: `qa.config.json`, `ba-output/track-ticket-status.json` and `ba-output/draft-release-note.json` (only those the role needs). Note each field as present, missing or unreadable. An unreadable or invalid file counts as missing; never fix it silently.
3. **Check the connectors** the role needs (see Connectors). Do not read private content to prove access; one lightweight call is enough. Report each as Connected, Not connected or Not checked, with the fix from the table.
4. **Check ticket access** if GitLab is connected: read one ticket or the project's issue list, read-only, to confirm the project path is right. Not connected? Skip and mark it Not checked.
5. **Ask only for what is missing**, in one short list (see Questions). Reuse values already found. Never ask for passwords, tokens or personal data, and refuse them if offered.
6. **Show the plan, then ask**: list each file to write with its full content, and mark each as **new**, **changed** (show the old and new value of each field that changes) or **unchanged** (not written). Stop. Write only after the user says go, and overwrite a file only for the files they approve. Create `ba-output/` and `qa-output/` (or the `outputDir` chosen) if missing; that needs no extra question.
7. **Write the files** (see Outputs). Keep fields the user did not change, including fields this skill does not know.
8. **Show the checklist.** Read `assets/template.md` from this skill's folder first, then use it, then the progress line.

## Role table

| Role | Connectors | Files |
|---|---|---|
| BA | GitLab, Google Drive | `ba-output/track-ticket-status.json`, `ba-output/draft-release-note.json` |
| QA | GitLab (or the board tool in `board`), Claude in Chrome | `qa.config.json` |
| Both | all three | all three files |

## Connectors

| Connector | How to connect when missing |
|---|---|
| GitLab | Open the connectors list in Claude (Settings → Connectors), add GitLab, sign in with your own account, then restart the session. Needs Reporter access or higher on the project. |
| Google Drive | Same list: add Google Drive and allow access to the Questions List and release-note docs. |
| Claude in Chrome | Install the Claude in Chrome extension from the Chrome Web Store, sign in, and start Claude Code with `--chrome`. |

Never connect or install on the user's behalf; say what to do and let them do it. A missing connector never blocks the setup: write what you can and list the gap in the checklist.

## Questions

Ask in the user's language, grouped by what the role needs, and skip any field already known.

- **GitLab project** (BA and QA): the project path, for example `group/project`.
- **Board** (QA): `board` (for example `gitlab` or `github`) and `boardUrl`.
- **Environment URLs** (QA): `dev` and `stag` only. Ask for the `readyLabel` per env only if the team marks tickets as deployed; otherwise leave it out.
- **Test data prefix** (QA): default `E2E `.
- **Output folder** (QA): default `qa-output`.
- **Sprint type** (BA): iteration or milestone.
- **Questions List** (BA): the file path or the Google Doc link.
- **Release note** (BA): the project name for the subject, and where the build links are (name and location of each, copied as text, never opened).

## Outputs

`qa.config.json` in the folder where Claude Code starts, same fields the QA skills read:

```json
{
  "env": { "dev": "<dev URL>", "stag": "<stag URL>" },
  "readyLabel": { "dev": "<label>" },
  "testDataPrefix": "E2E ",
  "board": "<gitlab / github / ...>",
  "boardUrl": "<board URL>",
  "outputDir": "qa-output"
}
```

`ba-output/track-ticket-status.json`:

```json
{ "project": "<group/project>", "sprintType": "iteration", "questionsList": "<path or link>" }
```

`ba-output/draft-release-note.json`:

```json
{ "project": "<project name>", "links": [ { "name": "<link name>", "location": "<URL or text>" } ] }
```

If a saved-answer file already exists with other key names, keep its keys and add or change only the values the user approved, so the skill that owns the file still reads it.

## Rules

- Environment URLs: dev and stag only. If a URL looks like production (the user calls it live or production, or it is the public site), do not save it; say why and ask for the dev or stag URL.
- Never write passwords, tokens, API keys, sender names or personal data to any file, and never open a link to check it.
- Never write or overwrite a file before the user says go for that file. Re-running with nothing changed writes nothing.
- Read-only on GitLab, Drive and the board. Never create tickets, labels or comments.
- `readyLabel` is optional; omit the whole field when unused.
- Write only inside the current folder (`qa.config.json`, `ba-output/`, the `outputDir`). Any other location needs the user's say-so.
- Chat in the user's language; the files in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
Setup · <role>   ✔ setup
Next: <n> connectors missing, <n> fields missing. Reply: fix (to redo the missing parts), or run <skill> to start working, or stop.
```

- **fix** → ask again only for the missing items, then show the plan and ask before writing.
- BA ready → suggest `find-requirement-gaps`; QA ready → suggest `/qa:test`.
- **stop** → end here.
