#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous\n\n"

brew_install "Transmission" "transmission" "homebrew/cask" "cask"
brew_install "Unarchiver" "the-unarchiver" "homebrew/cask" "cask"
brew_install "VLC" "vlc" "homebrew/cask" "cask"
brew_install "LibreOffice" "libreoffice"
