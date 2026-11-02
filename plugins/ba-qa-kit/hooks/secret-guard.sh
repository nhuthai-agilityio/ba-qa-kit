#!/bin/sh
# PreToolUse hook: no token or private key goes into a file Claude writes, a commit or a push.
#   Write | Edit | MultiEdit: the new text is checked (a `.env` file itself is left to the guard rules in settings).
#   Bash with `git commit` or `git push`: the files it would commit or push are checked: the staged files, the files
#   a `git add` in the same command or `git commit -a` adds, and the files in commits not on any remote yet. A `.env` file is refused too
#   (`.env.example`, `.env.sample` and `.env.template` are fine).
# Only clear token shapes count (GitLab, GitHub, Anthropic, AWS, Slack, Google keys, private keys, JWTs): a word such as
# "password" in a test case is test data, not a secret. Exit 2 blocks; any failure of its own exits 0.
# Plain sh, sed and grep, so it runs on macOS, Ubuntu (dash) and Windows (Git Bash).

PAT='glpat-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{40,}|sk-ant-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|xox[abprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}'

input=$(tr '\r\n' '  ') || exit 0
field() {
  printf '%s' "$input" | sed -n -E 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}
is_env() { case "${1##*/}" in .env.example|.env.sample|.env.template) return 1 ;; .env|.env.*) return 0 ;; esac; return 1; }

case "$(field tool_name)" in
  Write|Edit|MultiEdit)
    file=$(field file_path)
    is_env "$file" && exit 0
    if printf '%s' "$input" | grep -oE '"(content|new_string)"[[:space:]]*:[[:space:]]*"([^"\\]|\\.)*"' | grep -qE "$PAT"; then
      echo "ba-qa-kit blocked writing ${file##*/}: the text holds what looks like a token or private key. Never write tokens, passwords or keys into files; write [removed] instead." >&2
      exit 2
    fi
    exit 0 ;;
  Bash) ;;
  *) exit 0 ;;
esac

cmd=$(field command | sed -e 's/\\n/;/g' -e 's/\\t/ /g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')
case "$cmd" in *git*commit*|*git*push*) ;; *) exit 0 ;; esac
dir=$(field cwd | sed -e 's/\\\\/\\/g'); dir=${dir:-.}
d=$(printf '%s' "$cmd" | sed -n -E 's/^[[:space:]]*cd[[:space:]]+([^ ;&|]+).*/\1/p')
[ -n "$d" ] && case "$d" in /*|[A-Za-z]:*) dir=$d ;; *) dir=$dir/$d ;; esac
d=$(printf '%s' "$cmd" | sed -n -E 's/.*git[[:space:]]+-C[[:space:]]+([^ ;&|]+).*/\1/p')
[ -n "$d" ] && case "$d" in /*|[A-Za-z]:*) dir=$d ;; *) dir=$dir/$d ;; esac
cd "$dir" 2>/dev/null && top=$(git rev-parse --show-toplevel 2>/dev/null) && cd "$top" || exit 0

files=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null)
add=$(printf '%s' "$cmd" | sed -n -E 's/.*git[[:space:]]+add[[:space:]]+([^;&|]*).*/\1/p')
case " $add " in
  "  ") ;;
  *" . "*|*" -A "*|*" --all "*|*" -u "*|*" --update "*) files="$files
$(git ls-files -mo --exclude-standard 2>/dev/null)" ;;
  *) for p in $add; do case "$p" in -*) ;; *) files="$files
$p" ;; esac; done ;;
esac
case "$cmd" in *commit*" -a"*|*commit*" --all"*) files="$files
$(git diff --name-only 2>/dev/null)" ;; esac
case "$cmd" in *push*) files="$files
$(git log --name-only --format= HEAD --not --remotes 2>/dev/null)" ;; esac

old_ifs=$IFS; IFS='
'
for f in $files; do
  [ -f "$f" ] || continue
  if is_env "$f" || grep -IqE "$PAT" "$f" 2>/dev/null; then
    IFS=$old_ifs
    echo "ba-qa-kit blocked this git command: $f is a .env file or holds what looks like a token or private key, and it would be committed or pushed. Leave it out of the commit and tell the user." >&2
    exit 2
  fi
done
exit 0
