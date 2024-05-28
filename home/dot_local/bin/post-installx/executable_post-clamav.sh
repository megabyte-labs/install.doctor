#!/usr/bin/env bash
# @file ClamAV Configuration
# @brief Applies ClamAV configuration, updates its database, and configures background services

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v freshclam > /dev/null; then
    ### Add freshclam.conf
    if [ -f "$HOME/.local/etc/clamav/freshclam.conf" ]; then
      sudo mkdir -p /usr/local/etc/clamav
      sudo cp -f "$HOME/.local/etc/clamav/freshclam.conf" /usr/local/etc/clamav/freshclam.conf
      if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav" ] && [ ! -L "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/freshclam.conf" ]; then
        sudo rm -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/freshclam.conf"
        ln -s /usr/local/etc/clamav/freshclam.conf "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/freshclam.conf"
      fi
    fi

    ### Add clamd.conf
    if [ -f "$HOME/.local/etc/clamav/clamd.conf" ]; then
      sudo mkdir -p /usr/local/etc/clamav
      sudo cp -f "$HOME/.local/etc/clamav/clamd.conf" /usr/local/etc/clamav/clamd.conf
      if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav" ] && [ ! -L "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/clamd.conf" ]; then
        sudo rm -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/clamd.conf"
        ln -s /usr/local/etc/clamav/clamd.conf "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/clamd.conf"
      fi
    fi

    ### Setting up launchd services on macOS
    if [ -d /Applications ] && [ -d /System ]; then
      ### clamav.clamdscan
      load-service clamav.clamdscan

      ### clamav.freshclam
      load-service clamav.freshclam
    fi

    ### Update database
    gum log -sl info 'Running freshclam to update database'
    freshclam
else
    gum log -sl info 'freshclam is not available in the PATH'
fi
