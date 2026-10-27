# BA/QA kit for Claude Code

Two Claude Code plugins in one marketplace (`ba-qa-kit`):

- `ba` (`plugins/ba`): user stories with Given/When/Then acceptance criteria. `/ba:find-requirement-gaps` reviews a ticket's GitLab issue and Drive docs and writes a Gap Report of missing, unclear and conflicting points.
  - `/ba:draft-release-note` drafts the sprint release note email from the sprint's GitLab tickets, for a person to review and send.
  - `/ba:write-user-stories` writes stories with acceptance criteria, error handling and edge cases from the sources and the answered Questions List. The skills before and after it in the chain are optional companions: if one is not installed, the skill says so and stops.
  - `/ba:track-ticket-status` writes a daily status report for the current GitLab sprint (read-only).
  - `/ba:collect-client-answers` matches the client's replies to a Questions List and writes the answers into it.
  - `/ba:create-question-list` turns a Gap Report into a clarification question list for the client or PO.
- `qa` (`plugins/qa`): `/qa:write-test-cases` writes test cases, `/qa:verify` checks a ticket in Chrome, `/qa:log-bugs` logs bugs and records verify mistakes. Settings come from `qa.config.json` in the folder where you start `claude`.

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

## Update

In a terminal, then restart Claude Code:

```
claude plugin marketplace update ba-qa-kit
claude plugin update qa@ba-qa-kit
```

Use `ba@ba-qa-kit` for the BA plugin.

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
