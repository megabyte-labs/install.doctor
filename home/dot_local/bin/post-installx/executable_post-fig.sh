#!/usr/bin/env bash
# @file Fig Login
# @brief Logs into Fig using the FIG_TOKEN

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v fig > /dev/null; then
    ### Ensure FIG_TOKEN
    if get-secret --exists FIG_TOKEN; then
        ### Login to Fig
        gum log -sl info "Logging into Fig with FIG_TOKEN"
        fig login --token "$(get-secret FIG_TOKEN)" || gum log -sl info 'Fig login failed - User might already be logged in'
    fi
else
    gum log -sl warn 'fig is not available in the PATH'
fi
