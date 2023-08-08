---
title: Docker Plugins
description: Ensures Docker push-rm and the Docker Rclone plugin are installed
sidebar_label: 07 Docker Plugins
slug: /scripts/after/run_onchange_after_07-docker-plugins.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_07-docker-plugins.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_07-docker-plugins.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_07-docker-plugins.sh.tmpl
---
# Docker Plugins

Ensures Docker push-rm and the Docker Rclone plugin are installed

## Overview

This script sets up two different Docker plugins.

1. [Docker push-rm](https://github.com/christian-korneck/docker-pushrm) allows you to programmatically update the README.md and other Docker registry metadata on [DockerHub](https://hub.docker.com/)
2. [Docker Rclone plugin](https://rclone.org/docker/) allows you to mount Rclone mounts as Docker volumes

## Docker Rclone

The Docker Rclone installation ensures necessary system directories are initialized / created. It also copies the [Docker Rclone configuration](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/rclone/private_docker-rclone.conf.tmpl)
to the proper system location.



## Source Code

```
{{- if (eq .host.distro.family "linux") -}}
#!/usr/bin/env bash
# @file Docker Plugins
# @brief Ensures Docker push-rm and the Docker Rclone plugin are installed
# @description
#     This script sets up two different Docker plugins.
#
#     1. [Docker push-rm](https://github.com/christian-korneck/docker-pushrm) allows you to programmatically update the README.md and other Docker registry metadata on [DockerHub](https://hub.docker.com/)
#     2. [Docker Rclone plugin](https://rclone.org/docker/) allows you to mount Rclone mounts as Docker volumes
#
#     ## Docker Rclone
#
#     The Docker Rclone installation ensures necessary system directories are initialized / created. It also copies the [Docker Rclone configuration](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/rclone/private_docker-rclone.conf.tmpl)
#     to the proper system location.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Docker push-rm
if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/docker/cli-plugins/docker-pushrm" ]; then
    logg info 'Acquiring release information for Docker push-rm'
    RELEASE_TAG="$(curl -sSL https://api.github.com/repos/christian-korneck/docker-pushrm/releases/latest | jq -r '.tag_name')"
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/docker/cli-plugins"
    logg info 'Downloading Docker push-rm'
    curl https://github.com/christian-korneck/docker-pushrm/releases/download/$RELEASE_TAG/docker-pushrm_darwin_amd64 -o "${XDG_CONFIG_HOME:-$HOME/.config}/docker/cli-plugins/docker-pushrm"
    chmod +x "${XDG_CONFIG_HOME:-$HOME/.config}/docker/cli-plugins/docker-pushrm"
    logg success 'Added Docker push-rm'
else
    logg info 'Docker push-rm already added'
fi

### Docker Rclone plugin
# Source: https://rclone.org/docker/
# First, ensure Docker Rclone configuration exists (which only happens when the Chezmoi Age decryption key is present as well as keys for Rclone)
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/docker-rclone.conf" ]; then
    ### Ensure Docker Rclone plugin system folders exist
    logg info 'Ensure Docker Rclone plugin system folders exist'
    if [ ! -d /var/lib/docker-plugins/rclone/config ]; then
        logg info 'Creating directory /var/lib/docker-plugins/rclone/config'
        sudo mkdir -p /var/lib/docker-plugins/rclone/config
    fi
    if [ ! -d /var/lib/docker-plugins/rclone/cache ]; then
        logg info 'Creating directory /var/lib/docker-plugins/rclone/cache'
        sudo mkdir -p /var/lib/docker-plugins/rclone/cache
    fi

    ### Copy Rclone configuration
    logg info "Copy the Rclone configuration from ${XDG_CONFIG_HOME:-$HOME/.config}/rclone/docker-rclone.conf to /var/lib/docker-plugins/rclone/config/rclone.conf"
    sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/docker-rclone.conf" /var/lib/docker-plugins/rclone/config/rclone.conf

    ### Install the Rclone Docker plugin (if not already installed)
    if ! sudo su -c 'docker plugin ls' - "$USER" | grep 'rclone:latest' > /dev/null; then
        sudo su -c 'docker plugin install rclone/docker-volume-rclone:amd64 args="-v" --alias rclone --grant-all-permissions' - "$USER"
    fi
fi

{{ end -}}
```
