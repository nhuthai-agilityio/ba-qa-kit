---
name: verify
description: "Use when the user asks to verify, test or re-check a ticket in the browser on Dev or Stag, to compare results between environments, or to check that related features are not broken (Claude in Chrome)."
---

# QA Verify – Claude in Chrome

Run a ticket's test cases in the user's Chrome on one env. Report what you see. Do not fix anything.

## Config
`qa.config.json` in the repo root:

```json
{
  "env": { "dev": "https://dev.example.com", "stag": "https://stag.example.com" },
  "readyLabel": { "dev": "DEPLOYED TO DEV" },
  "testDataPrefix": "E2E ",
  "board": "jira",
  "boardUrl": "https://company.atlassian.net",
  "roles": ["Owner", "Member"],
  "outputDir": "qa-output"
}
```
Missing? Ask once and offer to create it. `readyLabel` is optional. `roles` lists the user roles; cases are run one role at a time. No `roles`? Run all cases as the signed-in user.

## Workflow
1. Input: ticket number, `--env` (default `dev`), related features (optional).
2. Find the ticket: `board` tool → else `boardUrl` in a new tab (user signs in if needed) → else ask.
3. If `readyLabel` is set and missing on the ticket: tell the user and stop unless they say go.
4. Test cases: the description of the sub-issue `QA test cases – #<n>` under the ticket (the "Test cases" table: one row per case; steps and expected results are numbered the same). None? Suggest `/qa:write-test-cases`.
5. Round: 1 more than the highest Round for this Env and Ticket in `<outputDir>/verify-summary.md` or in the sub-issue comments `QA verify – #<n> – <env> – Round <round>`. None yet = Round 1.
6. No related features? Suggest 3–5 with a reason. Wait for confirm.
7. Check Chrome tools (`--chrome`) and that the user is signed in to the env. Read `<outputDir>/qa-lessons.md` if it exists and follow the lessons for `verify` or `both`.
8. Run rows with Run = `Auto`, grouped by Role (same order as `roles`): finish one role, then switch user and run the next. Then run related features. Other rows = "Not run" + reason.
9. Ticket has a result from another env? Compare case by case.
10. Write the report to `<outputDir>/<ticket>-verify-<env>-round-<round>.md`.
11. Update the summary `<outputDir>/verify-summary.md` (create it if missing): add this round to Totals; replace this Env and Ticket's rows in Results and in Fail and Blocked. Keep other tickets and older rounds in Totals.
12. Post the report as a new comment on the sub-issue `QA test cases – #<n>`. Do not ask. First line: `QA verify – #<n> – <env> – Round <round> – <date>`. Always add a new comment; never edit or delete an older one. Cannot comment? Tell the user and keep the files.
13. Any Fail? Ask in chat: `Fail: <case list>. Log bugs now? yes/no`. Yes: run the `log-bugs` skill for the failed cases, with the ticket, env, round and related test cases already filled. It creates the bugs without asking.
14. Any case that now Pass and has an open bug with label `failed`? Run the `log-bugs` skill for those cases without asking. It removes the label and adds a comment.

## Rules
- New tab. Open only the env URL and `boardUrl`. Never production.
- Start each case from fresh Start data and setup. Follow steps exactly.
- Check each step against the Expected result with the same number.
- Test data names start with `testDataPrefix`.
- Start console and network tracking before each case.
- Each Fail: screenshot, console errors, failed requests. Save screenshots in `outputDir` as `<ticket>-round-<round>-<case>-step<n>.jpg`.
- Step cannot be done or login page shows? Stop and ask.
- Never type or write passwords, tokens or personal data.
- Never change data you did not create. Never change the ticket (status, fields, AC) or an older comment; only add the verify comment. Write files only in `outputDir`.
- Never send, pay or delete unless it is a test step.

## Report
Chat (4 lines):
```
Ticket #<n> on <env>, Round <round>: <p> Pass, <f> Fail, <b> Blocked, <r> Not run
Different from <other env>: <n>
Posted: <comment link>
Report: <outputDir>/<ticket>-verify-<env>-round-<round>.md · Summary: <outputDir>/verify-summary.md
```
Report file (also the comment text):
```
# QA verify – Ticket #<n>: <ticket title>
Env: <env> | Round: <round> | Date: <date>

**Result: <p> Pass, <f> Fail, <b> Blocked, <r> Not run**

## 1. Results
| Env | Ticket | Test case | Status |
|---|---|---|---|
| <env> | #<n> (<title>) | <TC ID> (<test case>) | Pass / Fail / Blocked / Not run |

## 2. Impact
| Feature | OK / Broken / Not checked | What you saw |
|---|---|---|

## 3. Compare
Only when the ticket has a result from another env.
| Test case | Dev | Stag | Same / Different |
|---|---|---|---|

## 4. Findings
One row for each Fail, Blocked or Not run case. For Blocked and Not run, write the reason in Actual.
| Test case | Type | Severity | Expected | Actual | Evidence |
|---|---|---|---|---|---|
Type: Bug / PO question / Test limit / Env issue. Say which step failed (e.g. "Step 4: …"). Evidence: screenshot, console errors, failed requests.

## 5. Next steps
- <TC ID>: QA runs it by hand to confirm. Real bug: assign it to a developer.
```

## Summary file
`<outputDir>/verify-summary.md` covers all tickets and envs, so the user can review them in one place.
```
# QA verify summary
Updated: <date and time>
Written by /qa:verify. The Bug column is filled by /qa:log-bugs. Running it again for the same Env and Ticket adds a new Round to Totals and replaces that Env and Ticket's rows in Results and in Fail and Blocked.

## 1. Totals
| Env | Ticket | Round | Status |
|---|---|---|---|
| <env> | #<n> (<title>) | <round> | <p> Pass, <f> Fail, <b> Blocked, <r> Not run |

## 2. Results
Latest round only.
| Env | Ticket | Round | Test case | Status |
|---|---|---|---|---|
| <env> | #<n> (<title>) | <round> | <TC ID> (<test case>) | Pass / Fail / Blocked / Not run |

## 3. Fail and Blocked
Latest round only.
| Env | Ticket | Test case | Status | Type | Severity | What happened | Bug | Full report |
|---|---|---|---|---|---|---|---|---|
```
