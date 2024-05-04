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

### Import environment variables into `envchain`
if command -v envchain > /dev/null; then
  if [ -f "$HOME/.config/age/chezmoi.txt" ]; then
    logg info 'Importing environment variables into the System keyring'
    for file in {{ joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "*" }}; do
      cat "$file" | chezmoi decrypt | envchain -s default "$(basename $file)" > /dev/null || logg info 'Importing "$(basename $file)" failed'
    done
  else
    logg warn 'Unable to import any variables into envchain because ~/.config/age/chezmoi.txt was not created by the secrets encryption process yet'
  fi
else
  logg info 'envchain is not installed or it is not available in the PATH'
fi