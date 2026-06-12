# dotfiles

这个仓库用于记录常用配置文件。目前主要提供 `.alias`，其中包含 Git、Kubectl、Docker、目录跳转、网络、进程、磁盘、Python、NPM/Node、Systemd 等常用命令别名。

## 推荐安装方式

推荐把仓库里的 `.alias` 放到用户家目录，并在当前 Shell 的启动配置文件里加载它。

在本仓库目录下直接运行：

```sh
./install.sh
```

脚本会完成这些步骤：

- 复制 `.alias` 到 `~/.alias`
- 更新 `~/.bashrc`、`~/.bash_profile`、`~/.zshrc`
- 为 C Shell / Tcsh 生成 `~/.aliases.csh`
- 更新 `~/.cshrc`、`~/.tcshrc`

执行后重新打开终端，或者在当前终端里按正在使用的 Shell 运行：

```sh
source "$HOME/.alias"
```

```csh
source ~/.aliases.csh
```

## Bash

Bash 通常读取 `~/.bashrc`。在 macOS 的登录式 Bash 里，也可能读取 `~/.bash_profile`。

手动配置方式：

```sh
cp .alias "$HOME/.alias"

cat >> "$HOME/.bashrc" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

如果你使用 macOS 自带 Bash，并且新终端没有生效，再把同样的配置加入 `~/.bash_profile`：

```sh
cat >> "$HOME/.bash_profile" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

## Zsh

Zsh 通常读取 `~/.zshrc`。macOS Catalina 及之后版本默认 Shell 是 Zsh。

手动配置方式：

```sh
cp .alias "$HOME/.alias"

cat >> "$HOME/.zshrc" <<'EOF'

# Load shared aliases
if [ -f "$HOME/.alias" ]; then
  source "$HOME/.alias"
fi
EOF
```

让当前终端立即生效：

```sh
source "$HOME/.zshrc"
```

## macOS

macOS 上推荐使用 Zsh 配置：

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

注意：`.alias` 里有少量 Linux 专用命令，例如 `free`、`systemctl`、`journalctl`。这些别名在 macOS 上可以被加载，但只有安装了对应工具或在 Linux 环境中才可正常执行。

## C Shell / Tcsh

当前 `.alias` 使用的是 Bash/Zsh 兼容语法，例如：

```sh
alias gs='git status'
```

C Shell / Tcsh 的别名语法不同，不能直接 `source ~/.alias`。如果必须使用 C Shell / Tcsh，可以生成一份转换后的配置文件：

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

然后重新打开终端，或执行：

```csh
source ~/.cshrc
# 或者
source ~/.tcshrc
```

## 验证是否生效

运行下面任意命令检查别名是否已加载：

```sh
alias gs
alias ll
alias now
```

如果能看到对应命令，例如 `gs='git status'`，说明配置已经生效。

## 更新配置

以后如果仓库里的 `.alias` 有更新，重新复制到家目录即可：

```sh
cp .alias "$HOME/.alias"
source "$HOME/.alias"
```
