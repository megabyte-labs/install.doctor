#!/usr/bin/env bash
# @file Cloudflared Configuration
# @brief Applies cloudflared configuration, connects to Argo tunnel with managed configuration, and enables it on system start

{{- $registrationToken := "" }}
{{- if and (stat (joinPath .host.home ".config" "age" "chezmoi.txt")) (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "cloudflared" .host.hostname)) -}}
{{-   $registrationToken = (includeTemplate (print "cloudflared/" .host.hostname) | decrypt) -}}
{{- end }}

### Set up CloudFlare tunnels
if command -v cloudflared > /dev/null && [ -d "$HOME/.local/etc/cloudflared" ]; then
  # Show warning message about ~/.cloudflared already existing
  if [ -d "$HOME/.cloudflared" ]; then
    logg warn '~/.cloudflared is already in the home directory - to ensure proper deployment, remove previous tunnel configuration folders'
  fi

  ### Ensure /usr/local/etc/cloudflared exists
  if [ -d /usr/local/etc/cloudflared ]; then
    logg info 'Creating folder /usr/local/etc/cloudflared'
    sudo mkdir -p /usr/local/etc/cloudflared
  fi

  # Copy over configuration files
  logg info 'Ensuring /usr/local/etc/cloudflared exists' && sudo mkdir -p /usr/local/etc/cloudflared
  logg info 'Copying over configuration files from ~/.local/etc/cloudflared to /usr/local/etc/cloudflared'
  sudo cp -f "$HOME/.local/etc/cloudflared/cert.pem" /usr/local/etc/cloudflared/cert.pem
  sudo cp -f "$HOME/.local/etc/cloudflared/config.yml" /usr/local/etc/cloudflared/config.yml

  ### Register tunnel (if not already registered)
  if sudo cloudflared tunnel list | grep "host-{{ .host.hostname }}" > /dev/null; then
    logg info 'CloudFlare tunnel is already registered'
  else
    logg info 'Creating a CloudFlare tunnel to this host'
    sudo cloudflared tunnel create "host-{{ .host.hostname }}"
  fi

  TUNNEL_ID="$(sudo cloudflared tunnel list | grep 'host-{{ .host.hostname }}' | sed 's/ .*//')"
  logg info "Tunnel ID: $TUNNEL_ID"
  if [ -f "/usr/local/etc/cloudflared/${TUNNEL_ID}.json" ]; then
    logg info 'Symlinking tunnel configuration to /usr/local/etc/cloudflared/credentials.json'
    rm -f /usr/local/etc/cloudflared/credentials.json
    sudo ln -s "/usr/local/etc/cloudflared/${TUNNEL_ID}.json" /usr/local/etc/cloudflared/credentials.json
  else
    logg info 'Handling case where the tunnel registration is not present in /usr/local/etc/cloudflared'
    {{ if eq $registrationToken "" -}}
    logg warn 'Registration token is unavailable - you might have to delete the pre-existing tunnel or set up secrets properly'
    {{- else -}}
    logg info 'Registration token retrieved from encrypted blob stored at home/.chezmoitemplates/cloudflared/{{ .host.hostname }}'
    {{ if eq (substr 0 1 $registrationToken) "{" -}}
    logg info 'Registration token stored in credential file form'
    echo -n '{{ $registrationToken }}' | sudo tee /usr/local/etc/cloudflared/credentials.json > /dev/null
    {{ else }}
    logg info 'Registration token is in token form - it will be used in conjunction with sudo cloudflared service install'
    {{- end }}
    {{- end }}
  fi

  ### Set up service
  if [ -d /Applications ] && [ -d /System ]; then
    # System is macOS
    if [ -f /Library/LaunchDaemons/com.cloudflare.cloudflared.plist ]; then
      logg info 'cloudflared service is already installed'
    else
      logg info 'Running sudo cloudflared service install'
      sudo cloudflared service install{{ if and (ne $registrationToken "") (eq (substr 0 1 $registrationToken) "{") -}} {{ $registrationToken }}{{ end }}
    fi
    logg info 'Ensuring cloudflared service is installed'
    sudo launchctl start com.cloudflare.cloudflared
  elif [ -f /etc/os-release ]; then
    # System is Linux
    if systemctl --all --type service | grep -q "cloudflared" > /dev/null; then
      logg info 'cloudflared service is already available as a service'
    else
      logg info 'Running sudo cloudflared service install'
      sudo cloudflared service install{{ if and (ne $registrationToken "") (eq (substr 0 1 $registrationToken) "{") -}} {{ $registrationToken }}{{ end }}
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
  logg info 'cloudflared was not installed so CloudFlare Tunnels cannot be enabled. (Or the ~/.local/etc/cloudflared folder is not present)'
fi
