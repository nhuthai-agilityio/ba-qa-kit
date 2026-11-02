# CLAUDE.md

## Project
Repo for the BA/QA Claude Code kit: one plugin, `ba-qa-kit` in `plugins/ba-qa-kit`, in the marketplace `ba-qa-kit`. BA and QA skills sit side by side and are called `/ba-qa-kit:<skill>`. Code is reviewed on GitHub (pull requests, CI, Claude review). GitLab is where the team installs the kit from; it receives `main` after each merge through `/sync-gitlab`.

## Commands
- `claude plugin validate --strict .` and `claude plugin validate --strict plugins/ba-qa-kit`: marketplace and plugin manifests.
- `skill-validator check plugins/ba-qa-kit/skills/<skill> --strict`: skill format. Add `--allow-extra-frontmatter` for skills with `disable-model-invocation: true`.
- `/sync-gitlab`: after a merge, push `main` to GitLab.

## Conventions
- Project settings live in the project profile block in `CLAUDE.md` (`plugins/ba-qa-kit/references/project-profile.md`). The profile is the only settings the skills read; `/ba-qa-kit:setup` alone also adds the guard rules to `.claude/settings.json`. The shared rules for BA files and the progress line are in `references/ba-files.md`.
- Kit skills live in `plugins/ba-qa-kit/skills/<skill>/SKILL.md`. Each description says what the skill does, then "Use when …". Keep `SKILL.md` at 200 lines or fewer.
- Split a skill's text by when it is needed. Text every run of a skill needs, or that several skills share (for example the ticket-picking rules), goes in `plugins/ba-qa-kit/references/` and is imported on its own line with `@${CLAUDE_PLUGIN_ROOT}/references/<file>.md`: Claude Code loads it with the skill, so it never depends on Claude opening it (an `@` inside backticks is only text). Text only some steps need (an output format, the board part of a skill) stays a separate file the skill names at that step, for Claude to read then.
- Pull requests leave `version` in `plugins/ba-qa-kit/.claude-plugin/plugin.json` as it is. Installed copies only update when it changes, so once a batch of changes is merged, the maintainer opens a release pull request, `chore: release ba-qa-kit <X.Y.Z>`, that only raises it, then runs `/sync-gitlab`.
- Kit files (`plugins/`, `.claude/`, `.github/`, `README.md`, this file) are in English, and so are the outputs the skills write.
- `plugins/ba-qa-kit/templates/settings-guard.json` holds the guard rules `/ba-qa-kit:setup` adds to a project's `.claude/settings.json`. A change to it is checked in a real `claude` session against commands that must be refused and commands that must still run (rules match the whole command with `*` as a wildcard).
- `plugins/ba-qa-kit/hooks/` holds the kit's hooks (`gate.sh`, the go gate; `url-guard.sh`; `secret-guard.sh`; the compaction reminder in `hooks.json`). They are plain `sh`, `sed` and `grep` with no node or jq dependency, so they run on macOS, Ubuntu and Windows (Git Bash). A change to a hook adds a case to `hooks.test.sh`, which CI runs on Ubuntu and Windows.
- Branches: `feat/<short-desc>`, `fix/<short-desc>`, `docs/<short-desc>`, `chore/<short-desc>`. One topic per pull request.
- Commits: Conventional Commits, lowercase imperative (`feat: add ...`, `fix: ...`).
- Skills never write passwords, tokens or personal data, and never act on production URLs. Skills never type a password: QA signs in to the test app in Chrome, and `/ba-qa-kit:verify` stops at a login page.
- Skills ask before they write outside the repo (tickets, comments, issues). Exceptions accepted by the maintainer: `/ba-qa-kit:write-test-cases` creates its `QA test cases` sub-issue (and a new `– v<k>` sub-issue each time it is run again for a ticket) without asking, and `/ba-qa-kit:verify` adds its `QA verify` comment to that sub-issue without asking. `/ba-qa-kit:verify` only adds new comments; it never edits or deletes one. `/ba-qa-kit:write-test-cases` never edits or deletes an existing sub-issue; it adds a new version instead. `/ba-qa-kit:setup` creates the board labels the user approved in its table. `/ba-qa-kit:log-bugs` creates its `[Bug]` child items without asking (the user already said yes in `/ba-qa-kit:verify`). On a bug it logged it may also comment, add or remove the labels `failed` and `passed`, add the label `not-a-bug` and reopen the bug. It asks before it closes a bug. The kit's go gate (`hooks/gate.sh`) opens these no-ask posts only when the user typed the skill's command; when Claude loaded the skill from plain words, a refused post is shown and posted after the user's go ("Writing to the board" in `references/project-profile.md`). A skill commits and pushes its own files on a `docs/…` branch only when the user replies `share` ("Sharing files" in `references/project-profile.md`). On a bug someone else logged (a child item of the ticket, linked to it, or named by the user) it may only add a comment, after the user confirmed it once in the table. In later rounds it comments again without asking on a bug that was already confirmed (its comments hold the TC ID, or `verify-summary.md` marks it as by others).

## Never
- Never push to `main` directly; every change goes through a pull request.
- Never commit secrets, tokens, passwords or `.env` files.
- Never force-push to GitLab or overwrite commits that are only on GitLab.
- Never add AI-attribution lines to commits or pull requests.
