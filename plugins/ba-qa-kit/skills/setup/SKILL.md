---
name: setup
description: Sets up the BA/QA kit for a project, or changes one of its settings. Checks access to GitLab (glab, else Chrome), finds what it can on the board itself, asks only for the rest, and writes a short project profile into CLAUDE.md that every skill reads. Use when starting with the kit, when a teammate joins, when a skill says a profile line is missing, or when asked to change a setting such as the dev URL or the QA assignee.
---

# Setup

Get a project ready, or change one setting, without anyone opening a file. The settings live in the project profile: a short block in the `CLAUDE.md` of the folder where the team starts `claude` (format: the profile reference, imported below). Claude Code loads `CLAUDE.md` into every session, so the other skills need no config file. Setup alone also adds the kit's guard rules to `.claude/settings.json`.
@${CLAUDE_PLUGIN_ROOT}/references/project-profile.md

## Input and output

- **Needs** (from the user): nothing for a first run; or what to change, in plain words ("change the dev URL to …", "bugs now go to @lan").
- **Reads**: `CLAUDE.md` and the GitLab board (read-only).
- **Writes**: the profile block in `CLAUDE.md`, the kit's guard rules in `.claude/settings.json`, and the missing board labels the user approved, after go. Nothing else.
- **Next**: BA: `/ba-qa-kit:find-gaps`; QA: `/ba-qa-kit:write-test-cases`.

## Steps

1. **Read what exists.** The profile block in `CLAUDE.md` (in the current folder; inside a git repo, also the repo root).
2. **Pick the mode.**
   - The user named a change: change only that line (step 7). Run steps 3–4 only if the change is the board.
   - A profile exists and nothing was named: show it as a short list in plain words and ask what to change. Also check the guard rules (step 6) and offer the missing ones, even when the profile needs no change. Nothing to change and no rule missing: stop.
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
   - **Labels**: for each role in "Labels" of the reference (story, open questions, known issue, test cases, bug, failed, passed, not a bug), propose a board label. Use an existing one when its name or meaning fits, matched without regard to case (open questions → `Pending`, failed → `Failed`); give the board's exact spelling. None fits: propose creating the kit's default name with a color, unless a label differing only in case exists (then use that one). Show it as a table (role · board label · use existing / create) for the user to change or approve.
5. **Ask only what step 4 could not find**, in one short list, each with a suggestion: dev and stag URLs (never production), the app's user roles, who checks bugs (a GitLab username, or nobody fixed), the Drive folder, a standard such as WCAG 2.2 AA (optional), the project's domain (optional: FinTech, HealthTech, AI assistant…; default `none`), the browsers the project supports besides Chrome (optional; default `Chrome only`) and its screen widths (optional), the test data prefix (default `E2E `), the QA folder (default `qa-output`), the release note project name and build links (optional). Also ask whether to share the kit's files through the project's repo (default `on`; see "Sharing files" in the reference). Ask BA-only or QA-only lines only when the user does that job; leave the others as they are, or `?:`.
6. **Show the block** exactly as it will be written (Markdown, never JSON), each changed line marked `new` or `was: <old>`, and the labels to create. Then the guard rules: read `${CLAUDE_PLUGIN_ROOT}/templates/settings-guard.json` and compare it with `.claude/settings.json` next to `CLAUDE.md`. Say in one line how many are missing and what they do: Claude cannot push to `main` or `master`, force push, delete a remote branch, skip the project's git hooks, delete on the board or read `.env`; it asks first before a command that throws away local changes (`git reset --hard`, `git clean`, `git restore`, `git stash drop`). Then the progress line. Stop until go.
7. **On go, write**: replace the text between `<!-- ba-qa-kit:profile:start -->` and `<!-- ba-qa-kit:profile:end -->`, or append the block; create `CLAUDE.md` if missing. Never touch anything outside the markers. Then add the missing guard rules to `.claude/settings.json` (create it if missing): each rule of `permissions.deny` and `permissions.ask` in the template that is not there yet; keep every other key and rule as it is, and never remove or change one. The file is not valid JSON or can't be written: leave it as it is, and give the missing rules as text for the user to add. Then create the approved labels with glab (`glab api --hostname <host> -X POST "projects/<url-encoded path>/labels" -f name=<name> -f color=<color>`). glab can't write: list them for the user to create by hand. A label that now exists, in any case: skip it and use that name.
8. **Show the checklist**: read `${CLAUDE_PLUGIN_ROOT}/templates/setup.md`, then use it. Guard rules were added: say Claude Code applies them right away, and that committing `CLAUDE.md` and `.claude/settings.json` gives the team the same profile and rules.

## Rules

- Test URLs are dev and stag only. A URL the user calls live or production is not saved.
- Never write passwords, tokens, emails, personal names or production URLs into the profile. The kit keeps no test accounts: QA signs in to the test app in Chrome.
- Read-only on GitLab and Drive, except the labels the user approved. Setup creates no tickets, comments or files there, and never deletes or renames a label.
- Never write before go. Re-running with no change writes nothing.
- Chat in the user's language; the profile in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
Setup · <BA / QA / both>   ▶ setup
Next: <n> lines new, <n> changed, <n> still ?:. Reply go, tell me what to change, or stop.
```

After writing: `✔ setup`, then `Next: BA: /ba-qa-kit:find-gaps · QA: /ba-qa-kit:write-test-cases`, or the access to fix first (glab login, VPN, Chrome).
