#!/usr/bin/env bash
# @file scripts/cloudflared.sh
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