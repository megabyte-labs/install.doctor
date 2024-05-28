#!/usr/bin/env bash
# @file sftpgo configuration
# @brief This script copies over the required configuration files for sftpgo and then initializes sftpgo

set -Eeuo pipefail
trap "logg error 'Script encountered an error!'" ERR

if command -v sftpgo > /dev/null; then
    ### Copy configuration file
    sudo mkdir -p /usr/local/etc/sftpgo
    logg info 'Copying over sftpgo configuration to /usr/local/etc/sftpgo/sftpgo.json'
    sudo cp -f "$HOME/.local/etc/sftpgo/sftpgo.json" /usr/local/etc/sftpgo/sftpgo.json

    ### Copy branding assets / banner
    logg info 'Copying over sftpgo branding assets'
    sudo cp -f "$HOME/.local/etc/sftpgo/banner" /usr/local/etc/sftpgo/banner
    sudo mkdir -p /usr/local/etc/branding
    sudo cp -f "$HOME/.local/etc/branding/favicon.ico" /usr/local/etc/branding/favicon.ico
    sudo cp -f "$HOME/.local/etc/branding/logo-color-256x256.png" /usr/local/etc/branding/logo-color-256x256.png
    sudo cp -f "$HOME/.local/etc/branding/logo-color-900x900.png" /usr/local/etc/branding/logo-color-900x900.png

    ### Initialize
    logg info 'Running sudo sftpgo initprovider'
    sudo sftpgo initprovider
else
    logg info 'sftpgo is not installed'
fi
