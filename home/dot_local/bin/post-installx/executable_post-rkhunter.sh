#!/usr/bin/env bash
# @file rkhunter configuration
# @brief This script applies the rkhunter integration and updates it as well

set -euo pipefail

if command -v rkhunter > /dev/null; then
    if [ -d /Applications ] && [ -d /System ]; then
      ### macOS
      logg info 'Updating file "$(brew --prefix)/Cellar/rkhunter/1.4.6/etc/rkhunter.conf"' && gsed -i  "s/^#WEB_CMD.*$/WEB_CMD=curl\ -L/" "$(brew --prefix)/Cellar/rkhunter/1.4.6/etc/rkhunter.conf"
      export PATH="$(echo "$PATH" | gsed 's/VMware Fusion.app/VMwareFusion.app/g')"
      export PATH="$(echo "$PATH" | gsed 's/IntelliJ IDEA CE.app/IntelliJIDEACE.app/g')"
    else
      ### Linux
      logg info 'Updating file /etc/rkhunter.conf' && sed -i  "s/^#WEB_CMD.*$/WEB_CMD=curl\ -L/" /etc/rkhunter.conf
    fi
    sudo rkhunter --propupd || RK_PROPUPD_EXIT_CODE=$?
    if [ -n "${RK_PROPUPD_EXIT_CODE-}" ]; then
      logg error "sudo rkhunter --propupd returned non-zero exit code"
    fi
    sudo rkhunter --update || RK_UPDATE_EXIT_CODE=$?
    if [ -n "${RK_UPDATE_EXIT_CODE-}" ]; then
      logg error "sudo rkhunter --update returned non-zero exit code"
    fi
else
    logg info 'rkhunter is not installed'
fi
