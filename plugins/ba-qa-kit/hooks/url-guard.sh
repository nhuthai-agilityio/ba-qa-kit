#!/bin/sh
# PreToolUse(Chrome navigate) hook: Claude does not open the production app in Chrome.
# The profile keeps only the dev and stag URLs (setup never saves production), so production is guessed: another host
# on the same domain as dev or stag (dev.abc.example → abc.example, www.abc.example, app.abc.example) is blocked; dev,
# stag and every other site open as usual.
# ponytail: the domain is the host minus its first label; a production app on another domain is not seen, and a link
# clicked inside a page is not a navigate call.
# No profile, or no URL on its Test envs line: nothing is checked. Exit 2 blocks; any failure of its own exits 0.
# Plain sh, sed and grep, so it runs on macOS, Ubuntu (dash) and Windows (Git Bash).

input=$(tr '\r\n' '  ') || exit 0
field() {
  printf '%s' "$input" | sed -n -E 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}
host_of() { sed -E 's#^[A-Za-z]+://([^/@]*@)?([^/:?#]+).*#\2#' | tr 'A-Z' 'a-z'; }

url=$(field url)
case "$(printf '%s' "$url" | tr 'A-Z' 'a-z')" in http://*|https://*) ;; *) exit 0 ;; esac
host=$(printf '%s\n' "$url" | host_of)

dir=$(field cwd | sed -e 's/\\\\/\\/g'); dir=${dir:-.}
root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
envs=$(cat "$dir/CLAUDE.md" "$root/CLAUDE.md" 2>/dev/null | grep -m1 '^\*\*Test envs:\*\*')
hosts=$(printf '%s\n' "$envs" | grep -oE 'https?://[^ );,`]+' | host_of)
[ -n "$hosts" ] || exit 0

for h in $hosts; do [ "$host" = "$h" ] && exit 0; done
for h in $hosts; do
  case "$h" in *[!0-9.]*.*.*) base=${h#*.} ;; *) continue ;; esac   # IP addresses and two-label hosts: no guess
  case "$host" in "$base"|*".$base")
    echo "ba-qa-kit blocked opening $url: it is on the same domain as the profile's test envs ($(echo $hosts)) but is not one of them, so it may be production. Test on dev or stag only. If it is a test env, add it to the profile's Test envs line; otherwise tell the user." >&2
    exit 2 ;;
  esac
done
exit 0
