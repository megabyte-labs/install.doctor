#!/usr/bin/env bash
# @file Atuin Initialization
# @brief Registers with atuin, logs in, imports command history, and synchronizes

set -Eeuo pipefail
trap "logg error 'Script encountered an error!'" ERR

if command -v atuin > /dev/null; then
    if get-secret --exists ATUIN_USERNAME ATUIN_EMAIL ATUIN_PASSWORD ATUIN_KEY; then
        logg info 'Registering Atuin account'
        atuin register -u "$(get-secret ATUIN_USERNAME)" -e "$(get-secret ATUIN_EMAIL)" -p "$(get-secret ATUIN_PASSWORD)"
        logg info 'Logging into Atuin account'
        atuin login -u "$(get-secret ATUIN_USERNAME)" -p "$(get-secret ATUIN_PASSWORD)" -k "$(get-secret ATUIN_KEY)"
        logg info 'Running atuin import auto'
        atuin import auto
        logg info 'Running atuin sync'
        atuin sync
    fi
else
    logg info 'atuin is not available in the PATH'
fi
