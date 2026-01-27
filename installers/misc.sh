#!/usr/bin/env bash

install_system_updates() {
    print "Update system packages"
    flatpak update -y
    dnf check-update
    sudo dnf update -y
}

install_multimedia() {
    if ! dnf group list --installed | grep -q "Multimedia"; then
        print "Install codecs and Mesa drivers"
        sudo dnf group install multimedia -y
    else
        print "Multimedia codecs already installed"
    fi
}

install_fonts() {
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
}

configure_udev_rules() {
    print "Configure udev rules"
    
    sudo cp $PROJECT_DIR/config/udev/50-nuphy.rules /etc/udev/rules.d/
    sudo udevadm control --reload
    sudo udevadm trigger
}
