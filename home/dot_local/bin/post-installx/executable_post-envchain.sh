#!/usr/bin/env bash
# @file Store Secrets in Keyring
# @brief Stores secret environment variables into the System keyring
# @description
#     This script imports secret environment variables into the System keyring if `envchain` is installed.
#     Secrets stored in the folder 'home/.chezmoitemplates/secrets' following the Install Doctor method are
#     imported into the System keyring by this script. There is only one namespace called `default` where the
#     secrets are stored. Executing `envchain default env` displays all the environment variables and their values.
#
#     ## Secrets
#
#     For more information about storing secrets like SSH keys and API keys, refer to our [Secrets documentation](https://install.doctor/docs/customization/secrets).
#
#     ## TODO
#
#     * Create seperate environments based on encrypted secret type (e.g. Allow `envchain cloudflare env` instead of `envchain default env` for everything)

set -euo pipefail

### Import environment variables into `envchain`
if command -v envchain > /dev/null; then
  if [ -f "$HOME/.config/age/chezmoi.txt" ]; then
    logg info 'Importing environment variables into the System keyring'
    while read ENCRYPTED_FILE; do
      logg info "Adding $ENCRYPTED_FILE to System keyring via envchain"
      cat "$ENCRYPTED_FILE" | chezmoi decrypt | envchain -s default "$(basename $ENCRYPTED_FILE)" > /dev/null || logg info "Importing "$(basename $ENCRYPTED_FILE)" failed"
    done< <(find "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets" -type f -maxdepth 1 -mindepth 1)
    logg success "Added Chezmoi-managed secrets into System keyring via envchain"
  else
    logg warn 'Unable to import any variables into envchain because ~/.config/age/chezmoi.txt was not created by the secrets encryption process yet'
  fi
else
  logg info 'envchain is not installed or it is not available in the PATH'
fi
