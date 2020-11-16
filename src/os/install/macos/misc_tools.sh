#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous Tools\n\n"

brew_install "ShellCheck" "shellcheck"
brew_install "OpenVpn" "openvpn"
brew_install "Slack" "slack" "homebrew/cask" "cask"
brew_install "iTerm2" "iterm2" "homebrew/cask" "cask"
brew_install "TablePlus" "tableplus" "homebrew/cask" "cask"
open "macappstores://itunes.apple.com/en/app/todoist-lista-de-tareas/id585829637"

if [ -d "$HOME/.nvm" ]; then
    brew_install "Yarn" "yarn"
fi
