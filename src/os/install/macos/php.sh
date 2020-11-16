#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   PHP Tools\n\n"

brew_install "PHP7.3" "php@7.3"
brew_install "PHP7.4" "php@7.4"
brew_install "Composer" "composer"
