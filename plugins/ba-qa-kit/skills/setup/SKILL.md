---
name: setup
description: Sets up the BA/QA kit for a project, or changes one of its settings. Checks access to the team's board (GitLab, GitHub, Jira, Trello…; its CLI or connector, else Chrome), finds what it can on the board itself, asks only for the rest, and writes a short project profile into CLAUDE.md that every skill reads. Use when starting with the kit, when a teammate joins, when a skill says a profile line is missing, or when asked to change a setting such as the dev URL or the QA assignee.
---

# Setup

Get a project ready, or change one setting, without anyone opening a file. The settings live in the project profile: a short block in the `CLAUDE.md` of the folder where the team starts `claude` (format: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md`; read it first). Claude Code loads `CLAUDE.md` into every session, so the other skills need no config file.

## Input and output

- **Needs** (from the user): nothing for a first run; or what to change, in plain words ("change the dev URL to …", "bugs now go to @lan").
- **Reads**: `CLAUDE.md` and the board (read-only).
- **Writes**: the profile block in `CLAUDE.md`, and the missing board labels the user approved, after go. Nothing else.
- **Next**: BA: `/ba-qa-kit:find-gaps`; QA: `/ba-qa-kit:write-test-cases`.

## Steps

1. **Read what exists.** The profile block in `CLAUDE.md` (in the current folder; inside a git repo, also the repo root).
2. **Pick the mode.**
   - The user named a change: change only that line (step 7). Run steps 3–4 only if the change is the board.
   - A profile exists and nothing was named: show it as a short list in plain words and ask what to change; no change: stop.
   - No profile: first run, steps 3–6.
3. **Check access** (read-only), and say for each what works:
   - **The board's CLI or connector**: the tracker comes from the board URL the user gives. GitLab: `glab auth status --hostname <host>`, then read the project once (`glab api --hostname <host> "projects/<url-encoded path>"`). GitHub: `gh auth status`, then `gh repo view <owner>/<repo>`. Jira, Trello or another tracker: its connector. Not in this session: say how to add it. In the session but not signed in: say to sign in with `/mcp` or Settings → Connectors. Either way, Chrome and pasted text still work. A timeout means the host is not reachable (VPN or office network); `404` means not logged in, no access or a wrong path. Say which, and how to fix it (see the reference). Note whether the login can write (GitLab `api`, GitHub `repo`): without it, skills give board changes as text to paste.
   - **Chrome**: the session was started with `claude --chrome` and the extension answers. Needed by `/ba-qa-kit:verify`; also the fallback to read tickets when there is no CLI or connector.
   - Something missing does not stop setup: write what is known and mark the rest `?:`.
4. **Find on the board** (CLI or connector, else Chrome; read-only), and propose, never decide alone:
   - **Board**: the tracker and the project from the URL the user gives (any page of it). Keep `GitLab <host>/<group>/<project>`, `GitHub <owner>/<repo>`, `Jira <site>/<project key>` or the Trello board URL.
   - **Sprints**: open milestones (GitLab, GitHub), iterations (GitLab) or sprints (Jira), grouped by the text before ` - SPR`; ask which products the team tracks. One with no end date, or ended and still open: say so. Trello has no sprints: ask how the team marks one.
   - **Backlog**: the Backlog column (see "Boards" in the reference): a GitLab label list, a GitHub Project status value, a Jira status or a Trello list.
   - **Ready labels**: labels such as `DEPLOYED TO DEV` / `DEPLOYED TO STAG`.
   - **Labels**: for each role in "Labels" of the reference (story, open questions, known issue, test cases, bug, failed, passed, not a bug), propose a board label. Use an existing one when its name or meaning fits, matched without regard to case (open questions → `Pending`, failed → `Failed`); give the board's exact spelling. None fits: propose creating the kit's default name with a color, unless a label differing only in case exists (then use that one). Show it as a table (role · board label · use existing / create) for the user to change or approve.
5. **Ask only what step 4 could not find**, in one short list, each with a suggestion: dev and stag URLs (never production), the app's user roles, who checks bugs (a board username, or nobody fixed), the Drive folder, a standard such as WCAG 2.2 AA (optional), the test data prefix (default `E2E `), the QA folder (default `qa-output`), the release note project name and build links (optional). Ask BA-only or QA-only lines only when the user does that job; leave the others as they are, or `?:`.
6. **Show the block** exactly as it will be written (Markdown, never JSON), each changed line marked `new` or `was: <old>`, and the labels to create. Then the progress line. Stop until go.
7. **On go, write**: replace the text between `<!-- ba-qa-kit:profile:start -->` and `<!-- ba-qa-kit:profile:end -->`, or append the block; create `CLAUDE.md` if missing. Never touch anything outside the markers. Then create the approved labels with the board's CLI or connector (GitLab: `glab api --hostname <host> -X POST "projects/<url-encoded path>/labels" -f name=<name> -f color=<color>`; GitHub: `gh label create <name> --color <color> -R <owner>/<repo>`; Jira or Trello: the connector). It can't write, or the connector is read-only: list them for the user to create by hand. A label that now exists, in any case: skip it and use that name.
8. **Show the checklist**: read `assets/template.md` from this skill's folder, then use it.

## Rules

- Test URLs are dev and stag only. A URL the user calls live or production is not saved.
- Never write passwords, tokens, emails, personal names or production URLs into the profile. The kit keeps no test accounts: QA signs in to the test app in Chrome.
- Read-only on the board and Drive, except the labels the user approved. Setup creates no tickets, comments or files there, and never deletes or renames a label.
- Never write before go. Re-running with no change writes nothing.
- Chat in the user's language; the profile in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
Setup · <BA / QA / both>   ▶ setup
Next: <n> lines new, <n> changed, <n> still ?:. Reply go, tell me what to change, or stop.
```

After writing: `✔ setup`, then `Next: BA: /ba-qa-kit:find-gaps · QA: /ba-qa-kit:write-test-cases`, or the access to fix first (board login, VPN, Chrome).
