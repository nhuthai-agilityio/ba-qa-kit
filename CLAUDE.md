# CLAUDE.md

## Project
Repo for the BA/QA Claude Code kit: one plugin, `ba-qa-kit` in `plugins/ba-qa-kit`, in the marketplace `ba-qa-kit`. BA and QA skills sit side by side and are called `/ba-qa-kit:<skill>`. Code is reviewed on GitHub (pull requests, CI, Claude review). GitLab is where the team installs the kit from; it receives `main` after each merge through `/sync-gitlab`.

## Commands
- `claude plugin validate --strict .` and `claude plugin validate --strict plugins/ba-qa-kit`: marketplace and plugin manifests.
- `skill-validator check plugins/ba-qa-kit/skills/<skill> --strict`: skill format. Add `--allow-extra-frontmatter` for skills with `disable-model-invocation: true`.
- `/sync-gitlab`: after a merge, push `main` to GitLab.

## Conventions
- Project settings live in the project profile block in `CLAUDE.md` (`plugins/ba-qa-kit/references/project-profile.md`). Skills never read or write a config file, and the shared rules for BA files and the progress line are in `references/ba-files.md`.
- Kit skills live in `plugins/ba-qa-kit/skills/<skill>/SKILL.md`. Each description says what the skill does, then "Use when …". Keep `SKILL.md` at 200 lines or fewer.
- A pull request that changes anything under `plugins/ba-qa-kit/` raises `version` in `plugins/ba-qa-kit/.claude-plugin/plugin.json`. Installed copies only update when it changes. If another open pull request raised it too, the second one to merge raises it again.
- Kit files (`plugins/`, `.claude/`, `.github/`, `README.md`, this file) are in English, and so are the outputs the skills write.
- Branches: `feat/<short-desc>`, `fix/<short-desc>`, `docs/<short-desc>`, `chore/<short-desc>`. One topic per pull request.
- Commits: Conventional Commits, lowercase imperative (`feat: add ...`, `fix: ...`).
- Skills never write passwords, tokens or personal data, and never act on production URLs. Skills never type a password: QA signs in to the test app in Chrome, and `/ba-qa-kit:verify` stops at a login page.
- Skills ask before they write outside the repo (tickets, comments, issues). Exceptions accepted by the maintainer: `/ba-qa-kit:write-test-cases` creates its `QA test cases` sub-issue (and a new `– v<k>` sub-issue each time it is run again for a ticket) without asking, and `/ba-qa-kit:verify` adds its `QA verify` comment to that sub-issue without asking. `/ba-qa-kit:verify` only adds new comments; it never edits or deletes one. `/ba-qa-kit:write-test-cases` never edits or deletes an existing sub-issue; it adds a new version instead. `/ba-qa-kit:setup` creates the board labels the user approved in its table. `/ba-qa-kit:log-bugs` creates its `[Bug]` child items without asking (the user already said yes in `/ba-qa-kit:verify`). On a bug it logged it may also comment, add or remove the labels `failed` and `passed`, add the label `not-a-bug` and reopen the bug. It asks before it closes a bug. On a bug someone else logged (a child item of the ticket, linked to it, or named by the user) it may only add a comment, after the user confirmed it once in the table. In later rounds it comments again without asking on a bug that was already confirmed (its comments hold the TC ID, or `verify-summary.md` marks it as by others).

## Never
- Never push to `main` directly; every change goes through a pull request.
- Never commit secrets, tokens, passwords or `.env` files.
- Never force-push to GitLab or overwrite commits that are only on GitLab.
- Never add AI-attribution lines to commits or pull requests.
