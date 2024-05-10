#!/usr/bin/env bash
# @file ClamAV Configuration
# @brief Applies ClamAV configuration, updates its database, and configures background services

if command -v freshclam > /dev/null; then
    ### Add freshclam.conf
    if [ -f "$HOME/.local/etc/clamav/freshclam.conf" ]; then
      sudo mkdir -p /usr/local/etc/clamav
      sudo cp -f "$HOME/.local/etc/clamav/freshclam.conf" /usr/local/etc/clamav/freshclam.conf
      if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav" ] && [ ! -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/freshclam.conf" ]; then
        ln -s /usr/local/etc/clamav/freshclam.conf "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/freshclam.conf"
      fi
    fi

    ### Add clamd.conf
    if [ -f "$HOME/.local/etc/clamav/clamd.conf" ]; then
      sudo mkdir -p /usr/local/etc/clamav
      sudo cp -f "$HOME/.local/etc/clamav/clamd.conf" /usr/local/etc/clamav/clamd.conf
      if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav" ] && [ ! -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/clamd.conf" ]; then
        ln -s /usr/local/etc/clamav/clamd.conf "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/clamav/clamd.conf"
      fi
    fi

    ### Setting up launchd services on macOS
    if [ -d /Applications ] && [ -d /System ]; then
      sudo mkdir -p /var/log/clamav
      # sudo chown $USER /var/log/clamav
      sudo cp -f "$HOME/.local/etc/clamav/clamdscan.plist" /Library/LaunchDaemons/clamdscan.plist
      sudo cp -f "$HOME/.local/etc/clamav/freshclam.plist" /Library/LaunchDaemons/freshclam.plist
      if sudo launchctl list | grep 'clamav.clamdscan' > /dev/null; then
        logg info 'Unloading previous ClamAV clamdscan configuration'
        sudo launchctl unload /Library/LaunchDaemons/clamdscan.plist
      fi
      sudo launchctl load -w /Library/LaunchDaemons/clamdscan.plist
      if sudo launchctl list | grep 'clamav.freshclam' > /dev/null; then
        logg info 'Unloading previous ClamAV freshclam configuration'
        sudo launchctl unload /Library/LaunchDaemons/freshclam.plist
      fi
      logg info 'Running sudo launchctl load -w /Library/LaunchDaemons/freshclam.plist'
      sudo launchctl load -w /Library/LaunchDaemons/freshclam.plist
    fi

    ### Update database
    freshclam
else
    logg info 'freshclam is not available in the PATH'
fi
