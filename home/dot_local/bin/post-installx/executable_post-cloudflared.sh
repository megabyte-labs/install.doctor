#!/usr/bin/env bash
# @file Cloudflared Configuration
# @brief Applies cloudflared configuration, connects to Argo tunnel with managed configuration, and enables it on system start

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
    sudo cloudflared tunnel delete "$TUNNEL_ID"
    sudo rm -f "/usr/local/etc/cloudflared/${TUNNEL_ID}.json"
  done< <(sudo cloudflared tunnel list | grep "host-$HOSTNAME" | sed 's/ .*//')

  ### Register tunnel (if not already registered)
  logg info "Creating CloudFlared tunnel named host-$HOSTNAME"
  sudo cloudflared tunnel create "host-$HOSTNAME"

  TUNNEL_ID="$(sudo cloudflared tunnel list | grep "host-$HOSTNAME" | sed 's/ .*//')"
  logg info "Tunnel ID: $TUNNEL_ID"
  logg info "Symlinking /usr/local/etc/cloudflared/$TUNNEL_ID.json to /usr/local/etc/cloudflared/credentials.json"
  sudo rm -f /usr/local/etc/cloudflared/credentials.json
  sudo ln -s /usr/local/etc/cloudflared/$TUNNEL_ID.json /usr/local/etc/cloudflared/credentials.json

  ### Set up service
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    if [ -f /Library/LaunchDaemons/com.cloudflare.cloudflared.plist ]; then
      logg info 'cloudflared service is already installed'
    else
      logg info 'Running sudo cloudflared service install'
      sudo cloudflared service install
    fi
    logg info 'Ensuring cloudflared service is started'
    sudo launchctl start com.cloudflare.cloudflared
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
