#!/bin/sh
# Runs guard-commands.sh on commands it must block and commands it must let through.
# Usage: sh guard-commands.test.sh [shell...]   (default: sh; CI also runs dash and bash)
here=$(cd "$(dirname "$0")" && pwd)
shells=${*:-sh}
tmp=$(mktemp -d) && trap 'rm -rf "$tmp"' EXIT
for b in main feat; do
  git init -q -b "$b" "$tmp/$b" && git -C "$tmp/$b" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
done
fails=0

# check <expected exit> <cwd> <command as it appears inside the JSON string>
check() {
  for shell in $shells; do
    printf '{"session_id":"x","cwd":"%s","tool_name":"Bash","tool_input":{"command":"%s","description":"git push origin main"}}' "$2" "$3" \
      | "$shell" "$here/guard-commands.sh" 2>/dev/null
    got=$?
    if [ "$got" != "$1" ]; then echo "FAIL ($shell): expected $1, got $got: $3"; fails=$((fails + 1)); fi
  done
}

M=$tmp/main F=$tmp/feat
# blocked
check 2 "$F" 'git push origin main'
check 2 "$F" 'git push origin master'
check 2 "$F" 'git push -u origin main'
check 2 "$F" 'git push origin HEAD:main'
check 2 "$F" 'git push origin feat:refs/heads/main'
check 2 "$F" 'git push origin refs/heads/master'
check 2 "$F" 'git push origin :main'
check 2 "$F" 'git push --delete origin main'
check 2 "$F" 'git -C ../app push origin main'
check 2 "$F" 'cd app && git push origin main'
check 2 "$F" 'git add . && git commit -m \"docs: profile\" && git push origin main'
check 2 "$F" 'bash -c \"git push origin main\"'
check 2 "$F" 'git push origin \"main\"'
check 2 "$F" 'git push --force origin feat'
check 2 "$F" 'git push -f origin feat'
check 2 "$F" 'git push -uf origin feat'
check 2 "$F" 'git push --force-with-lease origin feat'
check 2 "$F" 'git push origin +feat'
check 2 "$F" 'git push --all origin'
check 2 "$F" 'git push --mirror origin'
check 2 "$M" 'git push'
check 2 "$M" 'git push origin'
check 2 "$M" 'git push -u origin HEAD'
check 2 "$F" "cd $M && git push"
check 2 "$F" "git -C $M push"
check 2 "$F" 'git status\ngit push origin main'
check 2 "$F" 'git checkout main && git push'
check 2 "$F" 'git switch main && git push origin HEAD'
check 2 "$F" 'git checkout main && git merge feat && git push'
check 2 "$F" 'git switch master; git pull; git push -u origin'
check 2 "$F" 'GIT_TRACE=1 git push origin main'
check 2 "$F" 'env X=1 git push origin main'
check 2 "$F" 'glab issue delete 12'
check 2 "$F" 'glab label delete Bug -R g/p'
check 2 "$F" 'glab repo delete g/p --yes'
check 2 "$F" 'glab api -X DELETE projects/1/issues/2'
check 2 "$F" 'glab api --hostname gitlab.example.com --method DELETE projects/1/labels/3'
check 2 "$F" 'glab api -XDELETE projects/1/issues/2'
check 2 "$F" 'glab api --method=delete projects/1/issues/2'
check 2 "$F" 'gh issue delete 3 --yes'
check 2 "$F" 'gh api -X DELETE repos/o/r/labels/bug'
check 2 "$F" 'bash -c \"glab issue delete 1\"'
check 2 "$F" 'glab issue view 5 && glab issue delete 5'
# allowed
check 0 "$F" 'glab issue view 5 -F json --comments'
check 0 "$F" 'glab issue close 5'
check 0 "$F" 'glab issue note 5 -m \"please delete the old row\"'
check 0 "$F" 'glab api --hostname h -X POST projects/1/labels'
check 0 "$F" 'glab label list'
check 0 "$F" 'gh issue list --label bug'
check 0 "$F" 'echo \"glab issue delete 5\"'
check 0 "$F" 'git push origin feat'
check 0 "$F" 'git push -u origin feat'
check 0 "$F" 'git push origin HEAD:feat'
check 0 "$F" 'git push origin main:feat'
check 0 "$F" 'git push origin feat/main-menu'
check 0 "$F" 'git push origin docs/master-plan'
check 0 "$F" 'git push'
check 0 "$F" 'git push origin HEAD'
check 0 "$F" 'git push --tags origin'
check 0 "$M" 'git switch -c docs/profile && git push -u origin docs/profile'
check 0 "$M" 'git status'
check 0 "$M" 'git pull origin main'
check 0 "$M" 'echo push to main later'
check 0 "$M" 'glab issue list'
check 0 "$M" 'git log --oneline main'
check 0 "" 'git push origin feat'
check 0 "$M" 'git switch -c docs/x && git push'
check 0 "$M" 'git checkout -b docs/y main && git push -u origin'
check 0 "$F" 'git checkout main -- CLAUDE.md && git push'
check 0 "$F" 'echo \"run git push origin main\"'
check 0 "$F" 'git commit -m \"docs: git push origin main\"'

[ "$fails" -eq 0 ] && echo "guard-commands: all cases pass ($shells)"
exit "$fails"
