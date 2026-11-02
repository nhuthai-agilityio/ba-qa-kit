# Write stories: the board

Read by `write-stories` after the draft is saved, or when the user asks to put an existing story doc on the board. Nothing is written until the user says go.

## 1. Plan the board (read-only)

Nothing is written yet.

- **Project and parent**: the profile's Board line and the parent ticket. No parent ticket? Ask for it, or for the issues to check.
- **Backlog column**: the label in the profile's Sprints line; else read the board's lists once — a label list named Backlog gives its label; else none. A list based on assignee or milestone can't be set by a label: use none. None → new issues show in the Open list. Found on the board? Offer to save it in the profile.
- **Duplicates**: US numbers restart for each requirement, so never search the whole project for `[US-nn]`. Look only at the parent's child or linked issues, matched by the `[US-nn]` title prefix. **Create**: no issue yet. **Update #n**: the issue exists and the story changed. **Skip**: no change. Two issues match one story, or the match is closed? Show it as **Check #n**; it is left out of go until the user says what to do.
- **Labels** (see "Board rules" below).

## 2. Review summary

Show it, then **stop and show the progress line**:

```
Draft saved: ba-output/user-stories-412-v2.md (3 stories). Review it there.

| US | Title | Board | Labels |
|---|---|---|---|
| US-01 | User can log in with their username or email | Create | user story, login, pending-questions |
| US-02 | User can log out | Update #135 | user story, login |
| US-03 | User stays signed in | Skip (no change) | — |
Missing labels: none · New issues go to Backlog
```

The user may ask to see one ticket ("show US-01 ticket"): show only that issue text. The board can't be read: show the table without the Board column. glab can't write (see "Writing to the board" in `project-profile.md`): say go will give ready-to-paste text.

## 3. On go

For each row:
- **Create** the issue with `${CLAUDE_PLUGIN_ROOT}/templates/write-stories-ticket.md`, linked to the parent ticket (relates to; GitLab can't make an issue the child of an issue), with its labels and `<backlog label>`.
- **Update** the whole description in the current template shape and add a comment with "What changed". When an A/C changed, or the old description had another shape (for example A/C checkboxes, so the AC positions move), end the comment with `QA: A/C changed. Run /ba-qa-kit:write-test-cases <n> for a new version.` (`<n>` is this story issue's number) Never add or remove a list label; the issue stays in its column.
- Write `Ticket: #<n>` into that story's **Notes** in the story doc. The go covers this.
- **Report** each issue with its link, then show the progress line. A row that fails (for example the issue was created but a label failed): report it and go on; never retry a create. A re-run finds issues already created by their `[US-nn]` prefix, so nothing is duplicated.

## Board rules

- One issue per story; the title starts with `[US-nn]`. The issue copies the story as it is (see `${CLAUDE_PLUGIN_ROOT}/templates/write-stories-ticket.md`).
- **Labels**, only if the label exists on the board; never create labels. Names come from the profile's Labels line (see "Labels" in `project-profile.md`); those below are the kit's defaults.
  - The story label (`user story`) on every story issue.
  - The feature name: the project label that matches the story's `## <FEATURE / SCREEN>` heading or the requirement name, ignoring case. No match? None.
  - The open-questions label (`pending-questions`) when the story has a `Pending Q<n>` line or a `Conflict` note anywhere in it.
  - Labels that don't exist are listed under "Missing labels"; the issue is created without them.
- Never close, delete or reopen issues, and never change status, column, assignee or milestone of an existing issue unless the user asks. New issues get no milestone or assignee unless the user asks.
- No passwords, tokens or personal data in issues.
- glab can't write, or a write fails: on go, give each issue as ready-to-paste text (title, labels, description, parent). Never create issues through the GitLab page in Chrome.
