#!/usr/bin/env bash
# @file Volta initialization
# @brief This script initializes Volta and ensures the latest version of node and yarn are installed

set -euo pipefail

export VOLTA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/volta"
export PATH="$VOLTA_HOME/bin:$PATH"

### Disconnect from CloudFlare WARP (if connected)
if command -v warp-cli > /dev/null; then
  warp-cli disconnect && logg info 'CloudFlare WARP temporarily disconnected while Volta installs Node / Yarn'
fi

### Configure Volta if it is installed
if command -v volta > /dev/null; then
    logg info 'Running volta setup'
    volta setup
    logg info 'Installing latest version of Node.js via Volta'
    volta install node@latest
    logg info 'Installing latest version of Yarn via Volta'
    volta install yarn@latest
else
    logg info 'Volta is not installed'
fi
