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

install_obs() {
    print "Install OBS Studio"
    if ! flatpak list | grep -q "com.obsproject.Studio"; then
        flatpak install -y flathub com.obsproject.Studio
    else
        print "OBS Studio already installed"
    fi
}

configure_obs() {
    print "Configure OBS Studio"
    local obs_config_dir="$HOME/.var/app/com.obsproject.Studio/config/obs-studio"
    
    mkdir -p "$obs_config_dir/basic/profiles"
    mkdir -p "$obs_config_dir/basic/scenes"
    mkdir -p ~/Videos/Screencasts
    
    # helper to link file or directory
    link_item() {
        local rel_path=$1
        local src="$PROJECT_DIR/config/obs-studio/$rel_path"
        local dest="$obs_config_dir/$rel_path"
        
        # remove existing symlink or file/dir if it matches our source (to re-link) or if we want to overwrite
        # For safety, if dest is a real directory/file and not a symlink, back it up?
        # For now, simplistic approach: remove if symlink, backup if real.
        
        if [ -L "$dest" ]; then
            rm "$dest"
        elif [ -e "$dest" ]; then
             mv "$dest" "${dest}.bak"
        fi
        
        ln -s "$src" "$dest"
    }

    # Remove the parent dir link if it exists from previous run
    if [ -L "$obs_config_dir" ]; then
        rm "$obs_config_dir"
        mkdir -p "$obs_config_dir/basic/profiles"
        mkdir -p "$obs_config_dir/basic/scenes"
    fi

    link_item "global.ini"
    
    # Link Shareable profile
    # checking if profiles dir exists in repo
    if [ -d "$PROJECT_DIR/config/obs-studio/basic/profiles/Shareable" ]; then
         link_item "basic/profiles/Shareable"
    fi
    
    # Link Untitled scene collection
    if [ -f "$PROJECT_DIR/config/obs-studio/basic/scenes/Untitled.json" ]; then
         link_item "basic/scenes/Untitled.json"
    fi

    print "OBS Studio configuration linked (granular)"
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
