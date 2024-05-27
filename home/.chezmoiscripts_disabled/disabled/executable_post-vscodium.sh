#!/usr/bin/env bash
# @file VSCodium Extension Pre-Installation
# @brief This script pre-installs the extensions contained in ~/.config/Code/User/extensions.json

export NODE_OPTIONS=--throw-deprecation

# @description Check for the presence of the `codium` command in the `PATH` and install extensions for VSCodium if it is present
if command -v codium > /dev/null; then
  EXTENSIONS="$(codium --list-extensions)"
  jq -r '.recommendations[]' "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/extensions.json" | while read EXTENSION; do
    if ! echo "$EXTENSIONS" | grep -iF "$EXTENSION" > /dev/null; then
      logg info 'Installing VSCodium extension '"$EXTENSION"'' && codium --install-extension "$EXTENSION" && logg success 'Installed '"$EXTENSION"''
    else
      logg info ''"$EXTENSION"' already installed'
    fi
  done
else
  logg info 'codium executable not available - skipping plugin install process for it'
fi
