# BA/QA kit for Claude Code

Two Claude Code plugins in one marketplace (`ba-qa-kit`):

- `ba` (`plugins/ba`): user stories with Given/When/Then acceptance criteria. No skills yet.
- `qa` (`plugins/qa`): `/qa:test` writes test cases, `/qa:verify` checks a ticket in Chrome, `/qa:bug` drafts a bug report. Settings come from `qa.config.json`.

## Install

From GitLab (needs Reporter access and an SSH key on that GitLab), inside Claude Code:

```
/plugin marketplace add <GitLab SSH URL of this repo>
/plugin install ba@ba-qa-kit
/plugin install qa@ba-qa-kit
```

From a clone: `claude plugin marketplace add ./`, then the same two installs.
After an update: `/plugin marketplace update ba-qa-kit`.

## Maintaining

- Every change goes through a pull request.
- On each pull request, GitHub Actions runs:
  - **CI**: `claude plugin validate` on the marketplace and each plugin, and `skill-validator --strict` on each skill.
  - **Claude Code Review**: Claude reviews the diff and leaves comments. Mention `@claude` in a comment to ask it something.
- After a merge, run `/sync-gitlab` in Claude Code from this repo, on a machine on the company network (GitHub's servers cannot reach GitLab). It pushes `main` to GitLab and stops instead of overwriting if GitLab has commits GitHub does not.

One-time setup by the repo owner: run `/install-github-app` in Claude Code from this repo. It installs the Claude GitHub App on the repo and adds the `CLAUDE_CODE_OAUTH_TOKEN` secret, which both Claude workflows need.
