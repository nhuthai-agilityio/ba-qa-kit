# Ticket Template

Used by `stories-to-board`. Replace this file to use a different template.

## Format

```markdown
Title: [US-<nn>] <User can capability>

**Story:** <link to user story doc, US-nn> · **Parent:** #<parent issue>

### Acceptance criteria
The user can <capability>.
- [ ] <One behavior, as a full sentence, naming the **Screen**.>

### Validation & error handling
- <When this condition happens, what the user sees on **Screen**.>

### Edge cases
- <Case, and what happens.>

### Notes
- Design: <link>
- Pending Q<n> – <short title>.
- Conflict – <short text>.
```

## Rules

- Copy A/C, errors and edge cases from the story as they are; do not rewrite them.
- Copy the A/C summary line from the story as it is (never write a new one); A/C bullets become checkboxes (`- [ ]`) in the same order, so dev and QA can tick them. `/qa:write-test-cases` refers to a bullet by its position (`AC-1` = the first bullet); never write `AC-<n>` labels in the issue.
- Drop a section only if the story has nothing for it.
- Labels: `<backlog label>` (see the skill; the example uses `Backlog`), when there is one, `user-story`, the feature name (the `## <FEATURE / SCREEN>` heading in the story doc; ask if unclear), and `pending-questions` if Notes has Pending or Conflict lines.

## Example

```markdown
Title: [US-01] Employee can submit a leave request

**Story:** HR App – Leave request – User Stories v2, US-01 · **Parent:** #128

### Acceptance criteria
The employee can submit a leave request.
- [ ] On **Leave request**, the employee chooses **Annual leave** and the dates, then taps **Submit**.
- [ ] The request is saved as **Pending** and the manager is notified.
- [ ] Weekends and public holidays in the range are not counted.

### Validation & error handling
- When the days requested are more than the days left, the request is blocked with "Not enough leave days."

### Edge cases
- The employee taps **Submit** twice; only one request is created.

### Notes
- Pending Q2 – Does the 3-day rule apply to sick leave?
```

Labels: `Backlog` (example `<backlog label>`), `user-story`, `leave`, `pending-questions`
