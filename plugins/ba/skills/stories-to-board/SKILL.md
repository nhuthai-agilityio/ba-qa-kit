---
name: stories-to-board
description: Turns a reviewed user story doc into GitLab issues, one per story, linked to the parent ticket and put in the Backlog column, with no duplicates. Shows the plan and waits for go before creating or updating anything. Use when the user story doc is reviewed, or when asked to create tickets, issues or board items from user stories.
---

# Stories to Board

Create or update one GitLab issue per user story. Nothing is created or changed until the user replies go.

## Input and output

- **Needs** (from the user): the parent issue number and the reviewed story doc.
- **Reads**: the latest `user-stories-<name>-v<n>.md` or the Google Doc given, `ba.project`, `ba.backlogLabel`, the board's lists and the parent's child or linked issues.
- **Writes**: GitLab issues (created or updated after go), and `Ticket: #<n>` in each story's Notes (in a Google Doc: ask first).
- **Next**: `/ba:track-status` to follow progress.

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/ba:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.
- **`<name>`** in file names: the GitLab issue number without `#` (for example `412`). No ticket: a lowercase slug of the requirement (for example `login-flow`), and the progress line shows `#-`.
- **Files per ticket**: `gap-report-<name>-r<n>.md`, `question-list-<name>.md` (one Questions List per ticket), `user-stories-<name>-v<n>.md`. The latest is the one with the highest `r<n>` or `v<n>`.

## Steps

1. **Get the inputs.** Read the story doc (the latest `ba-output/user-stories-<name>-v<n>.md`, or the Google Doc the user gives) and the GitLab project (`ba.project`, see Config). Ask only for what is missing (story doc, project, parent issue #). If the story doc is a Google Doc and the Drive connector is missing, ask the user to paste the stories. Say which project and parent ticket you will use.
2. **Find the Backlog column**, in this order (this field has no `ba-output` copy):
   1. `ba.backlogLabel` in `qa.config.json`.
   2. Read the project board's lists once (read-only): a label list named Backlog gives its label.
   3. Ask which label list new stories go to, or none.
   A Backlog list based on assignee or milestone can't be set by a label: say so and use none. None → new issues show in the Open list. Found in 2 or 3? Suggest `/ba:setup` to save it. The result is `<backlog label>`.
3. **Check for duplicates.** US numbers restart for each requirement, so never search the whole project for `[US-nn]`. Look only at issues that are children of, or linked to, the parent ticket, matched by the `[US-nn]` title prefix. No parent ticket: ask the user for the issues to check.
4. **Build the plan**, one row per story:

   | US | Action | Title | Labels | Column | Note |
   |---|---|---|---|---|---|
   | US-01 | Create | [US-01] Employee can submit a leave request | user-story, leave | Backlog | Pending Q2 |
   | US-02 | Update #135 | [US-02] Manager can approve a leave request | user-story, leave | no change | A/C "employee is notified" changed |
   | US-03 | Skip | — | — | no change | No change since #136 |

   **Column**: `<backlog label>` for Create (the example uses `Backlog`), `Open` when there is none; `no change` otherwise. **Create**: no issue yet. **Update**: the issue exists and the story changed. **Skip**: no change. List labels missing from the project under the table. If two issues match one story, show both and ask. If the matching issue is closed, show it as **Check** and ask; never update or reopen it on your own.
5. **Show the plan**, then **stop and show the progress line**.
6. **On go**, for each row:
   - **Create** the issue with `assets/template.md`, as a child of (or linked to) the parent ticket, with `<backlog label>` so it shows in that column. None? It shows in the Open list; say so in the report.
   - **Update** the description and add a comment with "What changed". Never add or remove `<backlog label>` or any other list label; the issue stays in its column.
   - Write `Ticket: #<n>` into that story's **Notes** in the story doc. The go covers this. For a Google Doc, follow the Google Doc rule below.
7. **Report** each issue with its link, then show the progress line.

## Rules

- One issue per story; the title starts with `[US-nn]`. Copy the story's A/C, errors and edge cases as they are.
- Never close or delete issues, and never change status, column, assignee or milestone of an existing issue unless the user asks. New issues get no milestone or assignee unless the user asks.
- Stories with `Pending Q<n>` or a `Conflict` note get the label `pending-questions` and keep those lines.
- Use only labels that exist or that the user gives; never create labels.
- No passwords, tokens or personal data in issues.
- **Google Doc**: only when the user gives its link. Write with the Google Drive connector: show the doc name and ask once before writing, keep its existing content and styles, and add only the new content. If the connector is missing or the doc can't be edited, say so and give the text to paste.
- GitLab not connected or access fails: give each issue as ready-to-paste text (title, labels, description).
- Chat in the user's language; issues in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time. Mark steps ✔ if they ran in this chat, ▶ for the step the user's go runs next (this step, if it waits for go before writing), and ○ for the others (not run, or not installed).

```
#<ticket> · <requirement> · Round <n>   ✔ find-gaps · ✔ write-questions · ✔ collect-answers · ✔ write-stories · ▶ stories-to-board
Next: <n> create, <n> update, <n> skip. Reply go, tell me what to change, or stop.
```

After the board update, show ✔ stories-to-board and `Next: <n> issues need answers (label pending-questions). Run /ba:track-status to follow progress, or stop.`

- `#<ticket>`: parent issue number (`#-` if none). `<requirement>`: short feature name; `Round <n>`: reuse it from the story doc or earlier chat, or leave it out.
- **Change request** → update the plan, then show the progress line again. **stop** → end; nothing is created.
