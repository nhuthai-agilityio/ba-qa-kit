# BA/QA kit for Claude Code

Two Claude Code plugins in one marketplace (`ba-qa-kit`):

- `ba` (`plugins/ba`): user stories with acceptance criteria (`<action> → <result>`).
  - `/ba:write-user-stories` writes stories with acceptance criteria, error handling and edge cases from the sources and the answered Questions List. The skills before and after it in the chain (`find-requirement-gaps`, `create-question-list`, `collect-client-answers`, `write-stories-to-board`) are optional companions: if one is not installed, the skill says so and stops.
- `qa` (`plugins/qa`): `/qa:test` writes test cases, `/qa:verify` checks a ticket in Chrome, `/qa:bug` drafts a bug report. Settings come from `qa.config.json` in the folder where you start `claude`.

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
4. Create an empty project on GitLab for the team to install from. The first `/sync-gitlab` asks for its SSH URL.

For each change:

- Open a pull request. GitHub Actions runs:
  - **CI**: `claude plugin validate` on the marketplace and each plugin, `skill-validator --strict` on each skill in `plugins/`, kit rules (description says "Use when …", `SKILL.md` at most 200 lines), and a check that every changed plugin raised its `version`.
  - **Claude Code Review**: Claude checks the diff for bugs and for the rules in `CLAUDE.md`, and comments on what it finds. It skips trivial pull requests and ones it has already commented on; mention `@claude` in a comment to ask it anyway.
- Raise `version` in the changed plugin's `.claude-plugin/plugin.json` (for example `0.1.1` → `0.1.2`). Installed copies only update when the version changes.
- After the merge, run `/sync-gitlab` in Claude Code from this repo. It pushes `main` to GitLab and stops instead of overwriting if GitLab has commits GitHub does not.
