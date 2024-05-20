#!/usr/bin/env bash
# @file Tailscale
# @brief Connects the Tailscale client with the Tailscale network
# @description
#     This script ensures the `tailscaled` system daemon is installed on macOS. Then, on both macOS and Linux, it connects to the Tailscale
#     network if the `TAILSCALE_AUTH_KEY` variable is provided.
#
#     If CloudFlare WARP is also installed, this script will disconnect from it and then reconnect after Tailscale is connected.
#     This is a quirk and Tailscale has no roadmap for fixing it for use alongside other VPNs. To setup Tailscale to work alongside
#     CloudFlare WARP, you will have to set up a [split tunnel](https://www.youtube.com/watch?v=eDFs8hm3xWc) for
#     [Tailscale IP addresses](https://tailscale.com/kb/1105/other-vpns).

### Disconnect from CloudFlare WARP (if connected)
if command -v warp-cli > /dev/null; then
  warp-cli disconnect && logg info 'CloudFlare WARP temporarily disconnected while Tailscale connects'
fi

### Install the Tailscale system daemon
if [ -d /Applications ] && [ -d /System ]; then
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

### Acquire TAILSCALE_AUTH_KEY
TAILSCALE_KEY_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/TAILSCALE_AUTH_KEY"
if [ -f "$TAILSCALE_KEY_FILE" ]; then
  logg info "Found TAILSCALE_AUTH_KEY in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
    logg info 'Decrypting TAILSCALE_AUTH_KEY token with Age encryption key'
    TAILSCALE_AUTH_KEY="$(cat "$TAILSCALE_KEY_FILE" | chezmoi decrypt)"
  else
    logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
  fi
else
  logg warn "TAILSCALE_AUTH_KEY is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
fi

### Connect to Tailscale network
if [ -n "$TAILSCALE_AUTH_KEY" ] && [ "$TAILSCALE_AUTH_KEY" != "" ]; then
  if [ -f /Applications/Tailscale.app/Contents/MacOS/Tailscale ]; then
    logg info 'Connecting to Tailscale with user-defined authentication key (TAILSCALE_AUTH_KEY)'
    timeout 30 /Applications/Tailscale.app/Contents/MacOS/Tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes || EXIT_CODE=$?
    if [ -n "$EXIT_CODE" ]; then
      logg warn '/Applications/Tailscale.app/Contents/MacOS/Tailscale timed out'
    fi
    logg info 'Disabling update check'
    /Applications/Tailscale.app/Contents/MacOS/Tailscale set --update-check=false
  elif command -v tailscale > /dev/null && [ "$TAILSCALE_AUTH_KEY" != "" ]; then
    logg info 'Connecting to Tailscale with user-defined authentication key (TAILSCALE_AUTH_KEY)'
    timeout 30 tailscale up --authkey="$TAILSCALE_AUTH_KEY" --accept-routes || EXIT_CODE=$?
    if [ -n "$EXIT_CODE" ]; then
      logg warn 'tailscale up timed out'
    else
      logg success 'Connected to Tailscale network'
    fi
    logg info 'Disabling notifications about updates'
    tailscale set --update-check=false
    logg info 'Setting tailscale to auto-update'
    tailscale set --auto-update
  else
    logg info 'tailscale does not appear to be installed'
  fi
else
  logg info 'TAILSCALE_AUTH_KEY is not defined so not logging into Tailscale network'
fi

### Re-connect CloudFlare WARP after Tailscale is connected
if command -v warp-cli > /dev/null; then
  ### Register CloudFlare WARP
  if warp-cli --accept-tos status | grep 'Registration Missing' > /dev/null; then
    logg info 'Registering CloudFlare WARP'
    warp-cli --accept-tos registration new
  else
    logg info 'Either there is a misconfiguration or the device is already registered with CloudFlare WARP'
  fi

  ### Connect CloudFlare WARP
  if warp-cli --accept-tos status | grep 'Disconnected' > /dev/null; then
    logg info 'Connecting to CloudFlare WARP'
    warp-cli --accept-tos connect > /dev/null && logg success 'Connected to CloudFlare WARP'
  else
    logg info 'Either there is a misconfiguration or the device is already connected with CloudFlare WARP'
  fi
fi