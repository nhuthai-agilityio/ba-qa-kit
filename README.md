# BA/QA kit for Claude Code

One Claude Code plugin, `ba-qa-kit` (`plugins/ba-qa-kit`), in the marketplace `ba-qa-kit`. It holds the BA and the QA skills; everyone installs the same plugin.

- `/ba-qa-kit:setup` checks the connectors and writes `qa.config.json` and the BA saved answers, so nobody edits config by hand. Run it first, as BA, QA or both.
- BA: from a ticket to user stories with acceptance criteria on the GitLab board, plus sprint status and release notes. In workflow order:
  - `/ba-qa-kit:find-gaps` reviews a ticket's GitLab issue and Drive docs and writes a Gap Report of missing, unclear and conflicting points.
  - `/ba-qa-kit:write-questions` turns a Gap Report into a clarification Questions List for the client or PO.
  - `/ba-qa-kit:collect-answers` matches the client's replies to a Questions List and writes the answers into it.
  - `/ba-qa-kit:write-stories` writes stories with acceptance criteria, error handling and edge cases from the sources and the answered Questions List. After you review the file and reply go, it creates or updates one GitLab issue per story in the Backlog column, labeled `user story` and the feature name, without duplicating existing issues.
  - `/ba-qa-kit:track-status` writes a daily status report for the current GitLab sprint, with how much of each sprint is done (read-only).
  - `/ba-qa-kit:release-note` drafts the sprint release note email from the sprint's GitLab tickets, for a person to review and send.
- QA: `/ba-qa-kit:write-test-cases` writes test cases, `/ba-qa-kit:verify` checks a ticket in Chrome, `/ba-qa-kit:log-bugs` logs bugs and records verify mistakes. Settings come from `qa.config.json` in the folder where you start `claude`.

## BA workflow

| When | Run | You get |
|---|---|---|
| Once, or when a teammate joins | `/ba-qa-kit:setup` | `qa.config.json` in the current folder, and the saved answers in `ba-output/` |
| A new ticket arrives | `/ba-qa-kit:find-gaps` | `ba-output/gap-report-<name>-r<n>.md` |
| Gaps are found | `/ba-qa-kit:write-questions` | `ba-output/question-list-<name>.md` to send to the client |
| The client replies | `/ba-qa-kit:collect-answers` | the answers in the same Questions List; reply `loop` for a new round of gaps, or `go` to write stories |
| The questions are answered | `/ba-qa-kit:write-stories` | `ba-output/user-stories-<name>-v<n>.md` to review; reply `go` for one GitLab issue per story, new ones in the Backlog column |
| Every day of the sprint | `/ba-qa-kit:track-status` | `ba-output/status-<YYYY-MM-DD>.md` with the percent done |
| The sprint ends | `/ba-qa-kit:release-note` | `ba-output/release-note-<YYYY-MM-DD>.md`, a draft email |

Each skill ends with a progress line: ✔ ran, ▶ what `go` runs next, ○ not run. Reply `go`, a change, or `stop`. `<name>` is the GitLab issue number, or a short name of the requirement (for example `login-flow`) when there is no ticket.

## Install

Inside Claude Code:

1. Add the marketplace once. From GitLab (needs Reporter access and an SSH key on that GitLab):
   ```
   /plugin marketplace add <GitLab SSH URL of this repo>
   ```
   Or from a clone of this repo: `/plugin marketplace add ./`
2. Install the kit (same command for BA and QA):
   ```
   /plugin install ba-qa-kit@ba-qa-kit
   ```
   The part after `@` is the marketplace name.
3. Already had the old `ba` or `qa` plugin? Remove it, so the old `/ba:` and `/qa:` commands go away:
   ```
   /plugin uninstall ba@ba-qa-kit
   /plugin uninstall qa@ba-qa-kit
   ```
   Then restart Claude Code; until then the old commands can still show.

## QA setup

- Create these labels once on the board: `test case`, `Bug`, `failed`, `passed`, `not-a-bug`. If one is missing, the QA skills still do their work and tell you which label to create. They never create labels.
- The QA skills write their files in `outputDir` from `qa.config.json`. Reports, summaries, bug drafts and screenshots stay on the machine of the person who ran the skill; everything the team needs (test cases, verify reports, bugs) is also on the board. The lessons file `qa-lessons.md` and the `incidents/` folder are shared through this repo, so every QA gets them with `git pull`. Sharing is optional and done by hand (for example in GitHub Desktop): to share a new lesson, check the new files hold no personal data, then commit them on a branch and open a pull request. The skills never commit or push.
- Test accounts: copy `qa.accounts.example.json` to `qa.accounts.local.json` and fill in the shared test account of each role, so `/ba-qa-kit:verify` can sign in by itself on dev or stag. The file is git-ignored, so passwords are never committed. Use only shared test accounts, never a personal or production account. No file, or no account for a role: `/ba-qa-kit:verify` stops at the login page and asks you to sign in.
- To let `/ba-qa-kit:verify` and `/ba-qa-kit:log-bugs` follow a bug, make it a child item of the feature ticket, link it to the ticket (Linked items), or name it with `--bugs #<n>`. The skills never search the whole board. Bugs that others logged only get comments, after you confirm.

## Update

In a terminal, then restart Claude Code:

```
claude plugin marketplace update ba-qa-kit
claude plugin update ba-qa-kit@ba-qa-kit
```

From `ba-qa-kit` 1.0.0 the `ba` and `qa` plugins are one plugin: every `/ba:<skill>` and `/qa:<skill>` is now `/ba-qa-kit:<skill>`, with the same skill name. The old `/ba:stories-to-board` is part of `/ba-qa-kit:write-stories`: reply go after reviewing the stories, or ask it to put an existing story doc on the board.

## Maintaining

One-time setup by the repo owner, after the workflows are on `main`:

1. In Claude Code, from this repo, run `/install-github-app`. It installs the Claude GitHub App on the repo.
2. At "Existing Workflow Found", choose **Skip workflow update (configure secrets only)**.
3. For the token, choose **Create a long-lived token with your Claude subscription**. This adds the `CLAUDE_CODE_OAUTH_TOKEN` secret that both Claude workflows read; the API key options add a different secret, and the workflows will not find it.
4. Create an empty project on GitLab for the team to install from, and give the team Reporter access. The first `/sync-gitlab` asks for its SSH URL.

For each change:

1. On a branch, edit the kit and raise `version` in `plugins/ba-qa-kit/.claude-plugin/plugin.json` (for example `1.0.0` → `1.0.1`). Installed copies only update when the version changes. If another open pull request raised the version too, the second one to merge raises it again.
2. Open a pull request. GitHub Actions runs:
   - **CI**: `claude plugin validate` on the marketplace and each plugin, `skill-validator --strict` on each skill in `plugins/`, kit rules (description says "Use when …", `SKILL.md` at most 200 lines), and a check that every changed plugin raised its `version`.
   - **Claude Code Review**: Claude reviews the change against `CLAUDE.md` and a skill checklist (references exist, fallbacks for missing tools, fixed output format), and posts one comment with a verdict that it updates on each push. Mention `@claude` in a comment to ask it something.
3. Merge when CI is green.
4. Run `/sync-gitlab` in Claude Code from this repo. It pushes `main` to GitLab and stops instead of overwriting if GitLab has commits GitHub does not.
