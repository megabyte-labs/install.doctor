#!/usr/bin/env bash
# @file Volta initialization
# @brief This script initializes Volta and ensures the latest version of node and yarn are installed

export VOLTA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if command -v volta > /dev/null; then
    volta setup
    volta install node@latest
    volta install yarn@latest
else
    logg info 'Volta is not installed'
fi
