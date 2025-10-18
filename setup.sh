#!/usr/bin/env bash

source ./utils.sh

# This script is the entry point for setting up a new machine based on Fedora Kinoite 42

PROJECT_DIR=$(pwd)

print "Update system packages"
flatpak update -y
dnf check-update
sudo dnf update -y

print "Install VSCode"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code -y

print "Install Sublime Text"
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf check-update
sudo dnf install sublime-text -y

print "Install codecs and Mesa drivers"
sudo dnf group install multimedia -y

print "Install Flatpaks"
flatpak install -y flathub org.telegram.desktop com.slack.Slack

cd $PROJECT_DIR

print "Install Vim"
sudo dnf install -y vim

print "Install Dev Tools"
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y dnf-plugins-core gcc gcc-c++ make cmake git unzip tar wget curl docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
newgrp docker

print "Enable vim colors and set as default editor"
echo "syntax on" >> ~/.vimrc
echo "set background=dark" >> ~/.vimrc

print "Create default Toolbox containers"
toolbox create --assumeyes

print "Checking fonts directory"
FONTS_DIR=~/.local/share/fonts
mkdir -p $FONTS_DIR

if [ -z "$(ls -A $FONTS_DIR 2>/dev/null)" ]; then
    print "Install fonts"

    curl -L -o JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
    rm -rf JetBrainsMono.zip

    curl -L -o FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
    unzip -o FiraCode.zip -d ~/.local/share/fonts/
    rm -rf FiraCode.zip

    curl -L -o FiraMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip
    unzip -o FiraMono.zip -d ~/.local/share/fonts/
    rm -rf FiraMono.zip

    curl -L -o Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
    unzip -o Hack.zip -d ~/.local/share/fonts/
    rm -rf Hack.zip

    fc-cache -f -v
fi

if [ ! -f ~/.local/bin/cursor ]; then
    print "Install Cursor IDE"

    curl -L -o Cursor.AppImage https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/linux/x64/Cursor-1.3.9-x86_64.AppImage
    chmod +x Cursor.AppImage
    mkdir -p ~/.local/bin
    mv Cursor.AppImage ~/.local/bin/cursor

    # Download an icon for Cursor
    mkdir -p ~/.local/share/icons
    curl -L -o ~/.local/share/icons/cursor.png https://paulstamatiou.com/_next/image?url=%2Fgear%2Fcursor-app-icon.png\&w=3840\&q=75

    # Create desktop entry
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/cursor.desktop << EOL
    [Desktop Entry]
    Name=Cursor IDE
    Comment=AI-powered IDE for developers
    Exec="$HOME/.local/bin/cursor"
    Icon="$HOME/.local/share/icons/cursor.png"
    Terminal=false
    Type=Application
    Categories=Development;IDE;
    Keywords=cursor;code;programming;editor;
    StartupWMClass=Cursor
EOL
fi

if [ ! -f ~/.local/share/jetbrains-toolbox ]; then
    print "Install Jetbrains Toolbox"
    curl -L -o jetbrains-toolbox.tar.gz https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.7.0.48109.tar.gz
    tar -xvf jetbrains-toolbox.tar.gz -C ~/.local/share/
    mv ~/.local/share/jetbrains-toolbox-2.7.0.48109/ ~/.local/share/jetbrains-toolbox
    rm jetbrains-toolbox.tar.gz
    ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox &
fi

if [[ $XDG_CURRENT_DESKTOP == *"KDE"* ]]; then
    print "Add KDE settings"
    
    print "Konsole theme"
    git clone https://github.com/catppuccin/konsole.git theme
    mkdir -p ~/.local/share/konsole
    cp theme/themes/*.colorscheme ~/.local/share/konsole/
    rm -rf theme

    print "Add D-Bus session permissions to VS Code"
    flatpak override --user --talk-name=org.kde.kwalletd6 com.visualstudio.code
fi

print "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc

print "Install GitFlow"
export PREFIX=~/.local
curl --silent --location  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/master/contrib/gitflow-installer.sh --output ./gitflow-installer.sh
bash gitflow-installer.sh install stable
rm gitflow-installer.sh
rm -rf gitflow

print "Install AWS VPN Client"
sudo dnf copr enable vorona/aws-rpm-packages -y
sudo dnf install awsvpnclient -y
sudo systemctl enable awsvpnclient
sudo systemctl start awsvpnclient

print "Install Google Chrome"
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install -y google-chrome-stable

print "Install Shell Utils"
sudo dnf install -y fzf zoxide
curl https://mise.run | sh
curl -sS https://starship.rs/install.sh | sh
curl -L -o eza.zip https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.zip
unzip eza.zip -d ~/.local/bin
rm eza.zip

print "Link bash config files"
mkdir -p ~/.bashrc.d
rm -f ~/.bashrc.d/*
ln -s $PROJECT_DIR/config/bash/00_shell ~/.bashrc.d/00_shell
ln -s $PROJECT_DIR/config/bash/01_aliases ~/.bashrc.d/01_aliases
ln -s $PROJECT_DIR/config/bash/02_functions ~/.bashrc.d/02_functions
ln -s $PROJECT_DIR/config/bash/03_prompt ~/.bashrc.d/03_prompt
ln -s $PROJECT_DIR/config/bash/04_init ~/.bashrc.d/04_init
ln -s $PROJECT_DIR/config/bash/05_exports ~/.bashrc.d/05_exports
ln -s $PROJECT_DIR/config/bash/06_envs ~/.bashrc.d/06_envs
ln -s $PROJECT_DIR/config/bash/inputrc ~/.inputrc
ln -s $PROJECT_DIR/config/git/gitconfig ~/.gitconfig
ln -s $PROJECT_DIR/config/git/gitconfig-ubits ~/.gitconfig-ubits

print "Install Node"
mise install node@latest node@24 node@22 node@20 node@18 node@16 node@14
mise use --global node@lts

print "Install global NPM packages"
npm install -g ts-node typescript eslint prettier firebase-tools aws-cdk nx @angular/cli

print "Install Golang"
mise use --global go@latest

print "Install AWS CLI"
mise install aws-cli@latest
