# Shell shortcuts
alias c='clear'
alias q='exit'

# eza: ls with icons, git status and directories first
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias l='ls -l --git'
  alias ll='ls -l --git'
  alias la='ll -a'
  alias lt='ls --tree --level=2'
fi
