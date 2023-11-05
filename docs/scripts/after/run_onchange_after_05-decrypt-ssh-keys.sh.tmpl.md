---
title: Decrypt SSH Keys
description: Decrypts the encrypted SSH key files stored in the `home/.chezmoitemplates/ssh` folder of the repository / fork
sidebar_label: 05 Decrypt SSH Keys
slug: /scripts/after/run_onchange_after_05-decrypt-ssh-keys.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_05-decrypt-ssh-keys.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_05-decrypt-ssh-keys.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_05-decrypt-ssh-keys.sh.tmpl
---
# Decrypt SSH Keys

Decrypts the encrypted SSH key files stored in the `home/.chezmoitemplates/ssh` folder of the repository / fork

## Overview

This script decrypts the SSH key files that are housed in the `home/.chezmoitemplates/ssh` section of the repository.
It loops through all the files in `home/.chezmoitemplates/ssh` and stores them to the `~/.ssh` folder
when they are successfully decrypted.

## Secrets

For more information about storing secrets like SSH keys and API keys, refer to our [Secrets documentation](https://install.doctor/docs/customization/secrets).



## Source Code

```
{{- if (stat (joinPath .host.home ".config" "age" "chezmoi.txt")) -}}
#!/usr/bin/env bash
# @file Decrypt SSH Keys
# @brief Decrypts the encrypted SSH key files stored in the `home/.chezmoitemplates/ssh` folder of the repository / fork
# @description
#     This script decrypts the SSH key files that are housed in the `home/.chezmoitemplates/ssh` section of the repository.
#     It loops through all the files in `home/.chezmoitemplates/ssh` and stores them to the `~/.ssh` folder
#     when they are successfully decrypted.
#
#     ## Secrets
#
#     For more information about storing secrets like SSH keys and API keys, refer to our [Secrets documentation](https://install.doctor/docs/customization/secrets).

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

logg info 'Decrypting SSH keys stored in the home/.chezmoitemplates/ssh folder of the Install Doctor repo / fork.'
find "{{ .chezmoi.sourceDir }}/.chezmoitemplates/ssh" -type f | while read SSH_FILE; do
    ### Decrypt SSH file with Chezmoi
    logg info 'Decrypting the $(basename "$SSH_FILE") encrypted SSH file'
    chezmoi decrypt "$SSH_FILE" > "$HOME/.ssh/$(basename "$SSH_FILE")" || EXIT_CODE=$?

    ### Handle failed decryption with warning log message
    if [ -n "$EXIT_CODE" ]; then
        logg warn "Unable to decrypt the file stored in $SSH_FILE"
    fi

    ### Apply appropriate permission to decrypted ~/.ssh file
    if [ -f "$HOME/.ssh/$(basename "$SSH_FILE")" ]; then
        logg info "Applying appropriate permissions on $HOME/.ssh/$(basename "$SSH_FILE")"
        chmod 600 "$HOME/.ssh/$(basename "$SSH_FILE")"
    fi
done

{{ end -}}
```
