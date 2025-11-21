#!/usr/bin/env bash

set -e

source ./utils.sh

# This script is the entry point for setting up a new machine based on Fedora

PROJECT_DIR=$(pwd)

print "Update system packages"
flatpak update -y
dnf check-update
sudo dnf update -y

if ! command -v code &> /dev/null; then
    print "Install VSCode"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    sudo dnf install code -y
fi

if ! command -v subl &> /dev/null; then
    print "Install Sublime Text"
    curl -fsSL https://download.sublimetext.com/sublimehq-rpm-pub.gpg | sudo rpm --import -
    curl -O https://download.sublimetext.com/sublime-text-4200-1.x86_64.rpm
    sudo rpm -i --nodigest ./sublime-text-4200-1.x86_64.rpm
    rm -f sublime-text-4200-1.x86_64.rpm
fi

if ! dnf group list --installed | grep -q "Multimedia"; then
    print "Install codecs and Mesa drivers"
    sudo dnf group install multimedia -y
else
    print "Multimedia codecs already installed"
fi

print "Install Flatpaks"
if ! flatpak list | grep -q "org.telegram.desktop"; then
    flatpak install -y flathub org.telegram.desktop
else
    print "Telegram already installed"
fi
if ! flatpak list | grep -q "com.slack.Slack"; then
    flatpak install -y flathub com.slack.Slack
else
    print "Slack already installed"
fi

cd $PROJECT_DIR

if ! command -v vim &> /dev/null; then
    print "Install Vim"
    sudo dnf install -y vim
else
    print "Vim already installed"
fi

if ! command -v docker &> /dev/null; then
    print "Install Dev Tools"
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y dnf-plugins-core gcc gcc-c++ make cmake git unzip tar wget curl docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER
else
    print "Docker and dev tools already installed"
fi
# newgrp docker

print "Enable vim colors and set as default editor"
if ! grep -q "syntax on" ~/.vimrc 2>/dev/null; then
    echo "syntax on" >> ~/.vimrc
fi
if ! grep -q "set background=dark" ~/.vimrc 2>/dev/null; then
    echo "set background=dark" >> ~/.vimrc
fi

print "Create default Toolbox containers"
#toolbox create --assumeyes

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
    if [ ! -f ~/.local/share/icons/cursor.png ]; then
        curl -L -o ~/.local/share/icons/cursor.png https://paulstamatiou.com/_next/image?url=%2Fgear%2Fcursor-app-icon.png\&w=3840\&q=75
    fi
    
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
else
    print "Cursor IDE already installed"
fi

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

if ! command -v git-flow &> /dev/null; then
    print "Install GitFlow"
    export PREFIX=~/.local
    curl --silent --location  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/master/contrib/gitflow-installer.sh --output ./gitflow-installer.sh
    bash gitflow-installer.sh install stable
    rm gitflow-installer.sh
    rm -rf gitflow
else
    print "GitFlow already installed"
fi

if ! command -v awsvpnclient &> /dev/null; then
    print "Install AWS VPN Client"
    sudo dnf copr enable vorona/aws-rpm-packages -y
    sudo dnf install awsvpnclient -y
    sudo systemctl enable awsvpnclient
    sudo systemctl start awsvpnclient
else
    print "AWS VPN Client already installed"
fi

if ! command -v google-chrome &> /dev/null; then
    print "Install Google Chrome"
    sudo dnf install fedora-workstation-repositories
    sudo dnf config-manager setopt google-chrome.enabled=1
    sudo dnf install -y google-chrome-stable
else
    print "Google Chrome already installed"
fi

print "Install Shell Utils"
if ! command -v fzf &> /dev/null; then
    sudo dnf install -y fzf
else
    print "fzf already installed"
fi

if ! command -v zoxide &> /dev/null; then
    sudo dnf install -y zoxide
else
    print "zoxide already installed"
fi

if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
else
    print "mise already installed"
fi

if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin -y
else
    print "starship already installed"
fi

if ! command -v eza &> /dev/null; then
    curl -L -o eza.zip https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.zip
    unzip eza.zip -d ~/.local/bin
    rm eza.zip
else
    print "eza already installed"
fi


print "Link bash config files"
mkdir -p ~/.bashrc.d
rm -f ~/.bashrc.d/*
ln -sf $PROJECT_DIR/config/bash/00_shell ~/.bashrc.d/00_shell
ln -sf $PROJECT_DIR/config/bash/01_aliases ~/.bashrc.d/01_aliases
ln -sf $PROJECT_DIR/config/bash/02_functions ~/.bashrc.d/02_functions
ln -sf $PROJECT_DIR/config/bash/03_prompt ~/.bashrc.d/03_prompt
ln -sf $PROJECT_DIR/config/bash/04_init ~/.bashrc.d/04_init
ln -sf $PROJECT_DIR/config/bash/05_exports ~/.bashrc.d/05_exports
ln -sf $PROJECT_DIR/config/bash/06_envs ~/.bashrc.d/06_envs
ln -sf $PROJECT_DIR/config/bash/inputrc ~/.inputrc
ln -sf $PROJECT_DIR/config/git/gitconfig ~/.gitconfig
ln -sf $PROJECT_DIR/config/git/gitconfig-ubits ~/.gitconfig-ubits

if ! mise list node 2>/dev/null | grep -q "node"; then
    print "Install Node"
    mise install node@latest node@24 node@22 node@20 node@18 node@16 node@14
    mise use --global node@lts
else
    print "Node already installed via mise"
fi


print "Install global NPM packages"
for pkg in ts-node typescript eslint prettier firebase-tools aws-cdk nx @angular/cli; do
    if ! npm list -g "$pkg" &>/dev/null; then
        npm install -g "$pkg"
    else
        print "$pkg already installed"
    fi
done

if ! mise list go 2>/dev/null | grep -q "go"; then
    print "Install Golang"
    mise use --global go@latest
else
    print "Golang already installed via mise"
fi

if ! mise list aws-cli 2>/dev/null | grep -q "aws-cli"; then
    print "Install AWS CLI"
    mise install aws-cli@latest
else
    print "AWS CLI already installed via mise"
fi
