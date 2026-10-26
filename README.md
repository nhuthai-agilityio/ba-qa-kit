# BA/QA kit for Claude Code

Two Claude Code plugins in one marketplace (`ba-qa-kit`):

- `ba` (`nhu/plugins/ba`): user stories with Given/When/Then acceptance criteria. No skills yet.
- `qa` (`nhu/plugins/qa`): `/qa:test` writes test cases, `/qa:verify` checks a ticket in Chrome, `/qa:bug` drafts a bug report. Settings come from `qa.config.json`.

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
  - **Sync to GitLab**: checks that GitLab is reachable.
- After a merge, **Sync to GitLab** pushes `main` to GitLab, so the team gets the new version. It can also be run by hand from the Actions tab.

One-time setup by the repo owner (Settings → Secrets and variables → Actions):

| Name | Kind | Value |
|---|---|---|
| `CLAUDE_CODE_OAUTH_TOKEN` | secret | output of `claude setup-token` |
| `GITLAB_SSH_KEY` | secret | private key of a GitLab deploy key with write access |
| `GITLAB_REPO` | variable | GitLab SSH URL, e.g. `git@gitlab.asoft-python.com:<user>/<project>.git` |

On GitLab: Settings → Repository → Deploy keys → add the public key with "Grant write permissions", then under Protected branches allow that deploy key to push to `main`.
