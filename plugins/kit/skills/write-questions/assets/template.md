# Questions List Template

Used by `write-questions`. Replace this file to use a different template.

## Format

```
[Company logo]
www.agilityio.com

# <App Name> - Questions List
**<Mon DD, YYYY>**

## OVERVIEW
This document provides the questions and answers when analyzing the <source> for <App Name>.

## <PART>

### <SECTION>
1. <question>
2. <question>
   a. <sub-question>

### <SECTION>
3. <question>

## ROUND 2 — <Mon DD, YYYY>

### <SECTION>
4. <new question from the loop round>
```

## Style

| Element | Style |
|---|---|
| Logo + website | Top left: company logo, `www.agilityio.com` below it. In a Google Doc, insert the logo if the user provides one, otherwise keep the `[Company logo]` placeholder. In Markdown, keep `[Company logo]` as a placeholder |
| Title | Large (≈ 26pt), regular weight |
| Date | Bold, under the title |
| OVERVIEW and PART headings | UPPERCASE, bold |
| SECTION headings | UPPERCASE, bold, slightly smaller than PART |
| Body and questions | Regular, ≈ 11pt |
| Questions | Numbered list `1. 2. 3.`, continuing across sections |
| Sub-questions | Indented, lettered `a. b. c.`, restart under each question |

## Rules

- Numbering continues across sections; sub-questions restart at `a.` under their parent.
- No tables, IDs or priority labels in the list.
- Leave a blank line before each heading.
- Loop rounds add a `ROUND <n> — <date>` part at the end; numbering continues.

## Answers

Forward reference: this section is written by the separate `collect-answers` skill, not by `write-questions`, which leaves questions unanswered. If that skill is not installed, add answers by hand in the same format. Never renumber or delete questions.

```
1. <question>
   → Answer (<role>, <Mon DD, YYYY>): <client's words>
2. <question>
   → Answer (<role>, <Mon DD, YYYY>): <client's words>
   a. <follow-up question>
      → Pending
3. <question>
   → Pending
```

- Keep the client's words. Name the answerer by role (for example PO), not by personal name.
- Follow-ups are new sub-questions under the original question, using the next free letter.
- A later answer to the same question is a new `→ Answer` line; the old one stays.
- Not answered yet → `→ Pending`. A sub-question gets its own `→ Answer` or `→ Pending` line under it.

## Question IDs

Other skills and tickets refer to a question as `Q<n>` (question n of this ticket's Questions List) and to a sub-question as `Q<n><letter>` (for example `Q2a`). The list itself shows only `1.` and `a.`. Numbers and letters never change, so these IDs stay valid across rounds.

## Example

```
[Company logo]
www.agilityio.com

# ABC Application - Questions List
**Aug 03, 2026**

## OVERVIEW
This document provides the questions and answers when analyzing the UI/UX for ABC Application.

## MAIN APPLICATION

### AUTHENTICATION
1. We assume sign up is out of scope for this release. Is that right?
2. We assume users log in with their existing ABC account. Is that right?
   a. After logging in on the ABC login page, the user comes back to the app. Is that right?

### HOME
3. The PRD shows 3 tabs on Home, the ticket shows 4 (with Reports). We will follow the ticket. Is that right?
4. We assume the account area on Home shows only Profile and Log out. Is that right?
```
