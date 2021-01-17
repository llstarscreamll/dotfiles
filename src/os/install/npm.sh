#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_npm_package() {

    execute \
        ". $HOME/.bash.local \
            && npm install --global --silent $2" \
        "$1"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   npm\n\n"

    install_npm_package "npm (update)" "npm"
    install_npm_package "Serverless" "serverless"
    install_npm_package "Firebase Tools" "firebase-tools"
    install_npm_package "Angular CLI" "@angular/cli"
    install_npm_package "NG TailwindCss" "ng-tailwindcss"

}

main
