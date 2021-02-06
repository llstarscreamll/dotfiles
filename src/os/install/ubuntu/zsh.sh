#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   ZSH\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "\n"

install_package "ZSH" "zsh"
chsh -s `which zsh`
execute "cd && curl -L git.io/antigen > .antigen.zsh" "Antigen"

