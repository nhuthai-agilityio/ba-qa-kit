# Ticket Template

Used by `write-stories` for the board tickets. Replace this file to use a different template.

## Format

```markdown
Title: [US-<nn>] <User can capability>
Labels: <backlog label, only where the Backlog column is a label (GitLab)>, user story, <feature label>, pending-questions (only those that exist and apply)

**Story:** <link to user story doc, US-nn> · **Parent:** #<parent ticket>

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
- Copy the A/C summary line from the story as it is (never write a new one); A/C bullets become checkboxes (`- [ ]`) in the same order, so dev and QA can tick them. `/ba-qa-kit:write-test-cases` refers to a bullet by its position (`AC-1` = the first bullet); never write `AC-<n>` labels in the ticket.
- Drop a section only if the story has nothing for it.
- Notes collect the story's Design link, every `Pending Q<n>` line (wherever it is in the story) and `Conflict` notes.
- `Title:` and `Labels:` are set as the ticket's title and labels, not written in the description. Labels: see Board rules in the skill.

## Example

```markdown
Title: [US-01] User can sign in with Google
Labels: Backlog, user story, login, pending-questions

**Story:** Agility – Login – User Stories v2, US-01 · **Parent:** #412

### Acceptance criteria
The user can sign in using Google OAuth.
- [ ] On **Sign in**, the user selects **Sign in with Google** and chooses their Google account.
- [ ] Only users with an approved company email domain are allowed to access the application.
- [ ] After successful authentication, the user is redirected to the **Agility Dashboard**.
- [ ] The user remains signed in across browser refreshes until the session expires or the user logs out.

### Validation & error handling
- A user whose email is not on an approved company domain sees "Your account is not allowed to access this app." and stays on **Sign in**.

### Edge cases
- The user closes the Google window before finishing; they stay on **Sign in** and are not signed in.

### Notes
- Design: Figma "Sign in"
- Pending Q2 – Which email domains are approved?
```
