#!/usr/bin/env bash
# @file NTFY Dependencies
# @brief Ensures branding assets and sound files are in system locations. Also, ensures system dependencies are installed

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v ntfy > /dev/null; then
    ### Branding assets
    gum log -sl info 'Ensuring branding assets are in expected place for ntfy'
    sudo mkdir -p /usr/local/etc/branding
    sudo cp -f "$HOME/.local/etc/branding/logo-color-256x256.png" /usr/local/etc/branding/logo-color-256x256.png

    ### Sound files
    gum log -sl info 'Ensuring shared sound files are synced to system location'
    sudo mkdir -p /usr/local/share/sounds
    sudo rsync -rtvp "${XDG_DATA_HOME:-$HOME/.local/share}/sounds/" /usr/local/share/sounds
    
    ### Debian dependency
    if command -v apt-get > /dev/null; then
        gum log -sl info 'Running sudo apt-get update && sudo apt-get install -y python-dbus'
        sudo apt-get update && sudo apt-get install -y python-dbus
    fi

    ### Termux dependency
    if command -v termux-setup-storage > /dev/null; then
        gum log -sl info 'Running apt install -y termux-api'
        apt install -y termux-api
    fi
else
    gum log -sl info 'ntfy not available on PATH'
fi
