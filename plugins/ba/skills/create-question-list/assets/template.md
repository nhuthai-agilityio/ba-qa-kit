# Question List Template

Used by `create-question-list`. Replace this file to use a different template.

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
| Logo + website | Top left: company logo, `www.agilityio.com` below it. In a Google Doc, insert the logo. In Markdown, keep `[Company logo]` as a placeholder |
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

Forward reference: this section is written by the separate `collect-client-answers` skill, not by `create-question-list`, which leaves questions unanswered. If that skill is not installed, add answers by hand in the same format. Never renumber or delete questions.

```
1. <question>
   → Answer (<role>, <Mon DD>): <client's words>
2. <question>
   → Answer (<role>, <Mon DD>): <client's words>
   a. <follow-up question>
3. <question>
   → Pending
```

- Keep the client's words. Name the answerer by role (for example PO), not by personal name.
- Follow-ups are new sub-questions under the original question, using the next free letter.
- A later answer to the same question is a new `→ Answer` line; the old one stays.
- Not answered yet → `→ Pending`.

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
1. Is it right if we assume sign up is out of scope?
2. RE login, we will use the existing ABC account system, right?
   a. Login opens the ABC login page, then returns to the app on success. Please help confirm.

### HOME
3. The PRD lists 3 Home tabs, the ticket says 4. Which is correct?
4. Please clarify the options under the account area on Home.
```
