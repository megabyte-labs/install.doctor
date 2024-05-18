#!/usr/bin/env bash
# @file Cloudflared Configuration
# @brief Applies cloudflared configuration, connects to Argo tunnel with managed configuration, and enables it on system start
# @description
#     1. Skips the deletion of a tunnel when it is currently in use

if command -v cloudflared > /dev/null; then
  # Show warning message about ~/.cloudflared already existing
  if [ -d "$HOME/.cloudflared" ]; then
    logg warn '~/.cloudflared is already in the home directory - to ensure proper deployment, remove previous tunnel configuration folders'
  fi

  # Copy over configuration files
  logg info 'Ensuring /usr/local/etc/cloudflared exists' && sudo mkdir -p /usr/local/etc/cloudflared
  logg info 'Copying over configuration files from ~/.local/etc/cloudflared to /usr/local/etc/cloudflared'
  sudo cp -f "$HOME/.local/etc/cloudflared/cert.pem" /usr/local/etc/cloudflared/cert.pem
  sudo cp -f "$HOME/.local/etc/cloudflared/config.yml" /usr/local/etc/cloudflared/config.yml

  ### Remove previous tunnels connected to host
  while read TUNNEL_ID; do
    logg info "Deleteing CloudFlared tunnel ID $TUNNEL_ID"
    unset TUNNEL_EXIT_CODE
    sudo cloudflared tunnel delete "$TUNNEL_ID" || TUNNEL_EXIT_CODE=$?
    if [ -z "$TUNNEL_EXIT_CODE" ]; then
      logg info "Removing credentials for $TUNNEL_ID which is not in use"
      sudo rm -f "/usr/local/etc/cloudflared/${TUNNEL_ID}.json"
    else
      logg success "Skipping deletion of $TUNNEL_ID credentials since it is in use"
    fi
  done< <(sudo cloudflared tunnel list | grep "host-$(hostname -s)" | sed 's/ .*//')

  ### Register tunnel (if not already registered)
  logg info "Creating CloudFlared tunnel named host-$(hostname -s)"
  sudo cloudflared tunnel create "host-$(hostname -s)"

  ### Acquire TUNNEL_ID and symlink credentials.json
  TUNNEL_ID="$(sudo cloudflared tunnel list | grep "host-$(hostname -s)" | sed 's/ .*//')"
  logg info "Tunnel ID: $TUNNEL_ID"
  logg info "Symlinking /usr/local/etc/cloudflared/$TUNNEL_ID.json to /usr/local/etc/cloudflared/credentials.json"
  sudo rm -f /usr/local/etc/cloudflared/credentials.json
  sudo ln -s /usr/local/etc/cloudflared/$TUNNEL_ID.json /usr/local/etc/cloudflared/credentials.json

  ### Symlink /usr/local/etc/cloudflared to /etc/cloudflared
  if [ ! -d /etc/cloudflared ]; then
    logg info 'Symlinking /usr/local/etc/cloudflared to /etc/cloudflared'
    sudo ln -s /usr/local/etc/cloudflared /etc/cloudflared
  else
    if [ ! -L /etc/cloudflared ]; then
      logg info '/etc/cloudflared is present (and not symlinked) but files are being modified in /usr/local/etc/cloudflared'
    fi
  fi

  ### Configure DNS
  # Must be deleted manually if no longer used
  logg info 'Setting up DNS records for CloudFlare Argo tunnels'
  while read DOMAIN; do
    logg info "Setting up $DOMAIN for access through cloudflared"
    sudo cloudflared tunnel route dns -f "$TUNNEL_ID" "$DOMAIN" && logg success "Successfully routed $DOMAIN to this machine's cloudflared Argo tunnel"
  done< <(yq '.ingress[].hostname' config.yml)

  ### Set up service
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    if [ -f /Library/LaunchDaemons/com.cloudflare.cloudflared.plist ]; then
      logg info 'cloudflared service is already installed'
    else
      logg info 'Running sudo cloudflared service install'
      sudo cloudflared service install
    fi
    sudo cp -f "$HOME/Library/LaunchDaemons/com.cloudflare.cloudflared.plist" /Library/LaunchDaemons/com.cloudflare.cloudflared.plist
    logg info 'Ensuring cloudflared service is started'
    if sudo launchctl list | grep 'com.cloudflare.cloudflared' > /dev/null; then
      logg info 'Unloading previous com.cloudflare.cloudflared configuration'
      sudo launchctl unload /Library/LaunchDaemons/com.cloudflare.cloudflared.plist
    fi
    sudo launchctl load -w /Library/LaunchDaemons/com.cloudflare.cloudflared.plist
  elif [ -f /etc/os-release ]; then
    ### Linux
    if systemctl --all --type service | grep -q "cloudflared" > /dev/null; then
      logg info 'cloudflared service is already available as a service'
    else
      logg info 'Running sudo cloudflared service install'
      sudo cloudflared service install
    fi
    logg info 'Ensuring cloudflared service is started'
    sudo systemctl start cloudflared
    logg info 'Enabling cloudflared as a boot systemctl service'
    sudo systemctl enable cloudflared
  else
    # System is Windows
    cloudflared service install
    mkdir C:\Windows\System32\config\systemprofile\.cloudflared
    # Copy same cert.pem as being used above
    # copy C:\Users\%USERNAME%\.cloudflared\cert.pem C:\Windows\System32\config\systemprofile\.cloudflared\cert.pem
    # https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/local/as-a-service/windows/
  fi
else
  logg info 'cloudflared was not installed so CloudFlare Tunnels cannot be enabled'
fi
