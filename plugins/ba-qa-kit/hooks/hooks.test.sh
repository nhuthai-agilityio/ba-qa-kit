#!/bin/sh
# Runs url-guard.sh, secret-guard.sh and gate.sh on inputs they must block and inputs they must let through.
# Usage: sh hooks.test.sh [shell...]   (default: sh; CI also runs bash, and dash on Linux)
here=$(cd "$(dirname "$0")" && pwd)
shells=${*:-sh}
tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT
fails=0
# Token shapes built at run time, so this file holds no real-looking secret.
GL="glpat-$(printf 'x%.0s' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)"
KEY="-----BEGIN RSA PRIV""ATE KEY-----"

# run <expected exit> <hook> <JSON>
run() {
  for shell in $shells; do
    printf '%s' "$3" | "$shell" "$here/$2" 2>/dev/null
    got=$?
    if [ "$got" != "$1" ]; then echo "FAIL ($shell, $2): expected $1, got $got: $3" | cut -c1-240; fails=$((fails + 1)); fi
  done
}

# asks <hook> <JSON>: exit 0 and a permission "ask" on stdout
asks() {
  for shell in $shells; do
    out=$(printf '%s' "$2" | "$shell" "$here/$1" 2>/dev/null); got=$?
    case "$got:$out" in 0:*'"permissionDecision":"ask"'*) ;; *) echo "FAIL ($shell, $1): expected ask, got $got: $2" | cut -c1-240; fails=$((fails + 1)) ;; esac
  done
}
# --- url-guard: a project with a profile, one without
P=$tmp/proj; mkdir -p "$P" "$tmp/none"
printf '%s\n' '<!-- ba-qa-kit:profile:start -->' \
  '**Board:** GitLab `gitlab.abc.example/abc/abc-app`; tickets read with glab, else Chrome, else pasted' \
  '**Test envs:** dev https://dev.abc.example (ready label `Ready for QA`); stag https://stag.abc.example/app. Never production.' \
  '<!-- ba-qa-kit:profile:end -->' > "$P/CLAUDE.md"
nav() { printf '{"cwd":"%s","tool_name":"mcp__claude-in-chrome__navigate","tool_input":{"url":"%s","tabId":1}}' "$1" "$2"; }
asks url-guard.sh "$(nav "$P" https://abc.example)"
asks url-guard.sh "$(nav "$P" https://www.abc.example/login)"
asks url-guard.sh "$(nav "$P" https://app.abc.example/orders?id=1)"
asks url-guard.sh "$(nav "$P" HTTPS://APP.ABC.EXAMPLE)"
run 0 url-guard.sh "$(nav "$P" https://dev.abc.example/orders)"
run 0 url-guard.sh "$(nav "$P" https://stag.abc.example)"
run 0 url-guard.sh "$(nav "$P" https://user@dev.abc.example:8443/x)"
run 0 url-guard.sh "$(nav "$P" https://www.figma.com/file/1)"
run 0 url-guard.sh "$(printf '{"cwd":"%s","tool_name":"mcp__gitlab__get_issue","tool_input":{"url":"%s"}}' "$P" https://gitlab.abc.example/abc/abc-app/-/issues/1)"
asks url-guard.sh "$(printf '{"cwd":"%s","tool_name":"mcp__firefox-devtools__navigate_page","tool_input":{"url":"%s"}}' "$P" https://app.abc.example)"
run 0 url-guard.sh "$(printf '{"cwd":"%s","tool_name":"mcp__firefox-devtools__take_snapshot","tool_input":{}}' "$P")"
run 0 url-guard.sh "$(nav "$P" https://gitlab.example.com/abc/abc-app/-/issues/1)"
run 0 url-guard.sh "$(nav "$P" back)"
run 0 url-guard.sh "$(nav "$tmp/none" https://abc.example)"

# --- secret-guard on writes
wr() { printf '{"cwd":"%s","tool_name":"Write","tool_input":{"file_path":"%s","content":"%s"}}' "$P" "$1" "$2"; }
ed() { printf '{"cwd":"%s","tool_name":"Edit","tool_input":{"file_path":"%s","old_string":"%s","new_string":"%s"}}' "$P" "$1" "$2" "$3"; }
run 2 secret-guard.sh "$(wr "$P/ba-output/gap-report-1-r1.md" "Token: $GL\\nmore")"
run 2 secret-guard.sh "$(wr "$P/qa-output/1-bug-01.md" "$KEY\\nabc")"
run 2 secret-guard.sh "$(ed "$P/CLAUDE.md" "x" "y $GL")"
run 0 secret-guard.sh "$(ed "$P/CLAUDE.md" "old $GL" "[removed]")"
run 0 secret-guard.sh "$(wr "$P/qa-output/1-test-cases.md" "| TC-1-01 | Password: Abc@1234 is rejected | ... |")"
run 0 secret-guard.sh "$(wr "$P/.env" "GITLAB_TOKEN=$GL")"
run 0 secret-guard.sh "$(wr "$P/ba-output/notes.md" "plain text")"

# --- secret-guard on commits and pushes
R=$tmp/repo; git init -q -b main "$R" && git -C "$R" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
git init -q --bare "$tmp/remote.git" && git -C "$R" remote add origin "$tmp/remote.git" && git -C "$R" push -q origin main
echo "notes" > "$R/notes.md"; printf 'token %s\n' "$GL" > "$R/leak.md"; echo "X=1" > "$R/.env"; echo "X=" > "$R/.env.example"
sh_() { printf '{"cwd":"%s","tool_name":"Bash","tool_input":{"command":"%s"}}' "$R" "$1"; }
run 2 secret-guard.sh "$(sh_ 'git add . && git commit -m \"docs: notes\"')"
run 2 secret-guard.sh "$(sh_ 'git add leak.md && git commit -m x')"
run 2 secret-guard.sh "$(sh_ 'git add .env && git commit -m x')"
run 0 secret-guard.sh "$(sh_ 'git add notes.md .env.example && git commit -m \"docs: notes\"')"
run 0 secret-guard.sh "$(sh_ 'git status')"
git -C "$R" add leak.md
run 2 secret-guard.sh "$(sh_ 'git commit -m x')"
run 2 secret-guard.sh "$(sh_ "cd $R && git commit -m x")"
git -C "$R" -c user.name=t -c user.email=t@t commit -q -m leak
run 2 secret-guard.sh "$(sh_ 'git push origin main')"
git -C "$R" reset -q --hard HEAD~1
git -C "$R" add notes.md && git -C "$R" -c user.name=t -c user.email=t@t commit -q -m tracked && printf 'token %s\n' "$GL" >> "$R/notes.md"
run 2 secret-guard.sh "$(sh_ 'git commit -am \"docs: notes\"')"
git -C "$R" reset -q --hard HEAD~1
echo "notes" > "$R/notes.md"
git -C "$R" add notes.md && git -C "$R" -c user.name=t -c user.email=t@t commit -q -m notes
run 0 secret-guard.sh "$(sh_ 'git push -u origin docs/notes')"
run 0 secret-guard.sh "$(sh_ 'git commit --allow-empty -m \"docs: contract notes\"')"

# --- gate: what the user types opens or closes it; board and git writes wait while it is pending
G=$tmp/gate; mkdir -p "$G"
say() { for shell in $shells; do printf '{"cwd":"%s","prompt":"%s"}' "$G" "$1" | "$shell" "$here/gate.sh" prompt; done; }
skill() { printf '{"cwd":"%s","tool_name":"Skill","tool_input":{"skill":"%s"}}' "$G" "$1" | CLAUDE_PLUGIN_ROOT="$here/.." sh "$here/gate.sh" skill; }
bash_() { printf '{"cwd":"%s","tool_name":"Bash","tool_input":{"command":"%s"}}' "$G" "$1"; }
wr_() { printf '{"cwd":"%s","tool_name":"Write","tool_input":{"file_path":"%s","content":"x"}}' "$G" "$1"; }
run_gate() { for shell in $shells; do printf '%s' "$2" | "$shell" "$here/gate.sh" tool 2>/dev/null; got=$?; [ "$got" = "$1" ] || { echo "FAIL ($shell, gate): expected $1, got $got: $2" | cut -c1-200; fails=$((fails + 1)); }; done; }
# no gate file yet: nothing blocked
run_gate 0 "$(bash_ 'glab issue create -t x')"
run_gate 0 "$(bash_ 'git commit -m x')"
say '/ba-qa-kit:write-stories 412'
run_gate 2 "$(bash_ 'glab issue create -t \"[US-01] x\" -l \"user story\"')"
run_gate 2 "$(bash_ 'glab issue note 5 -m done')"
run_gate 2 "$(bash_ 'glab api --hostname h -X POST projects/1/labels -f name=x')"
run_gate 2 "$(bash_ 'git add CLAUDE.md && git commit -m x')"
run_gate 2 "$(bash_ 'git push -u origin docs/x')"
run_gate 2 "$(wr_ "$G/CLAUDE.md")"
run_gate 2 "$(wr_ "$G/.claude/settings.json")"
run_gate 0 "$(wr_ "$G/ba-output/user-stories-412-v1.md")"
run_gate 0 "$(bash_ 'glab issue view 412 --comments')"
run_gate 0 "$(bash_ 'git status && git log --oneline')"
say 'change US-02 please'
run_gate 2 "$(bash_ 'glab issue create -t x')"
say 'Go!'
run_gate 0 "$(bash_ 'glab issue create -t x')"
run_gate 0 "$(bash_ 'git commit -m x')"
say 'actually wait'
run_gate 2 "$(bash_ 'glab issue create -t x')"
say 'duyệt'
run_gate 0 "$(bash_ 'glab issue create -t x')"
say 'ok'
run_gate 2 "$(bash_ 'glab issue create -t x')"
say 'share'
run_gate 0 "$(bash_ 'git push -u origin docs/x')"
# typed run commands post without a go; a yes inside the run keeps it
say '/ba-qa-kit:verify #415 --env dev'
run_gate 0 "$(bash_ 'glab issue note 9 -m \"QA verify\"')"
run_gate 0 "$(bash_ 'glab issue note 9 -m \"QA verify – #415 – dev – Round 1 – reported by QA – 2026-11-02\"')"
say 'yes'
skill 'ba-qa-kit:log-bugs'
run_gate 0 "$(bash_ 'glab issue create -t \"[Bug] x\"')"
# a skill Claude loads on its own: pending
say '/ba-qa-kit:find-gaps 1'
say 'go'
skill 'ba-qa-kit:write-stories'
run_gate 2 "$(bash_ 'glab issue create -t x')"
# a new conversation clears it
printf '{"cwd":"%s","source":"startup"}' "$G" | sh "$here/gate.sh" reset
run_gate 0 "$(bash_ 'glab issue create -t x')"
say '/ba-qa-kit:setup'
# the gate file itself
run_gate 2 "$(bash_ 'echo go > .ba-qa-kit/gate')"
run_gate 2 "$(wr_ "$G/.ba-qa-kit/gate")"
[ "$(cat "$G/.ba-qa-kit/.gitignore")" = '*' ] || { echo "FAIL: .ba-qa-kit/.gitignore"; fails=$((fails + 1)); }

[ "$fails" -eq 0 ] && echo "hooks: all cases pass ($shells)"
exit "$fails"
