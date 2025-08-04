#!/usr/bin/env bash

source ./utils.sh

# This script is the entry point for setting up a new machine based on Fedora Kinoite 42

PROJECT_DIR=$(pwd)

print "Update system packages"
sudo rpm-ostree upgrade --reboot

print "Install Flatpaks"
flatpak install -y flathub com.visualstudio.code \
    org.telegram.desktop \
    com.google.Chrome \
    com.slack.Slack

print "Add permissions to Chrome Flatpak"
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome

print "Add D-Bus session permissions to VS Code"
flatpak override --user --talk-name=org.kde.kwalletd6 com.visualstudio.code

print "Make code command available on configure it to use Toolbox"
mkdir -p ~/Code
cd ~/Code
git clone https://github.com/owtaylor/toolbox-vscode.git
cd toolbox-vscode
[ -d ~/.local/bin ] || mkdir ~/.local/bin
ln -s "$PWD/code.sh" ~/.local/bin/code

cd $PROJECT_DIR

print "Copy bash config files"
mkdir -p ~/.bashrc.d
cp -r config/bash/* ~/.bashrc.d/

print "Create default Toolbox containers"
toolbox create johan --assumeyes

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

if [ ! -f ~/.ssh/johan.pub ]; then
    print "Generate SSH key"
    ssh-keygen -C "llstarscreamll@hotmail.com" -f ~/.ssh/johan -N ""
    ssh-add ~/.ssh/johan

    print "Add the following public key to your GitHub account:"
    cat ~/.ssh/johan.pub
fi

if [ ! -f ~/.local/share/jetbrains-toolbox ]; then
    print "Install Jetbrains Toolbox"
    curl -L -o jetbrains-toolbox.tar.gz https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.7.0.48109.tar.gz
    tar -xvf jetbrains-toolbox.tar.gz -C ~/.local/share/
    mv ~/.local/share/jetbrains-toolbox-2.7.0.48109/ ~/.local/share/jetbrains-toolbox
    rm jetbrains-toolbox.tar.gz
    ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox
fi
