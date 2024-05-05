#!/usr/bin/env bash
# @file Fig Login
# @brief Logs into Fig using the FIG_TOKEN

if command -v fig > /dev/null; then
    source ~/.config/shell/private.sh
    fig login --token "$FIG_TOKEN" || logg info 'Fig login failed - User might already be logged in'
else
    logg warn 'fig is not available in the PATH'
fi
