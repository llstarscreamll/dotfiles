#!/usr/bin/env bash

install_flatpaks() {
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
}

install_chrome() {
    if ! command -v google-chrome &> /dev/null; then
        print "Install Google Chrome"
        sudo dnf install fedora-workstation-repositories
        sudo dnf config-manager setopt google-chrome.enabled=1
        sudo dnf install -y google-chrome-stable
    else
        print "Google Chrome already installed"
    fi
}
