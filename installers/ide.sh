#!/usr/bin/env bash

install_vscode() {
    if ! command -v code &> /dev/null; then
        print "Install VSCode"
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
        dnf check-update
        sudo dnf install code -y
    fi
}

install_sublime() {
    if ! command -v subl &> /dev/null; then
        print "Install Sublime Text"
        curl -fsSL https://download.sublimetext.com/sublimehq-rpm-pub.gpg | sudo rpm --import -
        curl -O https://download.sublimetext.com/sublime-text-4200-1.x86_64.rpm
        sudo rpm -i --nodigest ./sublime-text-4200-1.x86_64.rpm
        rm -f sublime-text-4200-1.x86_64.rpm
    fi
}

install_cursor() {
    if ! command -v cursor &> /dev/null; then
        print "Install Cursor IDE"
        curl -L -o cursor.rpm https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/2.0
        sudo rpm -i cursor.rpm
        rm cursor.rpm
    else
        print "Cursor IDE already installed"
    fi
}

install_jetbrains_toolbox() {
    if [ ! -f ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox ]; then
        print "Install Jetbrains Toolbox"
        curl -L -o jetbrains-toolbox.tar.gz https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.7.0.48109.tar.gz
        tar -xvf jetbrains-toolbox.tar.gz -C ~/.local/share/
        if [ -d ~/.local/share/jetbrains-toolbox ]; then
            rm -rf ~/.local/share/jetbrains-toolbox
        fi
        mv ~/.local/share/jetbrains-toolbox-2.7.0.48109/ ~/.local/share/jetbrains-toolbox
        rm jetbrains-toolbox.tar.gz
        ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox &
    else
        print "JetBrains Toolbox already installed"
    fi
}
