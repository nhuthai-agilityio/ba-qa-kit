#!/bin/sh
# Go gate: a kit skill writes outside the repo (board, git) or into the profile and settings only after the user's go,
# enforced by the harness in every permission mode. Same shape as the backend kit's plan gate.
#   sh gate.sh prompt  UserPromptSubmit: reads what the user typed (never what the model wrote).
#                      `/ba-qa-kit:write-test-cases|verify|log-bugs …` opens the gate for that run (`run`): those skills
#                      post without asking (CLAUDE.md's accepted exceptions). Any other `/ba-qa-kit:<skill>` sets it to
#                      `pending`. While pending, a message that is only go, ok go, approve(d), duyệt, lgtm, yes or share
#                      (the kit's own prompts ask yes/no and offer share) sets `go`; while `go`, any other message sets it
#                      back to `pending`. `run` stays until the next kit command.
#   sh gate.sh skill   PostToolUse(Skill): Claude loaded a kit skill on its own (the user asked in plain words): `pending`,
#                      unless a `run` is open (verify loads log-bugs after the user's yes).
#   sh gate.sh reset   SessionStart(startup|clear): a new conversation starts with no gate, so a request outside a kit
#                      skill is never held by an earlier run. A resumed or compacted conversation keeps it.
#   sh gate.sh tool    PreToolUse(Bash|Write|Edit|MultiEdit): while `pending`, a board write (glab/gh issue, MR or PR
#                      create, update, close, reopen, note or comment; label create or edit; api POST, PUT or PATCH),
#                      `git commit`, `git push`, and a write to CLAUDE.md or .claude/settings.json exit 2. Any state: a
#                      command or edit that names the gate file exits 2.
# The gate is <project>/.ba-qa-kit/gate (one per checkout, ignored by git). No gate file: nothing is blocked, so requests
# outside a kit skill work as before. Not seen: a write through a connector (Jira, Trello, Drive) or a script. The hook's
# own failures never block. Plain sh, sed and grep, so it runs on macOS, Ubuntu (dash) and Windows (Git Bash).

input=$(tr '\r\n' '  ') || exit 0
field() {
  printf '%s' "$input" | sed -n -E 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}
proj=${CLAUDE_PROJECT_DIR:-$(field cwd | sed -e 's/\\\\/\\/g')}
[ -n "$proj" ] || exit 0
gate=$proj/.ba-qa-kit/gate
state=$(cat "$gate" 2>/dev/null)
set_state() {
  mkdir -p "$proj/.ba-qa-kit" 2>/dev/null || return 0
  [ -f "$proj/.ba-qa-kit/.gitignore" ] || echo '*' > "$proj/.ba-qa-kit/.gitignore"
  echo "$1" > "$gate"
}
GO='^[[:space:]]*(go|ok,?[[:space:]]*go|approved?|duyệt|duy\\u1ec7t|lgtm|yes|share)[[:space:]]*[.!]?[[:space:]]*$'

case "$1" in
  prompt)
    p=$(field prompt)
    s=$(printf '%s' "$p" | sed -n -E 's#^[[:space:]]*/ba-qa-kit:([a-z-]+).*#\1#p')
    case "$s" in
      write-test-cases|verify|log-bugs) set_state "run:$s" ;;
      ?*) set_state pending ;;
      *) case "$state" in
           pending|go) if printf '%s' "$p" | grep -qiE "$GO"; then set_state go; else set_state pending; fi ;;
         esac ;;
    esac
    exit 0 ;;
  skill)
    s=$(field skill); s=${s#ba-qa-kit:}
    [ -d "${CLAUDE_PLUGIN_ROOT:-/nonexistent}/skills/$s" ] || exit 0
    case "$state" in run:*) ;; *) set_state pending ;; esac
    exit 0 ;;
  reset) rm -f "$gate"; exit 0 ;;
  tool) ;;
  *) exit 0 ;;
esac

block() { echo "ba-qa-kit: $1" >&2; exit 2; }
case "$(field tool_name)" in
  Bash)
    cmd=$(field command | sed -e 's/\\n/;/g' -e 's/\\t/ /g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')
    case "$cmd" in *.ba-qa-kit/gate*) block "the gate file is written only by the hook that reads what the user types. Ask the user to reply go." ;; esac
    [ "$state" = pending ] || exit 0
    if printf '%s' "$cmd" | grep -qE '(^|[;&|( ])(glab|gh)[[:space:]]+(issue|mr|pr)[[:space:]]+(create|update|close|reopen|note|comment|edit)|(^|[;&|( ])(glab|gh)[[:space:]]+label[[:space:]]+(create|edit)|(^|[;&|( ])(glab|gh)[[:space:]]+api.*(-X|--method)[[:space:]=]*(POST|PUT|PATCH|post|put|patch)|(^|[;&|( ])git([[:space:]]+-C[[:space:]]+[^ ]+)?[[:space:]]+(commit|push)'; then
      block "the user has not replied go yet, so nothing is written to the board or to git. Show what will be written (the progress line) and wait for go, yes or share."
    fi ;;
  Write|Edit|MultiEdit)
    f=$(field file_path)
    case "$f" in *.ba-qa-kit/gate*) block "the gate file is written only by the hook that reads what the user types. Ask the user to reply go." ;; esac
    [ "$state" = pending ] || exit 0
    case "$f" in *CLAUDE.md|*.claude/settings.json|*.claude\\\\settings.json)
      block "the user has not replied go yet, so the profile and settings stay as they are. Show the change and wait for go." ;;
    esac ;;
esac
exit 0
