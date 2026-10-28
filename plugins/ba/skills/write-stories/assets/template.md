# User Stories Template

Used by `write-stories`. Replace this file to use a different template.

## Format

```markdown
# <App Name> – <requirement> – User Stories

Version: <n> · Date: <Mon DD, YYYY> · Status: Draft
Based on: GitLab #<issue> · <Drive docs> · Questions List (Round <n>) · Design: <link, or "None">
How to read: **Pending Q<n>** = question n (or sub-question `Q<n><letter>`) of the Questions List is still open, do not build yet.

---

## <FEATURE / SCREEN>

### US-01 – User can <capability>

**Acceptance criteria**
The user can <capability>.
- <One behavior, as a full sentence, naming the **Screen**.>
- <The next behavior in the flow.>

**Validation & error handling**
- <When this condition happens, what the user sees on **Screen**.>
- Pending Q<n> – <short title>.

**Edge cases**
- <Case, and what happens.>

**Notes**
- Design: <link to screen> (leave this line out when there is no design)
- Conflict – design shows <X>, <source> says <Y>. Following <source> until confirmed.

```

## Rules

- **A/C** starts with one summary line, `The user can <capability>.`, then bullets. No numbers, no `AC-1` labels, no arrows.
- **Each bullet** is one full sentence in the present tense with one behavior. Bullets follow the user's flow in order (start → action → result → what happens next).
- **Screens**: name the screen in **bold** whenever the user moves to it or something shows on it (for example "the user is redirected to the **Agility Dashboard**").
- **Real values**: who, which data, which limit ("an approved company email domain", "max 50 characters"), never "valid", "quickly", "properly".
- Validation, error handling and edge cases use the same full-sentence style.
- No **New questions** or **Pending items** sections — questions live in the Questions List; only inline `Pending Q<n>` lines.
- Each story has the four parts; drop a part only if it has nothing to say (no placeholders).
- Edge cases: only those that apply — empty data, first use, min/max, duplicates, long text, double tap, going back, session timeout, concurrent changes.

## Example

```markdown
### US-01 – User can sign in with Google

**Acceptance criteria**
The user can sign in using Google OAuth.
- Only users with an approved company email domain are allowed to access the application.
- After successful authentication, the user is redirected to the **Agility Dashboard**.
- The authenticated session is created after a successful login.
- The user remains signed in across browser refreshes until the session expires or the user logs out.

**Validation & error handling**
- A user whose email is not on an approved company domain sees "Your account is not allowed to access this app." and stays on **Sign in**.
- Pending Q2 – Which email domains are approved?

**Edge cases**
- The user closes the Google window before finishing; they stay on **Sign in** and no session is created.
- The session expires while the user is on the **Agility Dashboard**; the next action takes them to **Sign in**.

**Notes**
- Design: Figma "Sign in"
- Conflict – design shows a Microsoft sign-in button, the ticket says Google only. Following the ticket until confirmed.
```
