---
name: setup
description: Sets up the BA/QA kit for a project, or changes one of its settings. Checks access to GitLab (glab, else Chrome), finds what it can on the board itself, asks only for the rest, and writes a short project profile into CLAUDE.md that every skill reads. Use when starting with the kit, when a teammate joins, when a skill says a profile line is missing, or when asked to change a setting such as the dev URL or the QA assignee.
---

# Setup

Get a project ready, or change one setting, without anyone opening a file. The settings live in the project profile: a short block in the `CLAUDE.md` of the folder where the team starts `claude` (format: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`; read it first). Claude Code loads `CLAUDE.md` into every session, so the other skills need no config file.

## Input and output

- **Needs** (from the user): nothing for a first run; or what to change, in plain words ("change the dev URL to …", "bugs now go to @lan").
- **Reads**: `CLAUDE.md`, an older `qa.config.json` or `ba-output/*.json` if present, and the GitLab board (read-only).
- **Writes**: the profile block in `CLAUDE.md`, after go. Nothing else.
- **Next**: BA: `/ba-qa-kit:find-gaps`; QA: `/ba-qa-kit:write-test-cases`.

## Steps

1. **Read what exists.** The profile block in `CLAUDE.md` (in the current folder; inside a git repo, also the repo root). Older settings: `qa.config.json` and `ba-output/track-status.json`, `release-note.json` (or their older names `track-ticket-status.json`, `draft-release-note.json`); take their values as the starting point.
2. **Pick the mode.**
   - The user named a change: change only that line (step 7). Run steps 3–4 only if the change is the board.
   - A profile exists and nothing was named: show it as a short list in plain words and ask what to change; no change: stop.
   - No profile: first run, steps 3–6.
3. **Check access** (read-only), and say for each what works:
   - **glab**: installed? `glab auth status --hostname <host>`. Then read the project once (`glab api --hostname <host> "projects/<url-encoded path>"`). A timeout means the host is not reachable (VPN or office network); `404` means no access or a wrong path. Say which, and how to fix it (see the reference). Note whether the token can write (`api`): without it, skills give board changes as text to paste.
   - **Chrome**: the session was started with `claude --chrome` and the extension answers. Needed by `/ba-qa-kit:verify`; also the fallback to read tickets when glab is missing.
   - Something missing does not stop setup: write what is known and mark the rest `?:`.
4. **Find on the board** (glab, else Chrome; read-only), and propose, never decide alone:
   - **Board**: the project from the URL the user gives (any page of it: issue, board, milestone). Keep `<host>/<group>/<project>` only.
   - **Sprints**: open milestones, grouped by the text before ` - SPR`; ask which products the team tracks. A milestone with no end date, or ended and still open: say so.
   - **Backlog**: the board list named Backlog, if it is a label list: its label.
   - **Ready labels**: labels such as `DEPLOYED TO DEV` / `DEPLOYED TO STAG`.
   - **Labels the kit uses** (`user story`, `pending-questions`, `test case`, `Bug`, `failed`, `passed`, `not-a-bug`, matched without regard to case): list the missing ones. Setup never creates labels.
5. **Ask only what step 4 could not find**, in one short list, each with a suggestion: dev and stag URLs (never production), the app's user roles, who checks bugs (a GitLab username, or nobody fixed), the Drive folder, a standard such as WCAG 2.2 AA (optional), the test data prefix (default `E2E `), the QA folder (default `qa-output`), the release note project name and build links (optional). Ask BA-only or QA-only lines only when the user does that job; leave the others as they are, or `?:`.
6. **Show the block** exactly as it will be written (Markdown, never JSON), each changed line marked `new` or `was: <old>`. Then the progress line. Stop until go.
7. **On go, write**: replace the text between `<!-- ba-qa-kit:profile:start -->` and `<!-- ba-qa-kit:profile:end -->`, or append the block; create `CLAUDE.md` if missing. Never touch anything outside the markers. Older settings files were read: ask once whether to delete them; delete only after yes.
8. **Show the checklist**: read `assets/template.md` from this skill's folder, then use it.

## Rules

- Test URLs are dev and stag only. A URL the user calls live or production is not saved.
- Never write passwords, tokens, emails, personal names or production URLs into the profile. The kit keeps no test accounts: QA signs in to the test app in Chrome.
- Read-only on GitLab and Drive. Setup creates no tickets, labels, comments or files there.
- Never write before go. Re-running with no change writes nothing.
- Chat in the user's language; the profile in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
Setup · <BA / QA / both>   ▶ setup
Next: <n> lines new, <n> changed, <n> still ?:. Reply go, tell me what to change, or stop.
```

After writing: `✔ setup`, then `Next: BA: /ba-qa-kit:find-gaps · QA: /ba-qa-kit:write-test-cases`, or the access to fix first (glab login, VPN, Chrome).
