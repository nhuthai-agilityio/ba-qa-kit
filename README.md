# BA/QA kit for Claude Code

One Claude Code plugin, `ba-qa-kit` (`plugins/ba-qa-kit`), in the marketplace `ba-qa-kit`. It holds the BA and the QA skills; everyone installs the same plugin.

- `/ba-qa-kit:setup` checks access to the team's board (GitLab, GitHub, Jira, Trello…; its CLI or connector, else Chrome), finds what it can on the board, asks only for the rest, and writes a short project profile into `CLAUDE.md` in the folder where you start `claude`. Every skill reads that profile; nobody opens a config file. To change a setting, say it: `/ba-qa-kit:setup change the dev URL to …`.
- BA: from a ticket to user stories with acceptance criteria on the board, plus sprint status and release notes. In workflow order:
  - `/ba-qa-kit:find-gaps` reviews a ticket and its Drive docs and writes a Gap Report of missing, unclear and conflicting points.
  - `/ba-qa-kit:write-questions` turns a Gap Report into a clarification Questions List for the client or PO.
  - `/ba-qa-kit:collect-answers` matches the client's replies to a Questions List and writes the answers into it.
  - `/ba-qa-kit:write-stories` writes stories with acceptance criteria, error handling and edge cases from the sources and the answered Questions List. After you review the file and reply go, it creates or updates one GitLab issue per story in the Backlog column, labeled `user story` and the feature name, without duplicating existing issues.
  - `/ba-qa-kit:track-status` writes a daily status report for the current sprint, with how much of each sprint is done (read-only).
  - `/ba-qa-kit:release-note` drafts the sprint release note email from the sprint's tickets, for a person to review and send.
- QA: `/ba-qa-kit:write-test-cases` writes test cases, `/ba-qa-kit:verify` checks a ticket in Chrome, `/ba-qa-kit:log-bugs` logs bugs and records verify mistakes. Settings come from the project profile in `CLAUDE.md`.

## BA workflow

| When | Run | You get |
|---|---|---|
| Once per project (commit `CLAUDE.md` so the team shares it) | `/ba-qa-kit:setup` | the project profile in `CLAUDE.md` |
| A new ticket arrives | `/ba-qa-kit:find-gaps` | `ba-output/gap-report-<name>-r<n>.md` |
| Gaps are found | `/ba-qa-kit:write-questions` | `ba-output/question-list-<name>.md` to send to the client |
| The client replies | `/ba-qa-kit:collect-answers` | the answers in the same Questions List; reply `loop` for a new round of gaps, or `go` to write stories |
| The questions are answered | `/ba-qa-kit:write-stories` | `ba-output/user-stories-<name>-v<n>.md` to review; reply `go` for one ticket per story, new ones in the Backlog column |
| Every day of the sprint | `/ba-qa-kit:track-status` | `ba-output/status-<YYYY-MM-DD>.md` with the percent done |
| The sprint ends | `/ba-qa-kit:release-note` | `ba-output/release-note-<YYYY-MM-DD>.md`, a draft email |

Each skill ends with a progress line: ✔ ran, ▶ what `go` runs next, ○ not run. Reply `go`, a change, or `stop`. `<name>` is the ticket number, or a short name of the requirement (for example `login-flow`) when there is no ticket.

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

## Project profile

The profile is a short block in `CLAUDE.md` (Board, Sprints, Docs, Test envs, Roles, Bugs, Release note). Claude Code reads `CLAUDE.md` in every session, so skills need no config file. A line nobody knows yet stays `?:`; the first skill that needs it asks and offers to save the answer. Commit `CLAUDE.md` when the folder is a git repo, so teammates get the same profile with `git pull`. Format: `plugins/ba-qa-kit/references/project-profile.md`.

Boards: GitLab (with `glab`), GitHub (with `gh`), Jira, Trello or another tracker (with its connector, if Claude has one). Log in once (`glab auth login --hostname <host>` with a token with `api` scope, or `gh auth login`; VPN if the host needs it). Without a CLI or connector the skills read tickets in your Chrome (`claude --chrome`) or ask you to paste them, and give board changes as text to paste. Google Docs can be read, not written: the skills give the text to paste.

## QA setup

- Labels: `/ba-qa-kit:setup` matches each label the kit needs (story, open questions, known issue, test cases, bug, failed, passed, not a bug) to a label your board already has, for example `Pending` for open questions, and proposes creating the ones it lacks. You approve the table; it creates only those, after go, and saves the board's exact names in the profile's Labels line. GitLab labels are case-sensitive, so the skills always use those exact names. No other skill creates labels.
- The QA skills write their files in the QA folder named in the profile's Bugs line (default `qa-output/`). Reports, summaries, bug drafts and screenshots stay on the machine of the person who ran the skill; everything the team needs (test cases, verify reports, bugs) is also on the board. The lessons file `qa-lessons.md` and the `incidents/` folder are shared through this repo, so every QA gets them with `git pull`. Sharing is optional and done by hand (for example in GitHub Desktop): to share a new lesson, check the new files hold no personal data, then commit them on a branch and open a pull request. The skills never commit or push.
- Test accounts: sign in to the dev or stag app in your Chrome yourself, with a shared test account (never a personal or production one). Chrome keeps you signed in. `/ba-qa-kit:verify` never types a password: at a login page, or when a case needs another role, it stops and asks you to sign in, then goes on.
- To let `/ba-qa-kit:verify` and `/ba-qa-kit:log-bugs` follow a bug, make it a child item of the feature ticket, link it to the ticket (Linked items), or name it with `--bugs #<n>`. The skills never search the whole board. Bugs that others logged only get comments, after you confirm.

## Update

In a terminal, then restart Claude Code:

```
claude plugin marketplace update ba-qa-kit
claude plugin update ba-qa-kit@ba-qa-kit
```

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
