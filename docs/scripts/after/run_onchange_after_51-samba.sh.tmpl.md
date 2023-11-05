---
title: Samba Configuration
description: This script configures Samba by applying the configuration stored in `${XDG_DATA_HOME:-$HOME/.config}/samba/config` if the `smbd` application is available
sidebar_label: 51 Samba Configuration
slug: /scripts/after/run_onchange_after_51-samba.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_51-samba.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_51-samba.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_51-samba.sh.tmpl
---
# Samba Configuration

This script configures Samba by applying the configuration stored in `${XDG_DATA_HOME:-$HOME/.config}/samba/config` if the `smbd` application is available

## Overview

This script applies the Samba configuration stored in `${XDG_DATA_HOME:-$HOME/.config}/samba/config` if Samba is installed.
The script and default configuration set up two Samba shares.

## Security

Both shares are configured by default to only accept connections
from hosts with DNS that ends in `.local.PUBLIC_SERVICES_DOMAIN`, where `PUBLIC_SERVICES_DOMAIN` is an environment variable that
can be passed into Install Doctor. So, if your `PUBLIC_SERVICES_DOMAIN` environment variable is set to `megabyte.space`, then
a device with a FQDN of `alpha.local.megabyte.space` pointing to its LAN location will be able to connect but a device
with a FQDN of `alpha.megabyte.space` will not be able to connect.

## Samba Shares / S3 Backup

If CloudFlare R2 credentials are provided, Samba is configured to store its shared files in the Rclone mounts so that your
Samba shares are synchronized to the S3 buckets. If not, new folders are created. Either way, the folder / symlink that the
shares host data from are stored at `/mnt/share-private` and `/mnt/share-public` (*Note: Different paths are used on macOS*).

1. The **public** share (named "Public") can be accessed by anyone (including write permissions with the default settings)
2. The **private** share (named "Private") can be accessed by specifying the PAM credentials of anyone who has an account that is included in the `sambausers` group

## Symlinks

Symlinks are disabled for security reasons. This is because, with symlinking enabled, people can create symlinks on the shares and use the symlinks to access system files outside of the
Samba shares. There are commented-out lines in the default configuration that you can uncomment to enable the symlinks in shares.

## Printers

Printer sharing is not enabled by default. There are commented lines in the default configuration that should provide a nice stepping
stone if you want to use Samba for printer sharing (with CUPS).

## Environment Variables

The following chart details some of the environment variables that are used to determine the configuration of the
Samba shares:

| Environment Variable        | Description                                                                                         |
|-----------------------------|-----------------------------------------------------------------------------------------------------|
| `PUBLIC_SERVICES_DOMAIN`    | Used to determine which hosts can connect to the Samba share (e.g. `.local.PUBLIC_SERVICES_DOMAIN`) |
| `SAMBA_NETBIOS_NAME`        | Determines the NetBIOS name (defaults to the `HOSTNAME` environment variable value)                 |
| `SAMBA_WORKGROUP`           | Controls Samba workgroup name (defaults to "BETELGEUSE")                                            |

## Links

* [Default Samba configuration](https://github.com/megabyte-labs/install.doctor/tree/master/home/dot_local/samba/config.tmpl)
* [Secrets / Environment variables documentation](https://install.doctor/docs/customization/secrets)



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file Samba Configuration
# @brief This script configures Samba by applying the configuration stored in `${XDG_DATA_HOME:-$HOME/.config}/samba/config` if the `smbd` application is available
# @description
#     This script applies the Samba configuration stored in `${XDG_DATA_HOME:-$HOME/.config}/samba/config` if Samba is installed.
#     The script and default configuration set up two Samba shares.
#
#     ## Security
#
#     Both shares are configured by default to only accept connections
#     from hosts with DNS that ends in `.local.PUBLIC_SERVICES_DOMAIN`, where `PUBLIC_SERVICES_DOMAIN` is an environment variable that
#     can be passed into Install Doctor. So, if your `PUBLIC_SERVICES_DOMAIN` environment variable is set to `megabyte.space`, then
#     a device with a FQDN of `alpha.local.megabyte.space` pointing to its LAN location will be able to connect but a device
#     with a FQDN of `alpha.megabyte.space` will not be able to connect.
#
#     ## Samba Shares / S3 Backup
#
#     If CloudFlare R2 credentials are provided, Samba is configured to store its shared files in the Rclone mounts so that your
#     Samba shares are synchronized to the S3 buckets. If not, new folders are created. Either way, the folder / symlink that the
#     shares host data from are stored at `/mnt/share-private` and `/mnt/share-public` (*Note: Different paths are used on macOS*).
#
#     1. The **public** share (named "Public") can be accessed by anyone (including write permissions with the default settings)
#     2. The **private** share (named "Private") can be accessed by specifying the PAM credentials of anyone who has an account that is included in the `sambausers` group
#
#     ## Symlinks
#
#     Symlinks are disabled for security reasons. This is because, with symlinking enabled, people can create symlinks on the shares and use the symlinks to access system files outside of the
#     Samba shares. There are commented-out lines in the default configuration that you can uncomment to enable the symlinks in shares.
#
#     ## Printers
#
#     Printer sharing is not enabled by default. There are commented lines in the default configuration that should provide a nice stepping
#     stone if you want to use Samba for printer sharing (with CUPS).
#
#     ## Environment Variables
#
#     The following chart details some of the environment variables that are used to determine the configuration of the
#     Samba shares:
#
#     | Environment Variable        | Description                                                                                         |
#     |-----------------------------|-----------------------------------------------------------------------------------------------------|
#     | `PUBLIC_SERVICES_DOMAIN`    | Used to determine which hosts can connect to the Samba share (e.g. `.local.PUBLIC_SERVICES_DOMAIN`) |
#     | `SAMBA_NETBIOS_NAME`        | Determines the NetBIOS name (defaults to the `HOSTNAME` environment variable value)                 |
#     | `SAMBA_WORKGROUP`           | Controls Samba workgroup name (defaults to "BETELGEUSE")                                            |
#
#     ## Links
#
#     * [Default Samba configuration](https://github.com/megabyte-labs/install.doctor/tree/master/home/dot_local/samba/config.tmpl)
#     * [Secrets / Environment variables documentation](https://install.doctor/docs/customization/secrets)

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Configure Samba server
if command -v smbd > /dev/null; then
    ### Define share locations
    if [ -d /Applications ] && [ -d /System ]; then
        ### macOS does not have `/mnt` folder so use `/Volumes` location
        MNT_FOLDER='Volumes'
    else
        MNT_FOLDER='mnt'
    fi
    PRIVATE_CLOUD="/$MNT_FOLDER/Cloud (Private)"
    PUBLIC_CLOUD="/$MNT_FOLDER/Cloud (Public)"
    PRIVATE_SHARE="/$MNT_FOLDER/Network Share (Private)"
    PUBLIC_SHARE="/$MNT_FOLDER/Network Share (Public)"

    ### Ensure private Samba directory / symlink exists
    if [ -d "$PRIVATE_CLOUD" ] && [ ! -d "$PRIVATE_SHARE" ]; then
        sudo ln -s "$PRIVATE_CLOUD" "$PRIVATE_SHARE"
    else
        sudo mkdir -p "$PRIVATE_SHARE"
    fi

    ### Ensure public Samba directory / symlink exists
    if [ -d "$PUBLIC_CLOUD" ] && [ ! -d "$PUBLIC_SHARE" ]; then
        sudo ln -s "$PUBLIC_CLOUD" "$PUBLIC_SHARE"
    else
        sudo mkdir -p "$PUBLIC_SHARE"
    fi

    ### Copy the Samba server configuration file
    if [ -d /Applications ] && [ -d /System ]; then
        logg warn 'TODO Add logic that applies the Samba configuration for macOS'
    else
        logg info "Copying Samba server configuration to /etc/samba/smb.conf"
        sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/samba/config" "/etc/samba/smb.conf"

        ### Reload configuration file changes
        logg info 'Reloading the smbd config'
        smbcontrol smbd reload-config
    fi
else
    logg info "Samba server is not installed"
fi

{{ end -}}
```
