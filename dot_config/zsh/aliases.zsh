# eza: ls with icons, git status and directories first
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='ls -l --git'
  alias la='ll -a'
  alias lt='ls --tree --level=2'
fi
