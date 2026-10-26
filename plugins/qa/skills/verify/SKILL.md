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
  "outputDir": "qa-output"
}
```
Missing? Ask once and offer to create it. `readyLabel` is optional.

## Workflow
1. Input: ticket number, `--env` (default `dev`), related features (optional).
2. Find the ticket: `board` tool → else `boardUrl` in a new tab (user signs in if needed) → else ask.
3. If `readyLabel` is set and missing on the ticket: tell the user and stop unless they say go.
4. Test cases: latest ticket comment starting with `QA test cases` (the "Test cases" table: one row per case; steps and expected results are numbered the same). None? Suggest `/qa:test`.
5. No related features? Suggest 3–5 with a reason. Wait for confirm.
6. Check Chrome tools (`--chrome`) and that the user is signed in to the env.
7. Run rows with Run = `Auto`, then related features. Other rows = "Not run" + reason.
8. Ticket has a result from another env? Compare case by case.
9. Write the report to `<outputDir>/<ticket>-verify-<env>.md`. Chat: summary only. Any Fail? Offer `/qa:bug`.
10. Ask before posting the file as a ticket comment.

## Rules
- New tab. Open only the env URL and `boardUrl`. Never production.
- Start each case from fresh Start data and setup. Follow steps exactly.
- Check each step against the Expected result with the same number.
- Test data names start with `testDataPrefix`.
- Start console and network tracking before each case.
- Each Fail: screenshot, console errors, failed requests. Save screenshots in `outputDir` as `<ticket>-<case>-step<n>.jpg`.
- Step cannot be done or login page shows? Stop and ask.
- Never type or write passwords, tokens or personal data.
- Never change data you did not create or the ticket. Write files only in `outputDir`.
- Never send, pay or delete unless it is a test step.

## Report
Chat (3 lines):
```
Ticket #<n> on <env>: <p> Pass, <f> Fail, <b> Blocked, <r> Not run
Different from <other env>: <n>
Full report: <outputDir>/<ticket>-verify-<env>.md
```
File:
1. Results: the same "Test cases" table from the ticket, with **Status** (Pass / Fail / Blocked / Not run) and **Actual result** filled. For a Fail, say which step failed (e.g. "Step 4: …").
2. Impact: Feature | OK / Broken / Not checked | What you saw
3. Compare: Case | Dev | Stag | Same / Different
4. Findings (each Fail): Type (Bug / PO question / Test limit / Env issue), Severity, Expected / Actual, evidence
5. Reminder: redo each Fail by hand before logging a bug.
