# BA/QA kit for Claude Code

Two Claude Code plugins in one marketplace (`ba-qa-kit`):

- `ba` (`plugins/ba`): from a ticket to user stories with acceptance criteria on the GitLab board, plus sprint status and release notes. In workflow order:
  - `/ba:setup` checks the connectors and writes `qa.config.json` and the BA saved answers, so nobody edits config by hand. Run it first. It is part of `ba`, so a QA-only install does not have it.
  - `/ba:find-gaps` reviews a ticket's GitLab issue and Drive docs and writes a Gap Report of missing, unclear and conflicting points.
  - `/ba:write-questions` turns a Gap Report into a clarification Questions List for the client or PO.
  - `/ba:collect-answers` matches the client's replies to a Questions List and writes the answers into it.
  - `/ba:write-stories` writes stories with acceptance criteria, error handling and edge cases from the sources and the answered Questions List. The skills before and after it in the chain are optional companions: if one is not installed, the skill says so and stops.
  - `/ba:stories-to-board` creates or updates one GitLab issue per user story and puts new ones in the Backlog column, after the user replies go, without duplicating existing issues.
  - `/ba:track-status` writes a daily status report for the current GitLab sprint, with how much of each sprint is done (read-only).
  - `/ba:release-note` drafts the sprint release note email from the sprint's GitLab tickets, for a person to review and send.
- `qa` (`plugins/qa`): `/qa:write-test-cases` writes test cases, `/qa:verify` checks a ticket in Chrome, `/qa:log-bugs` logs bugs and records verify mistakes. Settings come from `qa.config.json` in the folder where you start `claude`.

## BA workflow

| When | Run | You get |
|---|---|---|
| Once, or when a teammate joins | `/ba:setup` | `qa.config.json` in the current folder, and the saved answers in `ba-output/` |
| A new ticket arrives | `/ba:find-gaps` | `ba-output/gap-report-<name>-r<n>.md` |
| Gaps are found | `/ba:write-questions` | `ba-output/question-list-<name>.md` to send to the client |
| The client replies | `/ba:collect-answers` | the answers in the same Questions List; reply `loop` for a new round of gaps, or `go` to write stories |
| The questions are answered | `/ba:write-stories` | `ba-output/user-stories-<name>-v<n>.md` to review |
| The stories are reviewed | `/ba:stories-to-board` | one GitLab issue per story, new ones in the Backlog column |
| Every day of the sprint | `/ba:track-status` | `ba-output/status-<YYYY-MM-DD>.md` with the percent done |
| The sprint ends | `/ba:release-note` | `ba-output/release-note-<YYYY-MM-DD>.md`, a draft email |

Each skill ends with a progress line: ✔ ran, ▶ what `go` runs next, ○ not run. Reply `go`, a change, or `stop`. `<name>` is the GitLab issue number, or a short name of the requirement (for example `login-flow`) when there is no ticket.

## Install

Inside Claude Code:

1. Add the marketplace once. From GitLab (needs Reporter access and an SSH key on that GitLab):
   ```
   /plugin marketplace add <GitLab SSH URL of this repo>
   ```
   Or from a clone of this repo: `/plugin marketplace add ./`
2. Install the plugin for your role. Install both if you do both jobs.

   | Role | Command |
   |---|---|
   | BA | `/plugin install ba@ba-qa-kit` |
   | QA | `/plugin install qa@ba-qa-kit` |

   The part after `@` is the marketplace name, the same for both.

## QA setup

- Create these labels once on the board: `test case`, `Bug`, `failed`, `passed`, `not-a-bug`. If one is missing, the QA skills still do their work and tell you which label to create. They never create labels.
- The QA skills write their files in `outputDir` from `qa.config.json`. Reports, summaries, bug drafts and screenshots stay on the machine of the person who ran the skill; everything the team needs (test cases, verify reports, bugs) is also on the board. The lessons file `qa-lessons.md` and the `incidents/` folder are shared through this repo, so every QA gets them with `git pull`. Sharing is optional and done by hand (for example in GitHub Desktop): to share a new lesson, check the new files hold no personal data, then commit them on a branch and open a pull request. The skills never commit or push.

## Update

In a terminal, then restart Claude Code:

```
claude plugin marketplace update ba-qa-kit
claude plugin update qa@ba-qa-kit
```

Use `ba@ba-qa-kit` for the BA plugin.

From `ba` 0.3.0 the BA skills have short names: `/ba:find-gaps`, `/ba:write-questions`, `/ba:collect-answers`, `/ba:write-stories`, `/ba:stories-to-board`, `/ba:track-status` and `/ba:release-note` replace the old long names.

## Maintaining

One-time setup by the repo owner, after the workflows are on `main`:

1. In Claude Code, from this repo, run `/install-github-app`. It installs the Claude GitHub App on the repo.
2. At "Existing Workflow Found", choose **Skip workflow update (configure secrets only)**.
3. For the token, choose **Create a long-lived token with your Claude subscription**. This adds the `CLAUDE_CODE_OAUTH_TOKEN` secret that both Claude workflows read; the API key options add a different secret, and the workflows will not find it.
4. Create an empty project on GitLab for the team to install from, and give the team Reporter access. The first `/sync-gitlab` asks for its SSH URL.

For each change:

1. On a branch, edit the plugin and raise `version` in its `.claude-plugin/plugin.json` (for example `0.1.1` → `0.1.2`). Installed copies only update when the version changes.
2. Open a pull request. GitHub Actions runs:
   - **CI**: `claude plugin validate` on the marketplace and each plugin, `skill-validator --strict` on each skill in `plugins/`, kit rules (description says "Use when …", `SKILL.md` at most 200 lines), and a check that every changed plugin raised its `version`.
   - **Claude Code Review**: Claude reviews the change against `CLAUDE.md` and a skill checklist (references exist, fallbacks for missing tools, fixed output format), and posts one comment with a verdict that it updates on each push. Mention `@claude` in a comment to ask it something.
3. Merge when CI is green.
4. Run `/sync-gitlab` in Claude Code from this repo. It pushes `main` to GitLab and stops instead of overwriting if GitLab has commits GitHub does not.
