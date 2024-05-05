#!/usr/bin/env bash
# @file sftpgo configuration
# @brief This script copies over the required configuration files for sftpgo and then initializes sftpgo

if command -v sftpgo > /dev/null; then
    sudo mkdir -p /usr/local/etc/sftpgo
    logg info 'Copying over sftpgo configuration to /usr/local/etc/sftpgo/sftpgo.json'
    sudo cp -f "$HOME/.local/etc/sftpgo/sftpgo.json" /usr/local/etc/sftpgo/sftpgo.json
    logg info 'Copying over sftpgo branding assets'
    sudo cp -f "$HOME/.local/etc/sftpgo/banner" /usr/local/etc/sftpgo/banner
    sudo mkdir -p /usr/local/etc/branding
    sudo cp -f "$HOME/.local/etc/branding/favicon.ico" /usr/local/etc/branding/favicon.ico
    sudo cp -f "$HOME/.local/etc/branding/logo-color-256x256.png" /usr/local/etc/branding/logo-color-256x256.png
    sudo cp -f "$HOME/.local/etc/branding/logo-color-900x900.png" /usr/local/etc/branding/logo-color-900x900.png
    logg info 'Running sudo sftpgo initprovider'
    sudo sftpgo initprovider
else
    logg info 'sftpgo is not installed'
fi
