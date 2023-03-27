#!/usr/bin/env bash
# @file homebrew.sh
# @brief Installs Homebrew on macOS and / or Linux.
# @description
#     This script installs Homebrew on macOS and/or Linux machines. The script:
#
#     1. Ensures Homebrew is not already installed
#     2. Installs Homebrew headlessly if sudo privileges are already given
#     3. Prompts for the sudo password, if required
#     4. Performs some clean up and update tasks when the Homebrew installation reports an error
#
#     **Note**: `https://install.doctor/brew` points to this file.

if ! command -v brew > /dev/null; then
    if command -v sudo > /dev/null && sudo -n true; then
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
        if [ -n "$BREW_EXIT_CODE" ]; then
            if command -v brew > /dev/null; then
                echo "Homebrew was installed but part of the installation failed. Trying a few things to fix the installation.."
                BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
                for BREW_DIR in $BREW_DIRS; do
                    if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
                        sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
                    fi
                done
                brew update --force --quiet
            fi
        fi
    fi
fi
