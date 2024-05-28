#!/usr/bin/env bash
# @file Timeshift Configuration
# @brief Updates the Timeshift system configuration with the Timeshift configuration stored in the `home/dot_config/timeshift/timeshift.json` location.
# @description
#     This script applies a Timeshift configuration that defines how Timeshift should maintain system backups.

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v timeshift > /dev/null; then
  gum log -sl info 'Ensuring /etc/timeshift is a directory'
  sudo mkdir -p /etc/timeshift
  TIMESHIFT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/timeshift/timeshift.json"
  gum log -sl info "Copying $TIMESHIFT_CONFIG to /etc/timeshift/timeshift.json"
  sudo cp -f "$TIMESHIFT_CONFIG" /etc/timeshift/timeshift.json
else
  gum log -sl info 'The timeshift executable is not available'
fi
