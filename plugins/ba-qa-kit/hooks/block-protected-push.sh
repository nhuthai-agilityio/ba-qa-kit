#!/bin/sh
# PreToolUse(Bash) hook: Claude never pushes to main or master, and never force pushes, in the project where the kit runs.
# Reads the hook JSON on stdin. Exit 2 blocks the command and shows the message to Claude; any failure of its own exits 0.
# Plain sh, sed and awk, so it runs on macOS, Ubuntu (dash) and Windows (Git Bash) without node or jq.
# Blocked: a push whose target is main or master (`origin main`, `HEAD:main`, `refs/heads/main`, `git -C dir push`,
# after `cd dir &&`, inside `bash -c "..."`), a push with no branch while on main or master (the current branch, or one
# an earlier `git checkout`/`git switch` in the same command moves to), --force / -f / --force-with-lease / +ref,
# --all and --mirror.
# Not seen: a branch name built from a variable, a script that pushes, a push a person types in a terminal. A `;`, `&&` or `|` inside quoted text splits the command too, so a
# commit message such as "a; git push origin main" is blocked by mistake: safe, and rare.

input=$(tr '\r\n' '  ') || exit 0

# The value of a JSON string field, still escaped (the last one named $1; the hook JSON has one).
field() {
  printf '%s' "$input" | sed -n -E 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}

cmd=$(field command | sed -e 's/\\n/;/g' -e 's/\\t/ /g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')
case "$cmd" in *push*) ;; *) exit 0 ;; esac
cwd=$(field cwd | sed -e 's/\\\\/\\/g')

# Prints BLOCK, or one "HEAD <dir>" line for each push that names no branch while the branch is unknown (git tells).
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
    if (k >= 2 && a[1] == "cd") { dir = within(a[2], dir); cur = ""; continue }
    # git must be the command itself, after wrappers such as bash -c, env, VAR=value
    for (i = 1; i <= k; i++)
      if (a[i] !~ /^(bash|sh|zsh|-c|-lc|env|command|exec|nohup|time|sudo)$/ && a[i] !~ /^[A-Za-z_][A-Za-z0-9_]*=/) break
    if (i > k || (a[i] != "git" && a[i] !~ /[\/\\]git(\.exe)?$/)) continue
    gdir = dir
    for (i++; i <= k; i++) {
      if (a[i] == "-C") { i++; gdir = within(a[i], gdir); continue }
      if (a[i] == "-c" || a[i] == "--git-dir" || a[i] == "--work-tree" || a[i] == "--namespace") { i++; continue }
      if (a[i] !~ /^-/) break
    }
    if (a[i] == "checkout" || a[i] == "switch") {
      # the branch later pushes in this command start from; `checkout <branch> -- <file>` stays on the branch
      to = ""; for (i++; i <= k; i++) {
        if (a[i] == "--") { to = ""; break }
        if (a[i] ~ /^-[cCbB]$/ || a[i] == "--create" || a[i] == "--force-create") { to = a[++i]; break }
        if (a[i] !~ /^-/ && to == "") to = a[i]
      }
      if (to != "") cur = to
      continue
    }
    if (a[i] != "push") continue
    pos = 0; head = 0
    for (i++; i <= k; i++) {
      t = a[i]
      if (t ~ /^--(force|mirror|all)/) block()
      if (t == "-o" || t == "--push-option" || t == "--repo" || t == "--receive-pack" || t == "--exec") { i++; continue }
      if (t ~ /^--/) continue
      # short flags: -f, or f in a cluster such as -uf, is a force push (-o, the one that takes a value, is above)
      if (t ~ /^-/) { if (t ~ /f/) block(); continue }
      if (++pos == 1) continue
      if (t ~ /^\+/) block()
      if (index(t, ":")) t = substr(t, index(t, ":") + 1)
      else if (t == "HEAD") { head = 1; continue }
      sub(/^refs\/heads\//, "", t)
      if (t == "main" || t == "master") block()
    }
    if (pos <= 1 || head) {
      if (cur == "main" || cur == "master") block()
      if (cur == "") print "HEAD " gdir
    }
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
echo "ba-qa-kit blocked this push: from Claude Code, nothing is pushed to main or master and nothing is force pushed. Push a branch instead (git switch -c <name>) and tell the user; they decide how the change reaches main." >&2
exit 2
