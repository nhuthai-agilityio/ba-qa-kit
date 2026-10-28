# Ticket Template

Used by `stories-to-board`. Replace this file to use a different template.

## Format

```markdown
Title: [US-<nn>] <User can capability>

**Story:** <link to user story doc, US-nn> · **Parent:** #<parent issue>

### Acceptance criteria
- [ ] <Action or condition> → <result>.

### Validation & error handling
- <Condition> → <what the user sees>.

### Edge cases
- <Case> → <result>.

### Notes
- Design: <link>
- Pending Q<n> – <short title>.
- Conflict – <short text>.
```

## Rules

- Copy A/C, errors and edge cases from the story as they are; do not rewrite them.
- A/C become checkboxes (`- [ ]`) so dev and QA can tick them.
- Drop a section only if the story has nothing for it.
- Labels: `<backlog label>` (see the skill; the example uses `Backlog`), when there is one, `user-story`, the feature name (the `## <FEATURE / SCREEN>` heading in the story doc; ask if unclear), and `pending-questions` if Notes has Pending or Conflict lines.

## Example

```markdown
Title: [US-01] Employee can submit a leave request

**Story:** HR App – Leave request – User Stories v2, US-01 · **Parent:** #128

### Acceptance criteria
- [ ] Choose **Annual leave**, Nov 03 – Nov 05, tap **Submit** → request saved as **Pending**; manager notified.
- [ ] Choose **Half day** → pick **Morning** or **Afternoon**; counts as 0.5 day.

### Validation & error handling
- Days requested > days left → request blocked with "Not enough leave days."

### Edge cases
- Tap **Submit** twice → only one request created.

### Notes
- Pending Q2 – Does the 3-day rule apply to sick leave?
```

Labels: `Backlog` (example `<backlog label>`), `user-story`, `leave`, `pending-questions`
