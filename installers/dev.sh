#!/usr/bin/env bash

install_dev_tools() {
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
}

create_toolbox_containers() {
    print "Create default Toolbox containers"
    #toolbox create --assumeyes
}

install_mise() {
    if ! command -v mise &> /dev/null; then
        print "Install mise"
        curl https://mise.run | sh
    else
        print "mise already installed"
    fi
}

install_mise_tools() {
    print "Install Mise tools"
    mise install node@latest node@24 node@22 node@20 node@18 node@16 node@14
    mise install aws-cli@latest
    mise use --global node@lts
    mise use --global go@latest
}

install_npm_packages() {
    print "Install global NPM packages"
    npm install -g ts-node typescript eslint prettier firebase-tools aws-cdk @angular/cli
}

install_gitflow() {
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
}

install_aws_vpn() {
    if ! command -v awsvpnclient &> /dev/null; then
        print "Install AWS VPN Client"
        sudo dnf copr enable vorona/aws-rpm-packages -y
        sudo dnf install awsvpnclient -y
        sudo systemctl enable awsvpnclient
        sudo systemctl start awsvpnclient
    else
        print "AWS VPN Client already installed"
    fi
}
