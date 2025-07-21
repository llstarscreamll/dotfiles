#!/usr/bin/env bash

# This script is the entry point for setting up a new machine based on Fedora Kinoite 42

PROJECT_DIR=$(pwd)

echo "\nUpdate system packages\n"
sudo rpm-ostree upgrade --reboot

echo "\nInstall Flatpaks\n"
flatpak install -y flathub com.visualstudio.code \
    org.telegram.desktop \
    com.google.Chrome

echo "\nAdd permissions to Chrome Flatpak\n"
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome

echo "\nAdd D-Bus session permissions to VS Code\n"
flatpak override --user --talk-name=org.kde.kwalletd6 com.visualstudio.code

echo "\nMake code command available on configure it to use Toolbox\n"}
mkdir -p ~/Code
cd ~/Code
git clone https://github.com/owtaylor/toolbox-vscode.git
cd toolbox-vscode
[ -d ~/.local/bin ] || mkdir ~/.local/bin
ln -s "$PWD/code.sh" ~/.local/bin/code

cd $PROJECT_DIR

echo "\nCopy bash config files\n"
mkdir -p ~/.bashrc.d
cp -r config/bash/* ~/.bashrc.d/

echo "\nCreate default Toolbox containers\n"
toolbox create johan
toolbox create ubits

echo "\nInstall fonts\n"
curl -L -o JetBrainsMono.zip https://download-cdn.jetbrains.com/fonts/JetBrainsMono-2.304.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -f -v
rm -rf JetBrainsMono.zip

if [ ! -f ~/.ssh/johan.pub ]; then
    echo "\nGenerate SSH key\n"
    ssh-keygen -C "llstarscreamll@hotmail.com" -f ~/.ssh/johan -N ""
    ssh-add ~/.ssh/johan

    echo "Add the following public key to your GitHub account:"
    cat ~/.ssh/johan.pub
fi