#!/usr/bin/env bash

install_vim() {
    if ! command -v vim &> /dev/null; then
        print "Install Vim"
        sudo dnf install -y vim
    else
        print "Vim already installed"
    fi
}

configure_vim() {
    print "Enable vim colors and set as default editor"
    if ! grep -q "syntax on" ~/.vimrc 2>/dev/null; then
        echo "syntax on" >> ~/.vimrc
    fi
    if ! grep -q "set background=dark" ~/.vimrc 2>/dev/null; then
        echo "set background=dark" >> ~/.vimrc
    fi
}

install_shell_utils() {
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
}

setup_ssh_key() {
    # Post-quantum: OpenSSH 10+ uses PQ key exchange (mlkem768) by default.
    # For authentication keys, PQ signing (SLH-DSA/ML-DSA) is not in upstream yet;
    # we use Ed25519 (best available). Replace -t ed25519 with a PQ type when supported.
    local key_path=~/.ssh/id_ed25519_pq
    local key_pub="${key_path}.pub"

    print "Setup SSH key and add to agent"
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    if [[ -f "$key_path" ]]; then
        print "SSH key already exists: $key_path"
    else
        ssh-keygen -t ed25519 -f "$key_path" -N "" -C "pq-ssh-key"
        chmod 600 "$key_path"
        chmod 644 "$key_pub"
        print "Created SSH key: $key_path"
    fi

    # Ensure ssh-agent is running and add the key
    if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
        eval "$(ssh-agent -s)" >/dev/null 2>&1
    fi

    ssh-add "$key_path" 2>/dev/null || true
    print "SSH key is loaded in agent."
}

link_config_files() {
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

    source ~/.bashrc
}

