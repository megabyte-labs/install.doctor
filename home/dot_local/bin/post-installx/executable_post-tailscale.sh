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

  ### Open Tailscale.app
  if [ -d /Applications/Tailscale.app ]; then
    logg info 'Opening Tailscale.app menu bar widget' && open -a Tailscale
  else
    logg info '/Applications/Tailscale.app is missing from the system'
  fi
fi

### Connect to Tailscale network
if [ -n "$TAILSCALE_AUTH_KEY" ] && [ "$TAILSCALE_AUTH_KEY" != "" ]; then
  if [ -f /Applications/Tailscale.app/Contents/MacOS/Tailscale ]; then
    logg info 'Connecting to Tailscale with user-defined authentication key (TAILSCALE_AUTH_KEY)'
    timeout 30 /Applications/Tailscale.app/Contents/MacOS/Tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes || EXIT_CODE=$?
    if [ -n "$EXIT_CODE" ]; then
      logg warn '/Applications/Tailscale.app/Contents/MacOS/Tailscale timed out'
    fi
  elif command -v tailscale > /dev/null && [ "$TAILSCALE_AUTH_KEY" != "" ]; then
    logg info 'Connecting to Tailscale with user-defined authentication key (TAILSCALE_AUTH_KEY)'
    timeout 30 tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes || EXIT_CODE=$?
    if [ -n "$EXIT_CODE" ]; then
      logg warn 'tailscale up timed out'
    else
      logg success 'Connected to Tailscale network'
    fi
  else
    logg info 'tailscale does not appear to be installed'
  fi
else
  logg info 'TAILSCALE_AUTH_KEY is not defined so not logging into Tailscale network'
fi
