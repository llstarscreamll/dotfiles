#!/usr/bin/env bash

set -e

source ./utils.sh

# Source installer modules
source ./installers/misc.sh
source ./installers/shell.sh
source ./installers/ide.sh
source ./installers/dev.sh
source ./installers/web.sh

# This script is the entry point for setting up a new machine based on Fedora

PROJECT_DIR=$(pwd)

main() {
    install_system_updates
    configure_udev_rules
    install_vscode
    install_sublime
    install_multimedia
    install_flatpaks
    
    cd $PROJECT_DIR
    install_vim
    install_dev_tools
    configure_vim
    create_toolbox_containers
    install_fonts
    install_cursor
    install_jetbrains_toolbox
    install_antigravity
    install_gitflow
    install_aws_vpn
    install_aws_vpn
    install_chrome
    install_obs
    configure_obs
    
    install_shell_utils
    install_mise  # Explicitly install mise (separated from shell utils)
    
    link_config_files
    install_mise_tools
    install_npm_packages
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -gt 0 ]]; then
        if declare -f "$1" > /dev/null; then
            "$@"
        else
            echo "Error: Function '$1' not found."
            echo "Usage: ./setup.sh [function_name]"
            echo
            echo "Available functions:"
            declare -F | awk '{print $3}' | grep -E '^(install_|configure_|create_|link_)' | grep -v '^install_$' | sort
            exit 1
        fi
    else
        main
    fi
fi
