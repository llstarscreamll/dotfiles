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

print "Install Cursor IDE"

curl -L -o Cursor.AppImage https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/linux/x64/Cursor-1.3.9-x86_64.AppImage
chmod +x Cursor.AppImage
mv Cursor.AppImage ~/.local/bin/cursor

print "Creating Cursor desktop entry"

mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/cursor.desktop << EOL
[Desktop Entry]
Name=Cursor IDE
Comment=AI-powered IDE for developers
Exec=~/.local/bin/cursor
Icon=cursor
Terminal=false
Type=Application
Categories=Development;IDE;
Keywords=cursor;code;programming;editor;
StartupWMClass=Cursor
EOL

# Download an icon for Cursor
mkdir -p ~/.local/share/icons
curl -L -o ~/.local/share/icons/cursor.png https://paulstamatiou.com/_next/image?url=%2Fgear%2Fcursor-app-icon.png\&w=3840\&q=75

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
    ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox &
fi

print "Install Konsole Catppuccin theme"

git clone https://github.com/catppuccin/konsole.git theme
mkdir -p ~/.local/share/konsole
cp theme/themes/*.colorscheme ~/.local/share/konsole/
rm -rf theme