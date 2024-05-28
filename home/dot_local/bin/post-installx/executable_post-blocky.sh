#!/usr/bin/env bash
# @file Blocky Configuration
# @brief Copies over configuration (and service file, in the case of Linux) to the appropriate system location

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v blocky > /dev/null; then
    if [ -d /Applications ] && [ -d /System ]; then
        ### macOS
        if [ -f "$HOME/.local/etc/blocky/config.yaml" ]; then
            gum log -sl info 'Ensuring /usr/local/etc/blocky directory is present'
            sudo mkdir -p /usr/local/etc/blocky
            gum log -sl info "Copying $HOME/.local/etc/blocky/config.yaml to /usr/local/etc/blocky/config.yaml"
            sudo cp -f "$HOME/.local/etc/blocky/config.yaml" /usr/local/etc/blocky/config.yaml
            if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/blocky" ] && [ ! -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/blocky/config.yaml" ]; then
                gum log -sl info "Symlinking $HOME/.local/etc/blocky/config.yaml to ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/blocky/config.yaml"
                ln -s /usr/local/etc/blocky/config.yaml "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/blocky/config.yaml"
            fi
        fi
    else
        ### Linux
        gum log -sl info 'Ensuring /usr/local/etc/blocky is created'
        sudo mkdir -p /usr/local/etc/blocky
        sudo cp -f "$HOME/.local/etc/blocky/config.yaml" /usr/local/etc/blocky/config.yaml
        if [ -d /usr/lib/systemd/system ]; then
            gum log -sl info 'Copying blocky service file to system locations'
            sudo cp -f "$HOME/.local/etc/blocky/blocky.service" /usr/lib/systemd/system/blocky.service
        else
            logg "/usr/lib/systemd/system is missing from the file system"
        fi
    fi
else
    gum log -sl info 'Blocky is not available in the PATH'
fi
