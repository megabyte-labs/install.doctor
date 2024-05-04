#!/usr/bin/env bash
# @file Keybase Configuration
# @brief Updates Keybase's system configuration with the Keybase configuration stored in the `home/dot_config/keybase/config.json` location.
# @description
#     This script ensures Keybase utilizes a configuration that, by default, adds a security fix.

if command -v keybase > /dev/null; then
  KEYBASE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/keybase/config.json"
  if [ -f "$KEYBASE_CONFIG" ]; then
    logg info 'Ensuring /etc/keybase is a directory' && sudo mkdir -p /etc/keybase
    logg info "Copying $KEYBASE_CONFIG to /etc/keybase/config.json" && sudo cp -f "$KEYBASE_CONFIG" /etc/keybase/config.json
  else
    logg warn "No Keybase config located at $KEYBASE_CONFIG"
  fi
else
  logg info 'The keybase executable is not available'
fi
