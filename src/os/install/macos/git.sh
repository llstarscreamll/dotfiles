#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Git\n\n"

brew_install "Git" "git"
brew_install "GitHub CLI" "github/gh/gh"
brew_install "Git Flow AVH" "git-flow-avh"

# based on this StackOverflow response to make zsh git and git flow avh
# completion plugin work:
# https://stackoverflow.com/a/63795166/3395068
# commented in this post too:
# https://nickdenardis.com/2020/10/25/git-flow-completion-with-oh-my-zsh-on-macos/
if test -f "/usr/local/share/zsh/site-functions/_git"; then
    exec "rm /usr/local/share/zsh/site-functions/_git" "delete site-functions/_git"
fi

if test -f "/usr/local/etc/bash_completion.d/git-flow-completion.bash"; then
    exec "rm /usr/local/etc/bash_completion.d/git-flow-completion.bash" "delete git-flow-completion.bash"
fi
