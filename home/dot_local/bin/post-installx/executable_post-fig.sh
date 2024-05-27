#!/usr/bin/env bash
# @file Fig Login
# @brief Logs into Fig using the FIG_TOKEN

set -euo pipefail

if command -v fig > /dev/null; then
    ### Ensure FIG_TOKEN
    get-secret --exists FIG_TOKEN

    ### Login to Fig
    fig login --token "$(get-secret FIG_TOKEN)" || logg info 'Fig login failed - User might already be logged in'
else
    logg warn 'fig is not available in the PATH'
fi
