#!/usr/bin/env bash

set -e

source ./utils.sh

# Source installer modules
source ./installers/copy_config.sh
source ./installers/all.sh

# This script is the entry point for setting up a new machine based on Fedora

PROJECT_DIR=$(pwd)

main() {
    install_packages
    copy_config_files
    
    cd $PROJECT_DIR
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
