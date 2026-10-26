---
name: sync-gitlab
description: Copy the latest main from GitHub to the GitLab copy the team installs the kit from. Run after a pull request is merged.
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# Sync main to GitLab

The team installs the kit from GitLab.

## Steps

1. `git status --porcelain`. If anything is uncommitted, stop and tell the user to commit or discard it first. Never stash or discard it yourself.
2. `git remote get-url gitlab`. If there is no `gitlab` remote, ask the user for the GitLab SSH URL of this repo (it looks like `git@gitlab.asoft-python.com:<user>/<project>.git`), then `git remote add gitlab <url>`.
3. `git switch main && git pull --ff-only origin main`.
4. `git push gitlab main`. Never use `--force`.
5. `git rev-parse --short main` and `git ls-remote gitlab refs/heads/main` to confirm both point at the same commit.

## When something fails

- Push rejected because GitLab has commits GitHub does not: stop. Someone pushed to GitLab directly. Tell the user; do not overwrite it.
- `Permission denied (publickey)`: the user's SSH key is not on GitLab. Tell them to add it in GitLab under their avatar → Edit profile → SSH Keys.
- Connection timed out: this machine cannot reach GitLab. Tell the user to check their network or VPN.

## Output

In plain Vietnamese, one or two lines: synced commit (short hash and message), or what stopped it and what the user should do. Then remind them that teammates get it with `claude plugin marketplace update ba-qa-kit` and `claude plugin update <plugin>@ba-qa-kit`, and only if the plugin's `version` was raised.
