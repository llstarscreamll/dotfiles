#!/usr/bin/env bash

copy_config_files() {
    print "Udev rules"
    
    sudo cp $PROJECT_DIR/config/udev/50-nuphy.rules /etc/udev/rules.d/
    sudo udevadm control --reload
    sudo udevadm trigger

    print "Bash config"

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

    print "Vim config"

    ln -sf $PROJECT_DIR/config/vim/vimrc ~/.vimrc

    source ~/.bashrc
}
