---
name: write-stories-to-board
description: Turns a reviewed user story doc into GitLab issues, one per story, linked to the parent ticket and the story doc, with no duplicates. Shows the plan and waits for go before creating or updating anything. Use when the user story doc is reviewed, or when asked to create tickets, issues or board items from user stories.
---

# Write Stories to the Board

Create or update one GitLab issue per user story. Nothing is created or changed until the user replies go.

## Steps

1. **Get the inputs.** Read the story doc (`ba-output/user-stories-<ticket>-v<n>.md`, the highest `-v<n>`, or the Google Doc the user gives). Read the GitLab project from `ba.project` in `qa.config.json`, else from `ba-output/track-ticket-status.json` (`project`); ask only for what is still missing: "Please provide the reviewed user story doc, the GitLab project and the parent issue #, if any." If you read the project from a file, say which one. Tell the user the parent ticket and project you will use.
2. **Check the board for duplicates.** US numbers restart for each requirement, so never search the whole project for `[US-nn]`. Look only at issues that are children of, or linked to, the parent ticket, and match them by the `[US-nn]` title prefix. With no parent ticket, ask the user for the existing issues to check (or confirm there are none); do not search the project.
3. **Build the plan**, one row per story:

   | US | Action | Title | Labels | Note |
   |---|---|---|---|---|
   | US-01 | Create | [US-01] Employee can submit a leave request | user-story, leave | Pending Q2 |
   | US-02 | Update #135 | [US-02] Manager can approve a leave request | user-story, leave | A/C 3 changed |
   | US-03 | Skip | — | — | No change since #136 |

   - **Create**: no issue yet. **Update**: the issue exists and the story changed. **Skip**: the issue exists, no change.
   - List labels that do not exist in the project under the table, as "Missing labels".
4. **Show the plan**, then **stop and show the progress line**. Do not touch the board until the user replies go.
5. **On go**, for each row, in story order:
   - **Create** the issue with `assets/template.md`, as a child of the parent ticket (or linked to it, if the project cannot do children).
   - **Update** the description and add a comment with "What changed".
   - Write `Ticket: #<n>` into that story's **Notes** in the story doc. The user's go covers this write. For a Google Doc, show the doc name and ask before writing, keep its existing content and add only that line. If the doc can't be edited, give the lines to paste.
6. **Report** each issue created or updated with its link, then show the progress line.

## Rules

- One issue per story; the title always starts with `[US-nn]`.
- Never close or delete issues, and never change status, assignee or milestone unless the user asks.
- Stories with `Pending Q<n>` or a `Conflict` note get the label `pending-questions` and keep those lines in the description.
- Copy the story's A/C, errors and edge cases as they are; never invent or reword requirements.
- Use only labels that exist in the project or that the user gives; never create labels.
- Only the story's text goes to GitLab: no passwords, tokens or personal data.
- If GitLab is not connected or access fails, give the user each issue as ready-to-paste text (title, labels, description) and still write `Ticket: #<n>` only after the user tells you the numbers.
- Chat in the user's language; issues in English.

## Edge cases

- **Story doc has no `US-nn` stories**: say so and stop; suggest `/ba:write-user-stories`.
- **Two issues match one story**: do not pick one; show both in the plan and ask.
- **Issue was edited by someone else** since the last story version: show it as "Check" in the plan and ask before overwriting.

## Progress

The progress line only suggests the next step. The user can run any skill at any time; skills that are not installed are shown as ○.

After the plan:

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ✔ collect-client-answers · ✔ write-user-stories · ▶ write-stories-to-board
Next: <n> create, <n> update, <n> skip. Reply go, tell me what to change, or stop.
```

After the board update:

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ✔ collect-client-answers · ✔ write-user-stories · ✔ write-stories-to-board
Next: <n> issues need answers before work starts (label pending-questions). Run /ba:track-ticket-status to follow progress, or stop.
```

- Show ✔ only for steps that ran in this chat; steps that did not run, or whose skill is not installed, show ○.
- `#<ticket>`: parent GitLab issue number (`#-` when there is none). `<requirement>`: short feature name.
- **go** → create and update the issues and write the ticket numbers into the story doc.
- **Change request** → update the plan, then show the progress line again.
- **stop** → end here; nothing is created.
