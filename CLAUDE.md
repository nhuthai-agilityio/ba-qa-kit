# CLAUDE.md

## Project
Repo for the BA/QA Claude Code kit: two plugins in one marketplace (`ba-qa-kit`), `ba` in `plugins/ba` and `qa` in `plugins/qa`. Code is reviewed on GitHub (pull requests, CI, Claude review). GitLab is where the team installs the kit from; it receives `main` after each merge through `/sync-gitlab`. `nhu/` holds BA practice work (notes, a sample app, Playwright tests); it is not part of the kit.

## Commands
- `claude plugin validate --strict .` and `claude plugin validate --strict plugins/<name>`: marketplace and plugin manifests.
- `skill-validator check plugins/<name>/skills/<skill> --strict`: skill format. Add `--allow-extra-frontmatter` for skills with `disable-model-invocation: true`.
- `/sync-gitlab`: after a merge, push `main` to GitLab.

## Conventions
- Kit skills live in `plugins/<plugin>/skills/<skill>/SKILL.md`. Each description says what the skill does, then "Use when …". Keep `SKILL.md` at 200 lines or fewer.
- A pull request that changes anything under `plugins/<name>/` raises `version` in `plugins/<name>/.claude-plugin/plugin.json`. Installed copies only update when it changes.
- Kit files (`plugins/`, `.claude/`, `.github/`, `README.md`, this file) are in English, and so are the outputs the skills write. `nhu/` may be in Vietnamese.
- Branches: `feat/<short-desc>`, `fix/<short-desc>`, `docs/<short-desc>`, `chore/<short-desc>`. One topic per pull request.
- Commits: Conventional Commits, lowercase imperative (`feat: add ...`, `fix: ...`).
- Skills never write passwords, tokens or personal data, and never act on production URLs.
- Skills ask before they write outside the repo (tickets, comments, issues). Exception accepted by the maintainer: `/qa:write-test-cases` creates its `QA test cases` sub-issue without asking. It still asks before it updates an existing sub-issue.

## Never
- Never push to `main` directly; every change goes through a pull request.
- Never commit secrets, tokens or `.env` files.
- Never force-push to GitLab or overwrite commits that are only on GitLab.
- Never add AI-attribution lines to commits or pull requests.
