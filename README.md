# dotfiles

**English** | [简体中文](README.zh-CN.md)

This repository keeps commonly used configuration files. For now it mainly provides `.alias`, which contains command aliases for Git, Kubectl, Docker, directory jumping, networking, processes, disks, Python, NPM/Node, Systemd, and more.

## Recommended Installation

The recommended approach is to put the repository's `.alias` in your home directory and load it from your current shell's startup config file.

Run directly in the repository directory:

```sh
./install.sh
```

The script performs these steps:

- Copies `.alias` to `~/.alias`
- Updates `~/.bashrc`, `~/.bash_profile`, `~/.zshrc`
- Generates `~/.aliases.csh` for C Shell / Tcsh
- Updates `~/.cshrc`, `~/.tcshrc`

Afterwards, reopen your terminal, or run in the current terminal depending on the shell you use:

```sh
source "$HOME/.alias"
```

```csh
source ~/.aliases.csh
```

## Bash

Bash usually reads `~/.bashrc`. On macOS, a login Bash may also read `~/.bash_profile`.

Manual setup:

```sh
cp .alias "$HOME/.alias"

cat >> "$HOME/.bashrc" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

If you use the Bash bundled with macOS and the config doesn't take effect in new terminals, also add the same config to `~/.bash_profile`:

```sh
cat >> "$HOME/.bash_profile" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

## Zsh

Zsh usually reads `~/.zshrc`. Zsh is the default shell on macOS Catalina and later.

Manual setup:

```sh
cp .alias "$HOME/.alias"

cat >> "$HOME/.zshrc" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

To apply immediately in the current terminal:

```sh
source "$HOME/.zshrc"
```

## macOS

On macOS, Zsh is the recommended setup:

```sh
cp .alias "$HOME/.alias"

grep -Fq 'source "$HOME/.alias"' "$HOME/.zshrc" 2>/dev/null || cat >> "$HOME/.zshrc" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF

source "$HOME/.zshrc"
```

Note: `.alias` contains a few Linux-only commands such as `free`, `systemctl`, and `journalctl`. These aliases can still be loaded on macOS, but they only execute properly if the corresponding tools are installed or you are in a Linux environment.

## C Shell / Tcsh

The current `.alias` uses Bash/Zsh-compatible syntax, for example:

```sh
alias gs='git status'
```

C Shell / Tcsh alias syntax is different, so you cannot `source ~/.alias` directly. If you must use C Shell / Tcsh, you can generate a converted config file:

```sh
cp .alias "$HOME/.alias"
sed -n "s/^alias \([^=]*\)='\(.*\)'$/alias \1 '\2'/p" "$HOME/.alias" > "$HOME/.aliases.csh"

for rc in "$HOME/.cshrc" "$HOME/.tcshrc"; do
  touch "$rc"
  grep -Fq 'source ~/.aliases.csh' "$rc" 2>/dev/null || cat >> "$rc" <<'EOF'

# Load shared aliases
if ( -f ~/.aliases.csh ) then
  source ~/.aliases.csh
endif
EOF
done
```

Then reopen your terminal, or run:

```csh
source ~/.cshrc
# or
source ~/.tcshrc
```

## Verify It Works

Run any of the following commands to check whether the aliases are loaded:

```sh
alias gs
alias ll
alias now
```

If you see the corresponding command, e.g. `gs='git status'`, the config has taken effect.

## Updating

If `.alias` in the repository gets updated later, simply copy it to your home directory again:

```sh
cp .alias "$HOME/.alias"
source "$HOME/.alias"
```
