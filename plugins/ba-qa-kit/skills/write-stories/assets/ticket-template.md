# Ticket Template

Used by `write-stories` for the board issues. Replace this file to use a different template.

## Format

```markdown
Title: [US-<nn>] <User can capability>
Labels: <backlog label>, user story, <feature label>, pending-questions (only those that exist and apply)

**Story:** <story file or doc>, US-<nn> · **Parent:** #<parent issue>, or none

<the story body, copied from the summary line to the end of Notes>
```

## Rules

- The description is the story's body copied as it is, from the summary line (`<User or role> can <capability>. (US-nn)`) through **Acceptance Criteria**, **Validation & error handling**, **Edge cases** and **Notes**. Never rewrite it; keep the `####` headings, the bold group bullets and the nested bullets.
- No checkboxes and no `AC-<n>` labels. `/ba-qa-kit:write-test-cases` refers to an A/C by position: `AC-1` is the first nested bullet, counted in order across the groups (group bullets are not counted).
- Drop a section only if the story has nothing for it.
- `Title:` and `Labels:` are set as the issue's title and labels, not written in the description. Labels: see Board rules in the skill.
- After go, the story doc's Notes gets `Ticket: #<n>`; the issue does not repeat it.

## Example

```markdown
Title: [US-01] User can log in with their username or email
Labels: Backlog, user story, login, pending-questions

**Story:** ba-output/user-stories-sign-in-v2.md, US-01 · **Parent:** none

User can log in with their username or email and their password. (US-01)

#### Acceptance Criteria

- **Log in screen**
  - A person who is not logged in sees **Log in** first.
  - **Log in** has links to **Forgot password** and **Sign up**.
- **Log in**
  - The user types their username or their email in one field, then their password.
  - While the app is working, the **Log in** button shows "Processing...".
- **After log in**
  - The app opens the space the user used last.

#### Validation & error handling

- When the username, the email or the password is wrong, the user sees "Please provide a valid username/email or password" on **Log in**, and the message does not say which one is wrong.
- Pending Q19 – Lock after many wrong passwords (suggestion: 5 wrong tries, then wait 15 minutes).

#### Edge cases

- A person who was locked and set a new password can log in again right away.

#### Notes

- Requirement: US-06, BR-26 (`docs/requirement.md`).
- Source: client brief; Q1, Q2, Q3a of the Questions List.
- Design: No design yet for **Log in**.
```
