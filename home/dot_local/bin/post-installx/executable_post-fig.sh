#!/usr/bin/env bash
# @file Fig Login
# @brief Logs into Fig using the FIG_TOKEN

set -Eeuo pipefail
trap "logg error 'Script encountered an error!'" ERR

if command -v fig > /dev/null; then
    ### Ensure FIG_TOKEN
    if get-secret --exists FIG_TOKEN; then
        ### Login to Fig
        logg info "Logging into Fig with FIG_TOKEN"
        fig login --token "$(get-secret FIG_TOKEN)" || logg info 'Fig login failed - User might already be logged in'
    fi
else
    logg warn 'fig is not available in the PATH'
fi
