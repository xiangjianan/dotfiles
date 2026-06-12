#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
alias_source="$script_dir/.alias"
alias_target="$HOME/.alias"
csh_alias_target="$HOME/.aliases.csh"

if [ ! -f "$alias_source" ]; then
  printf 'Error: .alias was not found in %s\n' "$script_dir" >&2
  exit 1
fi

append_once() {
  rc_file=$1
  marker=$2
  block=$3

  touch "$rc_file"
  if ! grep -Fq "$marker" "$rc_file"; then
    printf '\n%s\n' "$block" >> "$rc_file"
  fi
}

cp "$alias_source" "$alias_target"

shell_block='# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi'

append_once "$HOME/.bashrc" 'source "$HOME/.alias"' "$shell_block"
append_once "$HOME/.bash_profile" 'source "$HOME/.alias"' "$shell_block"
append_once "$HOME/.zshrc" 'source "$HOME/.alias"' "$shell_block"

sed -n "s/^alias \([^=]*\)='\(.*\)'$/alias \1 '\2'/p" "$alias_target" > "$csh_alias_target"

csh_block='# Load shared aliases
if ( -f ~/.aliases.csh ) then
  source ~/.aliases.csh
endif'

append_once "$HOME/.cshrc" 'source ~/.aliases.csh' "$csh_block"
append_once "$HOME/.tcshrc" 'source ~/.aliases.csh' "$csh_block"

printf 'Installed aliases to %s\n' "$alias_target"
printf 'Updated Bash/Zsh startup files and C Shell/Tcsh startup files.\n'
printf 'Open a new terminal, or run one of these commands now:\n'
printf '  source "$HOME/.alias"        # Bash/Zsh\n'
printf '  source ~/.aliases.csh        # C Shell/Tcsh\n'
