#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous Tools\n\n"

install_package "Gnome Logs" "gnome-logs"
install_package "Gnome Calulator" "gnome-calculator"
install_package "Gnome Tweak" "gnome-tweaks"
install_package "Gnome Software" "gnome-software"
install_package "Gnome System Monitor" "gnome-system-monitor"
install_package "Gnome Snap Plugin" "gnome-software-plugin-snap"
install_package "Nautilis" "nautilus"
install_package "cURL" "curl"
install_package "Xclip" "xclip"
install_package "Tilix" "tilix"
install_package "Telegram" "telegram-desktop"
execute "sudo snap install slack --classic" "Slack"
execute "sudo snap install datagrip --classic" "DataGrip"
install_package "Ubuntu Drivers" "ubuntu-drivers-common"
execute "sudo ubuntu-drivers install" "Install Drivers"
install_package "Libre Office" "libreoffice"

if [ -d "$HOME/.nvm" ]; then

    if ! package_is_installed "yarn"; then

        add_key "https://dl.yarnpkg.com/debian/pubkey.gpg" \
            || print_error "Yarn (add key)"

        add_to_source_list "https://dl.yarnpkg.com/debian/ stable main" "yarn.list" \
            || print_error "Yarn (add to package resource list)"

        update &> /dev/null \
            || print_error "Yarn (resync package index files)"

    fi

    install_package "Yarn" "yarn" "--no-install-recommends"
fi

