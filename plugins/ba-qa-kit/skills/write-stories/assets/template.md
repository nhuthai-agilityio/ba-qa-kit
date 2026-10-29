# User Stories Template

Used by `write-stories`. Replace this file to use a different template. The board issue copies each story's body as it is (see `ticket-template.md`).

## Format

```markdown
# <App Name> – <requirement> – User Stories

Version: <n> · Date: <Mon DD, YYYY> · Status: Draft
Based on: GitLab #<issue> · <Drive docs> · Questions List (Round <n>) · Design: <link, or "None">
How to read: **Pending Q<n>** = question n (or sub-question `Q<n><letter>`) of the Questions List is still open, do not build yet.

---

## <FEATURE / SCREEN>

### US-01 – User can <capability>

<User or role> can <capability>. (US-01)

#### Acceptance Criteria

- **<Screen or flow step>**
  - <One behavior, as a full sentence.>
  - <The next behavior.>
- **<Next screen or flow step>**
  - <One behavior, as a full sentence.>

#### Validation & error handling

- When <condition>, the user sees "<message>" on **<Screen>**.
- Pending Q<n> – <short title> (suggestion: <what we propose>).

#### Edge cases

- <Case, and what happens.>

#### Notes

- Requirement: <story and rule IDs> (`<doc>`).
- Source: <client words or doc>; Q<n>, Q<n><letter> of the Questions List.
- Design: <link to screen>, or: No design yet for **<Screen>**.
- Conflict – design shows <X>, <source> says <Y>. Following <source> until confirmed.

```

## Rules

- **Summary line**: one sentence under the story heading, `<User or role> can <capability>. (US-nn)`.
- **A/C groups**: bold group bullets in flow order, each a screen or a flow step (for example **Log in screen**, **Log in**, **After log in**). Under each, nested bullets. No numbers, no `AC-1` labels, no arrows, no checkboxes.
- **Each nested bullet** is one full sentence in the present tense with one behavior.
- **Screens and buttons** in **bold** with their exact UI label (for example the **Log in** button shows "Processing...").
- **Observable**: write what the user sees or does, not how the system does it (no "a session is created", "a token is stored").
- **Real values and examples**: who, which data, which limit; add an example when a rule is easy to misread ("NHU@gmail.com" and "nhu@gmail.com" are the same account). Never "valid", "quickly", "properly".
- Validation, error handling and edge cases are flat bullets in the same full-sentence style. A `Pending Q<n>` line may end with `(suggestion: …)` when the Questions List has one.
- **Notes**: `Requirement` (IDs and doc), `Source` (client words, docs and the question IDs used), `Design` (link, or "No design yet for **<Screen>**"), then any `Conflict` lines. Leave out a line with nothing to say.
- No **New questions** or **Pending items** sections — questions live in the Questions List; only inline `Pending Q<n>` lines.
- Each story has the four parts; drop a part only if it has nothing to say (no placeholders).
- Edge cases: only those that apply — empty data, first use, min/max, duplicates, long text, double tap, going back, session timeout, concurrent changes.

## Example

```markdown
### US-01 – User can log in with their username or email

User can log in with their username or email and their password. (US-01)

#### Acceptance Criteria

- **Log in screen**
  - A person who is not logged in sees **Log in** first.
  - **Log in** has links to **Forgot password** and **Sign up**.
- **Log in**
  - The user types their username or their email in one field, then their password.
  - Capital letters in the username or email do not matter. Example: "NHU@gmail.com" and "nhu@gmail.com" are the same account.
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
- Source: client brief ("my wife always types her email instead of her username"); Q1, Q2, Q3a of the Questions List.
- Design: No design yet for **Log in**.
```
