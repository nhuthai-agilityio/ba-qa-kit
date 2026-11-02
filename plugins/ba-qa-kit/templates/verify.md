# Verify formats

Used by `/ba-qa-kit:verify`: the chat report, the report file (also the comment text) and the summary file.

## Chat report
One ticket (5 lines; the `Browsers` line only when the profile has a browser besides Chrome):
```
Ticket #<n> on <env>, Round <round>: <p> Pass, <f> Fail, <b> Blocked, <r> Not run
Browsers: Chrome run; <browser> not run (<reason>); … (or the browser and "run")
Different from <other env>: <n>
Posted: <comment link>
Report: <outputDir>/<ticket>-verify-<env>-round-<round>.md · Summary: <outputDir>/verify-summary.md
```
More than one ticket: one table, then the summary path.
```
| Ticket | Round | Status | Posted |
|---|---|---|---|
| #12 (<title>) | 2 | <p> Pass, <f> Fail, <b> Blocked, <r> Not run | <comment link> |
| #18 (<title>) | – | Skipped: no QA test cases | – |
Summary: <outputDir>/verify-summary.md
```
Under the table, the same `Browsers:` line once for all tickets. The `Browsers:` line repeats the rows of the report's Browsers table, with the same reasons (see "Browser readiness"); when they differ, the table wins.

## Browser readiness
Said once before the first run (step 6), in the user's language: which listed browsers this session can drive and which it cannot, and what each missing one needs. Chrome needs `claude --chrome`. Any other browser needs an MCP that opens a page, resizes the window and reads the page. Known setups, as examples:
- Firefox: the Firefox DevTools MCP (https://firefox-source-docs.mozilla.org/ai-agent-tools/firefox-devtools-mcp.html), started with `--tool-preset developer` (the default preset has no console or network tools); a path with spaces goes in quotes.
- Safari: macOS only. Safari 27 or later with Safari > Settings > Developer > Allow remote automation and external agents, and Apple's MCP (https://developer.apple.com/documentation/safari-developer-tools/connecting-an-ai-agent-to-safari). Not tried with the kit yet: follow Apple's page, not a remembered command.
Reasons for `Not run`, always these words: `no <browser> tools in this session` · `<browser> needs <OS>` · `cannot sign in to <browser>`.

## Report file
```
# QA verify – Ticket #<n>: <ticket title>
Env: <env> | Round: <round> | Test cases: v<k> | Date: <YYYY-MM-DD>
Earlier rounds: Round <r> (v<k>) <comment link> · … (or "none")

## Browsers
| Browser | Scope | Run by | Result |
|---|---|---|---|
| Chrome | main run, widths <px>, <px> (or "default width") | Claude | <p> Pass, <f> Fail, <b> Blocked, <r> Not run |
| <browser> | compatibility case | exactly one of: `Claude`, `Reported by QA`, `Not run: <reason>` | exactly one of: `Pass`, `Fail`, `Not run` |
Only Chrome in the profile: write one Chrome row. A case that did not run: Run by `Not run: <reason>` (reasons in "Browser readiness"), Result `Not run`; if the user then reports a result (step 15), Run by `Reported by QA` and the Result the user gave. The Chrome row's Run by is always `Claude`.

**Result: <p> Pass, <f> Fail, <b> Blocked, <r> Not run**

## 1. Results
| Test case | Status |
|---|---|
| <TC ID> (<test case>) | Pass / Fail / Blocked / Not run |

## 2. Impact
| Feature | OK / Broken / Not checked | What you saw |
|---|---|---|

## 3. Compare
Only when the ticket has a result from another env.
| Test case | Dev | Stag | Same / Different |
|---|---|---|---|

## 4. Findings
One row for each Fail, Blocked or Not run case. For Blocked and Not run, write the reason in Actual. A case that did not run because the browser is missing: Type Test limit, Severity Low, Actual `Not run: <reason>`, Evidence `–`.
| Test case | Browser | Type | Severity | Expected | Actual | Evidence |
|---|---|---|---|---|---|---|
Browser: where it failed (the browser, or the width for a responsive case). Sort the rows by Type in this order: Bug, Spec mismatch, PO question, Test limit, Env issue. Inside a Type, sort by TC ID.
Type: Bug / Spec mismatch / PO question / Test limit / Env issue. Spec mismatch: case and AC disagree (fix with `/ba-qa-kit:write-test-cases`). A Fail on a case whose Note says "Assumed" (any form, with or without PO-<n>) is Type PO question, not Bug: the Expected may differ from what the PO wants. Exceptions, these stay Type Bug: a clear defect (the user cannot finish the action, a field is hidden, the page hangs, or the app shows an error), and a case whose Expected has a real source (an AC, or Covers = "Not in AC (<standard>)"). Say which step failed (e.g. "Step 4: …"). Evidence: screenshot, console errors, failed requests.
Under the table write `PO questions: <TC ID>, <TC ID>` (or `PO questions: none`). `/ba-qa-kit:write-test-cases` reads this line for the next version.

## 5. Next steps
- <TC ID>: QA runs it by hand to confirm. Real bug: assign it to a developer.
```

## Summary file
`<outputDir>/verify-summary.md` covers all tickets and envs, so the user can review them in one place.
```
# QA verify summary
Updated: <date and time>
Written by /ba-qa-kit:verify. The Bug column is filled by /ba-qa-kit:log-bugs. Running it again for the same Env and Ticket adds a new Round to Totals and replaces that Env and Ticket's rows in Results and in Fail and Blocked.

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
Latest round only. Sort the rows by Type (Bug, Spec mismatch, PO question, Test limit, Env issue), then by TC ID.
| Env | Ticket | Test case | Browser | Status | Type | Severity | What happened | Bug | Full report |
|---|---|---|---|---|---|---|---|---|---|
```
