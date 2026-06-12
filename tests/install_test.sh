#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_home="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_home"
}
trap cleanup EXIT

HOME="$tmp_home" "$repo_root/install.sh" >/dev/null
HOME="$tmp_home" "$repo_root/install.sh" >/dev/null

cmp "$repo_root/.alias" "$tmp_home/.alias"

for rc in ".bashrc" ".bash_profile" ".zshrc"; do
  test -f "$tmp_home/$rc"
  count="$(grep -Fc 'source "$HOME/.alias"' "$tmp_home/$rc")"
  test "$count" -eq 1
done

test -f "$tmp_home/.aliases.csh"
grep -Fq "alias gs 'git status'" "$tmp_home/.aliases.csh"
grep -Fq "alias ll 'ls -la'" "$tmp_home/.aliases.csh"

for rc in ".cshrc" ".tcshrc"; do
  test -f "$tmp_home/$rc"
  count="$(grep -Fc 'source ~/.aliases.csh' "$tmp_home/$rc")"
  test "$count" -eq 1
done
