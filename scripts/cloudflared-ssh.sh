#!/usr/bin/env bash
# @file CloudFlare SSO SSH Tunnel Setup
# @brief Installs and configures cloudflared for short-lived SSH certificates authenticated via SSO
# @description
#     This script ensures Homebrew is installed and then uses Homebrew to ensure `cloudflared` is installed.
#     After that, it connects `cloudflared` to CloudFlare Teams and sets up short-lived SSH certificates so
#     that you do not have to manage SSH keys and instead use SSO (Single Sign-On) via CloudFlare Teams.
#
#     **Note**: `https://install.doctor/cloudflared` points to this file.
#
#     ## Variables
#
#     The `SSH_DOMAIN` variable should be set to the endpoint you want to be able to SSH into. The SSH endpoint(s)
#     that are created depend on what type of system is being configured. Some device types include multiple
#     properties that need multiple unique SSH endpoints. The `SSH_DOMAIN` must be passed to this script or else
#     it will default to `ssh.megabyte.space`.
#
#     * For most installations, the configured domain will be `$(hostname).${SSH_DOMAIN}`
#     * If Qubes is being configured, then the configured domain will be `$(hostname)-qube.${SSH_DOMAIN}`
#     * If [EasyEngine](https://easyengine.io/) is installed, then each domain setup with EasyEngine is configured to have an `ssh` subdomain (i.e. `ssh.example.com` for `example.com`)
#
#     There are other optional variables that can be customized as well:
#
#     * `CF_TUNNEL_NAME` - The ID to assign to the tunnel that `cloudflared` creates (`default-ssh-tunnel` by default)
#
#     ## Notes
#
#     Since the certificates are "short-lived", you will have to periodically re-authenticate against the
#     SSO authentication endpoint that is hosted by CloudFlare Teams (or an identity provider of your choosing).
#     This script will likely only work on AMD x64 devices.
#
#     Some of the commands are conditionally run based on whether or not the `CRONTAB_JOB` environment variable is set.
#     This is to accomodate EasyEngine installations where the list of SSH endpoints is variable. Both the initial
#     setup and updates are applied using this script (via a cronjob that does not need to run initialization tasks during
#     the cronjobs).
#
#     ## TODO
#
#     * Automatically add UFW exceptions using [this script](https://github.com/Paul-Reed/cloudflare-ufw)
#
#     ## Links
#
#     [SSH with short-lived certificates](https://developers.cloudflare.com/cloudflare-one/tutorials/ssh-cert-bastion/)

# @description Logs with style using Gum if it is installed, otherwise it uses `echo`. It also leverages Glow to render markdown.
#     When Glow is not installed, it uses `cat`.
# @example
#     logger info "An informative log"
logg() {
  TYPE="$1"
  MSG="$2"
  if [ "$TYPE" == 'error' ]; then
    if command -v gum > /dev/null; then
        gum style --border="thick" "$(gum style --foreground="#ff0000" "✖") $(gum style --bold --background="#ff0000" --foreground="#ffffff"  " ERROR ") $(gum style --bold "$MSG")"
    else
        echo "ERROR: $MSG"
    fi
  elif [ "$TYPE" == 'info' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ffff" "○") $(gum style --faint "$MSG")"
    else
        echo "INFO: $MSG"
    fi
  elif [ "$TYPE" == 'md' ]; then
    if command -v glow > /dev/null; then
        glow "$MSG"
    else
        cat "$MSG"
    fi
  elif [ "$TYPE" == 'prompt' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00008b" "▶") $(gum style --bold "$MSG")"
    else
        echo "PROMPT: $MSG"
    fi
  elif [ "$TYPE" == 'star' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold "$MSG")"
    else
        echo "STAR: $MSG"
    fi
  elif [ "$TYPE" == 'start' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$MSG")"
    else
        echo "START: $MSG"
    fi
  elif [ "$TYPE" == 'success' ]; then
    if command -v gum > /dev/null; then
        gum style "$(gum style --foreground="#00ff00" "✔")  $(gum style --bold "$MSG")"
    else
        echo "SUCCESS: $MSG"
    fi
  elif [ "$TYPE" == 'warn' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold --background="#ffff00" --foreground="#000000"  " WARNING ") $(gum style --bold "$MSG")"
    else
        echo "WARNING: $MSG"
    fi
  else
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$TYPE")"
    else
        echo "$MSG"
    fi
  fi
}
# @description Ensure dependencies like `git` and `curl` are installed (among a few other lightweight system packages)
if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null || ! command -v unbuffer; then
  if command -v apt-get > /dev/null; then
    ### Debian / Ubuntu
    logg info 'Running sudo apt-get update' && sudo apt-get update
    logg info 'Running sudo apt-get install -y build-essential curl expect git rsync' && sudo apt-get install -y build-essential curl expect git rsync
  elif command -v dnf > /dev/null; then
    ### Fedora
    logg info 'Running sudo dnf install -y curl expect git rsync' && sudo dnf install -y curl expect git rsync
  elif command -v yum > /dev/null; then
    ### CentOS
    logg info 'Running sudo yum install -y curl expect git rsync' && sudo yum install -y curl expect git rsync
  elif command -v pacman > /dev/null; then
    ### Archlinux
    logg info 'Running sudo pacman update' && sudo pacman update
    logg info 'Running sudo pacman -Syu base-devel curl expect git rsync procps-ng file' && sudo pacman -Syu base-devel curl expect git rsync procps-ng file
  elif command -v zypper > /dev/null; then
    ### OpenSUSE
    logg info 'Running sudo zypper install -y curl expect git rsync' && sudo zypper install -y curl expect git rsync
  elif command -v apk > /dev/null; then
    ### Alpine
    logg info 'Running apk add curl expect git rsync' && apk add curl expect git rsync
  elif [ -d /Applications ] && [ -d /Library ]; then
    ### macOS
    logg info "Ensuring Xcode Command Line Tools are installed.."
    if ! xcode-select -p >/dev/null 2>&1; then
      logg info "Command Line Tools for Xcode not found"
      ### This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
      XCODE_PKG="$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')"
      logg info "Installing from softwareupdate" && softwareupdate -i "$XCODE_PKG" && logg success "Successfully installed $XCODE_PKG"
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    ### Windows
    logg info 'Running choco install -y curl expect git rsync' && choco install -y curl expect git rsync
  elif command -v nix-env > /dev/null; then
    ### NixOS
    logg warn "TODO - Add support for NixOS"
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    ### FreeBSD
    logg warn "TODO - Add support for FreeBSD"
  elif command -v pkg > /dev/null; then
    ### Termux
    logg warn "TODO - Add support for Termux"
  elif command -v xbps-install > /dev/null; then
    ### Void
    logg warn "TODO - Add support for Void"
  fi
fi# @description Ensure Homebrew is installed and available in the `PATH`
if ! command -v brew > /dev/null; then
  if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
    logg info "Sourcing from /home/linuxbrew/.linuxbrew/bin/brew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    if ! command -v brew > /dev/null; then
      logg error "The /home/linuxbrew/.linuxbrew directory exists but something is not right. Try removing it and running the script again." && exit 1
    fi
  else
    ### Installs Homebrew and addresses a couple potential issues
    if command -v sudo > /dev/null && sudo -n true; then
      logg info "Installing Homebrew"
      echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      logg info "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
      if [ -n "$BREW_EXIT_CODE" ]; then
        if command -v brew > /dev/null; then
          logg warn "Homebrew was installed but part of the installation failed. Trying a few things to fix the installation.."
          BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
          for BREW_DIR in $BREW_DIRS; do
            if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
              logg info "Chowning $(brew --prefix)/$BREW_DIR" && sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
            fi
          done
          logg info "Running brew update --force --quiet" && brew update --force --quiet && logg success "Successfully ran brew update --force --quiet"
        fi
      fi
    fi

    ### Ensures the `brew` binary is available on Linux machines. macOS installs `brew` into the default `PATH` so nothing needs to be done for macOS.
    if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
      logg info "Sourcing shellenv from /home/linuxbrew/.linuxbrew/bin/brew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -f /opt/homebrew/bin/brew ]; then
      logg info "Sourcing shellenv from /opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
fi

### Ensure GCC is installed via Homebrew
if command -v brew > /dev/null; then
  if ! brew list | grep gcc > /dev/null; then
    logg info "Installing Homebrew gcc" && brew install gcc
  fi
else
  logg error "Failed to initialize Homebrew" && exit 2
fi
# @description Ensures `cloudflared` is installed via Homebrew
if ! command -v cloudflared > /dev/null; then
    brew install cloudflared
fi

# @description Detect the SSH port being used
SSH_PORT="22"
if sudo cat /etc/ssh/sshd_config | grep '^Port ' > /dev/null; then
  SSH_PORT="$(sudo cat /etc/ssh/sshd_config | grep '^Port ' | sed 's/Port //')"
fi

# @description Login to the CloudFlare network (if running outside a cronjob) and acquire the tunnel ID
if [ -z "$CRONTAB_JOB" ]; then
    sudo cloudflared tunnel login
    sudo cloudflared tunnel create "${CF_TUNNEL_NAME:=default-ssh-tunnel}"
fi
TUNNEL_ID="$(sudo cloudflared tunnel list | grep " ${CF_TUNNEL_NAME} " | sed 's/^\([^ ]*\).*$/\1/')"

# @description Ensure CloudFlare tunnel ID was acquired, then add tunnel route, and create
# tunnel configuration based on what type of machine is being configured (i.e. regular, Qubes, or EasyEngine)
if [ -n "$TUNNEL_ID" ]; then
  if [ -z "$CRONTAB_JOB" ]; then
    sudo cloudflared tunnel route ip add 100.64.0.0/10 "${TUNNEL_ID}"
  fi

  # @description Create the `/root/.cloudflared/config.yml`
  CONFIG_TMP="$(mktemp)"
  echo "tunnel: ${TUNNEL_ID}" > "$CONFIG_TMP"
  echo "credentials-file: /root/.cloudflared/${TUNNEL_ID}.json" >> "$CONFIG_TMP"
  echo "" >> "$CONFIG_TMP"
  echo "ingress:" >> "$CONFIG_TMP"
  if [ -d '/opt/easyengine/sites' ]; then
    DOMAINS_HOSTED="$(find /opt/easyengine/sites -maxdepth 1 -mindepth 1 -type d | sed 's/.*sites\///' | xargs)"
  else
    if [ -d /etc/qubes ]; then
      DOMAINS_HOSTED="$(hostname)-qube.${SSH_DOMAIN:-ssh.megabyte.space}"
    else
      DOMAINS_HOSTED="$(hostname).${SSH_DOMAIN:-ssh.megabyte.space}"
    fi
  fi
  for DOMAIN in $DOMAINS_HOSTED; do
    echo "  - hostname: ${DOMAIN}" >> "$CONFIG_TMP"
    echo "    service: ssh://localhost:$SSH_PORT" >> "$CONFIG_TMP"
  done
  echo "  - service: http_status:404" >> "$CONFIG_TMP"
  echo "" >> "$CONFIG_TMP"
  sudo mkdir -p /root/.cloudflared
  sudo mv "$CONFIG_TMP" /root/.cloudflared/config.yml

  # @description Install the `cloudflared` system service (if it is not a cronjob)
  if [ -z "$CRONTAB_JOB" ]; then
    sudo cloudflared service install
  fi
else
  echo "ERROR: Unable to acquire CloudFlare tunnel ID" && exit 1
fi

# @description Restart if the config file changed
if [ ! -f /root/.cloudflared/config-previous.yml ] || [ "$(cat /root/.cloudflared/config-previous.yml)" != "$(cat /root/.cloudflared/config.yml)" ]; then
  # @todo Add restart command for non-systemctl devices (i.e. macOS)
  if command -v systemctl > /dev/null; then
    sudo systemctl restart cloudflared
  fi
  sudo cp /root/.cloudflared/config.yml /root/.cloudflared/config-previous.yml
fi
