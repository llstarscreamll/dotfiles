#!/usr/bin/env bash

setup_packages_sources() {
    print "Setup package sources"
    
    sudo dnf copr enable vorona/aws-rpm-packages -y
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo cp ./config/third-party.repo /etc/yum.repos.d/
}

update_system() {
    print "Update system packages"

    sudo dnf upgrade --refresh -y
}

update_flatpaks() {
    print "Update flatpaks"

    flatpak update -y
}

install_cursor() {
    if command -v cursor &> /dev/null; then
        return
    fi

    curl -L -o cursor.rpm https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/2.5
    sudo dnf install -y cursor.rpm
    sudo dnf update -y
    rm cursor.rpm
}

install_sublime() {
    if command -v subl &> /dev/null; then
        return
    fi

    curl -fsSL https://download.sublimetext.com/sublimehq-rpm-pub.gpg | sudo rpm --import -
    curl -O https://download.sublimetext.com/sublime-text-4200-1.x86_64.rpm
    sudo dnf install -y sublime-text-4200-1.x86_64.rpm
    rm -f sublime-text-4200-1.x86_64.rpm
}

install_jetbrains_toolbox() {
    if [ -f ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox ]; then
        return
    fi

    curl -L -o jetbrains-toolbox.tar.gz https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.7.0.48109.tar.gz
    tar -xvf jetbrains-toolbox.tar.gz -C ~/.local/share/
    if [ -d ~/.local/share/jetbrains-toolbox ]; then
        rm -rf ~/.local/share/jetbrains-toolbox
    fi

    mv ~/.local/share/jetbrains-toolbox-2.7.0.48109/ ~/.local/share/jetbrains-toolbox
    rm jetbrains-toolbox.tar.gz
    ~/.local/share/jetbrains-toolbox/bin/jetbrains-toolbox &
}

install_gitflow() {
    if command -v git-flow &> /dev/null; then
        return
    fi
    
    export PREFIX=~/.local
    curl --silent --location  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/master/contrib/gitflow-installer.sh --output ./gitflow-installer.sh
    bash gitflow-installer.sh install stable
    rm gitflow-installer.sh
    rm -rf gitflow
}

install_fonts() {
    FONTS_DIR=~/.local/share/fonts
    mkdir -p $FONTS_DIR

    if [ -n "$(ls -A $FONTS_DIR 2>/dev/null)" ]; then
        return
    fi
    
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
}

install_toolbox_containers() {
    print "Install toolbox containers"

    toolbox create --assumeyes >> /dev/null 2>&1
}

setup_ssh_key() {
    # Post-quantum: OpenSSH 10+ uses PQ key exchange (mlkem768) by default.
    # For authentication keys, PQ signing (SLH-DSA/ML-DSA) is not in upstream yet;
    # we use Ed25519 (best available). Replace -t ed25519 with a PQ type when supported.
    local key_path=~/.ssh/id_ed25519_pq
    local key_pub="${key_path}.pub"

    print "Setup SSH key"
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
    
    print "SSH key loaded to agent."
}

setup_mise() {
    print "Setup mise"

    if [ ! -f "$HOME/.local/bin/mise" ]; then
        curl https://mise.run | sh
    fi

    eval "$(mise activate bash)"

    mise install node@latest node@24 node@22 node@20 node@18 node@16 node@14
    mise use --global aws-cli@latest node@lts go@latest zoxide@latest fzf@latest rust@latest cargo:starship eza@latest
    npm install -g ts-node typescript eslint prettier firebase-tools aws-cdk @angular/cli
}

install_dnf_packages() {
    print "Install dnf packages"

    sudo dnf makecache

    sudo dnf group install multimedia -y

    sudo dnf install -y \
        dnf-plugins-core bats gcc gcc-c++ make cmake git unzip tar wget curl openssl \
        sqlite-devel awsvpnclient \
        podman-compose \
        vim code antigravity

    sudo systemctl enable awsvpnclient
    sudo systemctl start awsvpnclient
}

install_flatpacks(){
    print "Setup flatpacks"

    flatpak install -y flathub \
        org.telegram.desktop \
        com.slack.Slack \
        com.obsproject.Studio \
        com.google.Chrome \
        com.mattjakeman.ExtensionManager

    flatpak override --user --filesystem=$HOME/.local/share/applications com.google.Chrome
    flatpak override --user --filesystem=$HOME/.local/share/icons com.google.Chrome
}

install_packages() {
    update_system
    update_flatpaks

    setup_ssh_key
    install_fonts

    install_gitflow
    setup_packages_sources
    install_cursor
    install_sublime
    install_jetbrains_toolbox

    setup_mise
    
    install_dnf_packages
    install_flatpacks

    update_system
    update_flatpaks
}
