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
flatpak install -y flathub org.telegram.desktop \
    com.google.Chrome \
    com.slack.Slack \
    org.mozilla.Thunderbird

print "Add permissions to Chrome Flatpak"
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome

# print "Make code command available and configure it to use Toolbox"
# mkdir -p ~/Code
# cd ~/Code
# git clone https://github.com/owtaylor/toolbox-vscode.git
# cd toolbox-vscode
# [ -d ~/.local/bin ] || mkdir ~/.local/bin
# ln -s "$PWD/code.sh" ~/.local/bin/code

cd $PROJECT_DIR

print "Install Vim"
sudo dnf install -y vim

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

print "Install ZSH"
sudo dnf install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
source ~/.zshrc

print "Copy bash config files"
mkdir -p ~/.bashrc.d
cp -r config/bash/* ~/.bashrc.d/
cp config/zsh/zshrc ~/.zshrc

print "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.zshrc

print "Install Node and global packages"
nvm install 20
npm install --global nx @angular/cli firebase-tools aws-cdk ts-node prettier
nvm install 22
nvm use 22
npm install --global nx @angular/cli firebase-tools aws-cdk ts-node prettier

print "Install Golang"
curl -LO https://dl.google.com/go/go1.24.5.linux-amd64.tar.gz
mkdir -p ~/.local/bin
tar -C ~/.local/bin -xzf go1.24.5.linux-amd64.tar.gz
rm -rf go1.24.5.linux-amd64.tar.gz

print "Install GitFlow"
export PREFIX=~/.local
curl --silent --location  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/master/contrib/gitflow-installer.sh --output ./gitflow-installer.sh
bash gitflow-installer.sh install stable
rm gitflow-installer.sh
rm -rf gitflow