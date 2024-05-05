#!/usr/bin/env bash
# @file Blocky Configuration
# @brief Copies over configuration (and service file, in the case of Linux) to the appropriate system location

if command -v blocky > /dev/null; then
    if [ -d /Applications ] && [ -d /System ]; then
        ### macOS
        cp -f "$HOME/.local/etc/blocky/config.yaml" "$(brew --prefix)/etc/blocky/config.yaml"
    else
        ### Linux
        sudo mkdir -p /usr/local/etc/blocky
        if [ -d /usr/lib/systemd/system ]; then
            sudo cp -f "$HOME/.local/etc/blocky/config.yaml" /usr/local/etc/blocky/config.yaml
            sudo cp -f "$HOME/.local/etc/blocky/blocky.service" /usr/lib/systemd/system/blocky.service
        else
            logg "/usr/lib/systemd/system is missing from the file system"
        fi
    fi
else
    logg info 'Blocky is not available in the PATH'
fi
