#!/usr/bin/env bash
# @file Tailscale
# @brief Connects the Tailscale client with the Tailscale network
# @description
#     This script ensures the `tailscaled` system daemon is installed on macOS. Then, on both macOS and Linux, it connects to the Tailscale
#     network if the `TAILSCALE_AUTH_KEY` variable is provided.

### Install the Tailscale system daemon
if [ -d /Applications ] && [ -d System ]; then
  ### macOS
  if command -v tailscaled > /dev/null; then
    logg info 'Ensuring tailscaled system daemon is installed'
    sudo tailscaled install-system-daemon
    logg info 'tailscaled system daemon is now installed and will load on boot'
  else
    logg info 'tailscaled does not appear to be installed'
  fi
fi

### Connect to Tailscale network
if command -v tailscale > /dev/null && [ "$TAILSCALE_AUTH_KEY" != "" ]; then
  logg info 'Connecting to Tailscale with user-defined authentication key'
  timeout 14 tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes || EXIT_CODE=$?
  if [ -n "$EXIT_CODE" ]; then
    logg warn 'tailscale up timed out'
  else
    logg success 'Connected to Tailscale network'
  fi
fi