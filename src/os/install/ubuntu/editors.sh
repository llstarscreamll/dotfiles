#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Editors\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! package_is_installed "code"; then

    add_key "https://packages.microsoft.com/keys/microsoft.asc" \
        || print_error "VSCode (add key)"

    add_to_source_list "[arch=amd64] https://packages.microsoft.com/repos/vscode stable main" "vscode.list" \
        || print_error "VS Code (add to package resource list)"

    update &> /dev/null \
        || print_error "VS Code (resync package index files)"

fi

install_package "VS Code" "code"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! package_is_installed "sublime-text"; then

    add_key "https://download.sublimetext.com/sublimehq-pub.gpg" \
        || print_error "Sublime Text (add key)"

    add_to_source_list "https://download.sublimetext.com/ apt/stable/" "sublime-text.list" \
        || print_error "Sublime Text (add to package resource list)"

    update &> /dev/null \
        || print_error "Sublime Text (resync package index files)"

fi

install_package "Sublime Text" "sublime-text"

