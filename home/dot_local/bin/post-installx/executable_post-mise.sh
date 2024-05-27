#!/usr/bin/env bash
# @file Mise Install / Tweaks
# @brief Performs initial install of mise targets and applies tweaks such as symlinking mise's Java version with the system Java target on macOS

set -euo pipefail

if command -v mise > /dev/null; then
    logg info 'Running mise install' && mise install

    ### Symlink Java on macOS
    if [ -d /Applications ] && [ -d /System ]; then
        if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/java/openjdk-20/Contents" ] && [ ! -d "/Library/Java/JavaVirtualMachines/openjdk-20.jdk/Contents" ]; then
            sudo mkdir -p /Library/Java/JavaVirtualMachines/openjdk-20.jdk
            sudo ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/java/openjdk-20/Contents" /Library/Java/JavaVirtualMachines/openjdk-20.jdk/Contents
        fi
    fi
else
    logg info 'mise is not available on the PATH'
fi
