#!/bin/sh
# PreToolUse(Bash) hook: Claude never pushes to main or master, and never force pushes, in the project where the kit runs.
# Reads the hook JSON on stdin. Exit 2 blocks the command and shows the message to Claude; any failure of its own exits 0.
# Plain sh, sed and awk, so it runs on macOS, Ubuntu (dash) and Windows (Git Bash) without node or jq.
# Blocked: a push whose target is main or master (`origin main`, `HEAD:main`, `refs/heads/main`, `git -C dir push`,
# after `cd dir &&`, inside `bash -c "..."`), a push with no branch while the current branch is main or master,
# --force / -f / --force-with-lease / +ref, --all and --mirror.
# Not seen: a branch name built from a variable, a script that pushes, a push a person types in a terminal.
# The server's protected branch covers those.

input=$(tr '\r\n' '  ') || exit 0

# The value of a JSON string field, still escaped (the first one named $1).
field() {
  printf '%s' "$input" | sed -n -E 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}

cmd=$(field command | sed -e 's/\\n/;/g' -e 's/\\t/ /g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')
case "$cmd" in *push*) ;; *) exit 0 ;; esac
cwd=$(field cwd | sed -e 's/\\\\/\\/g')

# Prints BLOCK, or one "HEAD <dir>" line for each push that names no branch (its target is the current branch).
out=$(CMD="$cmd" DIR="$cwd" awk '
function block() { print "BLOCK"; exit }
function within(d, base) { return (d ~ /^\// || d ~ /^[A-Za-z]:/) ? d : base "/" d }
BEGIN {
  q = sprintf("%c", 39)
  dir = ENVIRON["DIR"]; c = ENVIRON["CMD"]
  gsub(/&&|\|\||[;|&()]/, "\n", c)
  n = split(c, seg, "\n")
  for (s = 1; s <= n; s++) {
    split("", a); m = split(seg[s], w, /[ \t]+/); k = 0
    for (i = 1; i <= m; i++) { t = w[i]; gsub("[\"`" q "]", "", t); if (t != "") a[++k] = t }
    if (k >= 2 && a[1] == "cd") { dir = within(a[2], dir); continue }
    for (i = 1; i <= k; i++) if (a[i] == "git" || a[i] ~ /[\/\\]git(\.exe)?$/) break
    if (i > k) continue
    gdir = dir
    for (i++; i <= k; i++) {
      if (a[i] == "-C") { i++; gdir = within(a[i], gdir); continue }
      if (a[i] == "-c" || a[i] == "--git-dir" || a[i] == "--work-tree" || a[i] == "--namespace") { i++; continue }
      if (a[i] !~ /^-/) break
    }
    if (a[i] != "push") continue
    pos = 0; head = 0
    for (i++; i <= k; i++) {
      t = a[i]
      if (t ~ /^--(force|mirror|all)/) block()
      if (t == "-o" || t == "--push-option" || t == "--repo" || t == "--receive-pack" || t == "--exec") { i++; continue }
      if (t ~ /^--/) continue
      if (t ~ /^-/) { if (t ~ /f/) block(); continue }
      if (++pos == 1) continue
      if (t ~ /^\+/) block()
      if (index(t, ":")) t = substr(t, index(t, ":") + 1)
      else if (t == "HEAD") { head = 1; continue }
      sub(/^refs\/heads\//, "", t)
      if (t == "main" || t == "master") block()
    }
    if (pos <= 1 || head) print "HEAD " gdir
  }
}') || exit 0

blocked=
case "$out" in BLOCK*) blocked=1 ;; esac
old_ifs=$IFS; IFS='
'
for line in $out; do
  case "$line" in
    "HEAD "*) branch=$(git -C "${line#HEAD }" symbolic-ref --short -q HEAD 2>/dev/null)
              case "$branch" in main|master) blocked=1 ;; esac ;;
  esac
done
IFS=$old_ifs

[ -n "$blocked" ] || exit 0
echo "ba-qa-kit blocked this push: from Claude Code, nothing is pushed to main or master and nothing is force pushed. Create a branch (git switch -c <name>), push that branch, and ask the user to open a merge request. Do not suggest merging into main or master and pushing another way: the team merges through merge requests." >&2
exit 2
