---
name: write-stories-to-board
description: Turns a reviewed user story doc into GitLab issues, one per story, linked to the parent ticket, with no duplicates. Shows the plan and waits for go before creating or updating anything. Use when the user story doc is reviewed, or when asked to create tickets, issues or board items from user stories.
---

# Write Stories to the Board

Create or update one GitLab issue per user story. Nothing is created or changed until the user replies go.

## Steps

1. **Get the inputs.** Read the story doc (highest `ba-output/user-stories-<ticket>-v<n>.md`, or the Google Doc the user gives). Read the GitLab project from `ba.project` in `qa.config.json`, else `project` in `ba-output/track-ticket-status.json`; ask only for what is missing (story doc, project, parent issue #). Say which project and parent ticket you will use.
2. **Check for duplicates.** US numbers restart for each requirement, so never search the whole project for `[US-nn]`. Look only at issues that are children of, or linked to, the parent ticket, matched by the `[US-nn]` title prefix. No parent ticket: ask the user for the issues to check.
3. **Build the plan**, one row per story:

   | US | Action | Title | Labels | Note |
   |---|---|---|---|---|
   | US-01 | Create | [US-01] Employee can submit a leave request | user-story, leave | Pending Q2 |
   | US-02 | Update #135 | [US-02] Manager can approve a leave request | user-story, leave | A/C 3 changed |
   | US-03 | Skip | — | — | No change since #136 |

   **Create**: no issue yet. **Update**: the issue exists and the story changed. **Skip**: no change. List labels missing from the project under the table. If two issues match one story, show both and ask.
4. **Show the plan**, then **stop and show the progress line**.
5. **On go**, for each row:
   - **Create** the issue with `assets/template.md`, as a child of (or linked to) the parent ticket.
   - **Update** the description and add a comment with "What changed".
   - Write `Ticket: #<n>` into that story's **Notes** in the story doc. The go covers this. For a Google Doc, show the doc name and ask first, and keep its content.
6. **Report** each issue with its link, then show the progress line.

## Rules

- One issue per story; the title starts with `[US-nn]`. Copy the story's A/C, errors and edge cases as they are.
- Never close or delete issues, and never change status, assignee or milestone unless the user asks.
- Stories with `Pending Q<n>` or a `Conflict` note get the label `pending-questions` and keep those lines.
- Use only labels that exist or that the user gives; never create labels.
- No passwords, tokens or personal data in issues.
- GitLab not connected or access fails: give each issue as ready-to-paste text (title, labels, description).
- Chat in the user's language; issues in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time; skills that are not installed are shown as ○.

```
#<ticket> · <requirement> · Round <n>   ✔ find-requirement-gaps · ✔ create-question-list · ✔ collect-client-answers · ✔ write-user-stories · ▶ write-stories-to-board
Next: <n> create, <n> update, <n> skip. Reply go, tell me what to change, or stop.
```

After the board update, show ✔ write-stories-to-board and `Next: <n> issues need answers (label pending-questions). Run /ba:track-ticket-status to follow progress, or stop.`

- Show ✔ only for steps that ran in this chat; others show ○. `#<ticket>`: parent issue number (`#-` if none).
- **Change request** → update the plan, then show the progress line again. **stop** → end; nothing is created.
