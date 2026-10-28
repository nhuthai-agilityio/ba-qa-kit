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
1. <Action or condition> → <result>.
2. <Action or condition> → <result>.

**Validation & error handling**
- <Condition> → <what the user sees>.
- Pending Q<n> – <short title>.

**Edge cases**
- <Case> → <result>.

**Notes**
- Design: <link to screen> (leave this line out when there is no design)
- Conflict – design shows <X>, <source> says <Y>. Following <source> until confirmed.

```

## Rules

- A/C is a plain numbered list; no `AC-1` labels.
- Each A/C is one line: `<action or condition> → <result>.`
- No **New questions** or **Pending items** sections — questions live in the Questions List; only inline `Pending Q<n>` lines.
- Each story has the four parts; drop a part only if it has nothing to say (no placeholders).
- Edge cases: only those that apply — empty data, first use, min/max, duplicates, long text, double tap, going back, session timeout, concurrent changes.

## Example

```markdown
### US-01 – Employee can submit a leave request

**Acceptance criteria**
1. Choose **Annual leave**, Nov 3 – Nov 5, tap **Submit** → request saved as **Pending**; manager notified.
2. Choose **Half day** → pick **Morning** or **Afternoon**; counts as 0.5 day.
3. Weekends and public holidays in the range → not counted.

**Validation & error handling**
- Start date less than 3 days from today → "Please request at least 3 days in advance."; **Submit** disabled.
- Days requested > days left → request blocked with "Not enough leave days."
- Pending Q2 – Does the 3-day rule apply to sick leave?

**Edge cases**
- Range overlaps an existing request → blocked with "You already have leave on these dates."
- Tap **Submit** twice → only one request created.

**Notes**
- Design: Figma "Leave request"
- Conflict – design shows 4 leave types, PRD says 2 (Annual, Sick). Following PRD until confirmed.
```
