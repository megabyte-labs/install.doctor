---
title: CloudFlare SSO SSH Tunnel Setup
description: Installs and configures cloudflared for short-lived SSH certificates authenticated via SSO
sidebar_label: CloudFlare SSO SSH Tunnel Setup
slug: /scripts/utility/cloudflared-ssh.sh
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/scripts/cloudflared-ssh.sh
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/scripts/cloudflared-ssh.sh
repoLocation: scripts/cloudflared-ssh.sh
---
# CloudFlare SSO SSH Tunnel Setup

Installs and configures cloudflared for short-lived SSH certificates authenticated via SSO

## Overview

This script ensures Homebrew is installed and then uses Homebrew to ensure `cloudflared` is installed.
After that, it connects `cloudflared` to CloudFlare Teams and sets up short-lived SSH certificates so
that you do not have to manage SSH keys and instead use SSO (Single Sign-On) via CloudFlare Teams.

**Note**: `https://install.doctor/cloudflared` points to this file.

## Variables

The `SSH_DOMAIN` variable should be set to the endpoint you want to be able to SSH into. The SSH endpoint(s)
that are created depend on what type of system is being configured. Some device types include multiple
properties that need multiple unique SSH endpoints. The `SSH_DOMAIN` must be passed to this script or else
it will default to `ssh.megabyte.space`.

* For most installations, the configured domain will be `$(hostname).${SSH_DOMAIN}`
* If Qubes is being configured, then the configured domain will be `$(hostname)-qube.${SSH_DOMAIN}`
* If [EasyEngine](https://easyengine.io/) is installed, then each domain setup with EasyEngine is configured to have an `ssh` subdomain (i.e. `ssh.example.com` for `example.com`)

There are other optional variables that can be customized as well:

* `CF_TUNNEL_NAME` - The ID to assign to the tunnel that `cloudflared` creates (`default-ssh-tunnel` by default)

## Notes

Since the certificates are "short-lived", you will have to periodically re-authenticate against the
SSO authentication endpoint that is hosted by CloudFlare Teams (or an identity provider of your choosing).
This script will likely only work on AMD x64 devices.

Some of the commands are conditionally run based on whether or not the `CRONTAB_JOB` environment variable is set.
This is to accomodate EasyEngine installations where the list of SSH endpoints is variable. Both the initial
setup and updates are applied using this script (via a cronjob that does not need to run initialization tasks during
the cronjobs).

## Links

[SSH with short-lived certificates](https://developers.cloudflare.com/cloudflare-one/tutorials/ssh-cert-bastion/)



## Source Code

```
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
#     ## Links
#
#     [SSH with short-lived certificates](https://developers.cloudflare.com/cloudflare-one/tutorials/ssh-cert-bastion/)

# @description Ensure dependencies like `git` and `curl` are installed (among a few other lightweight system packages)
if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null; then
    if command -v apt-get > /dev/null; then
        # @description Ensure `build-essential`, `curl`, `expect`, `git`, and `rsync` are installed on Debian / Ubuntu
        sudo apt-get update
        sudo apt-get install -y build-essential curl expect git rsync
    elif command -v dnf > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Fedora
        sudo dnf install -y curl expect git rsync
    elif command -v yum > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on CentOS
        sudo yum install -y curl expect git rsync
    elif command -v pacman > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Archlinux
        sudo pacman update
        sudo pacman -Sy curl expect git rsync
    elif command -v zypper > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on OpenSUSE
        sudo zypper install -y curl expect git rsync
    elif command -v apk > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Alpine
        apk add curl expect git rsync
    elif [ -d /Applications ] && [ -d /Library ]; then
        # @description Ensure CLI developer tools are available on macOS (via `xcode-select`)
        sudo xcode-select -p >/dev/null 2>&1 || xcode-select --install
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Windows
        choco install -y curl expect git rsync
    fi
fi

# @description Ensure Homebrew is installed and available in the `PATH`
if ! command -v brew > /dev/null; then
    if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        if ! command -v brew > /dev/null; then
            echo "The /home/linuxbrew/.linuxbrew directory exists but something is not right. Try removing it and running the script again." && exit 1
        fi
    else
        # @description Installs Homebrew and addresses a couple potential issues
        if command -v sudo > /dev/null && sudo -n true; then
            echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
            if [ -n "$BREW_EXIT_CODE" ]; then
                if command -v brew > /dev/null; then
                    echo "Homebrew was installed but part of the installation failed. Trying a few things to fix the installation.."
                    BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
                    for BREW_DIR in $BREW_DIRS; do
                        if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
                            sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
                        fi
                    done
                    brew update --force --quiet
                fi
            fi
        fi

        # @description Ensures the `brew` binary is available on Linux machines. macOS installs `brew` into the default `PATH`
        # so nothing needs to be done for macOS.
        if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        fi
    fi
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
```
