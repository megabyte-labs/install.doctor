---
title: Generate Missing Public SSH Keys
description: Attempts to create missing public SSH keys for all private keys that are missing a public key file
sidebar_label: 08 Generate Missing Public SSH Keys
slug: /scripts/after/run_onchange_after_08-generate-public-keys.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_08-generate-public-keys.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_08-generate-public-keys.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_08-generate-public-keys.sh.tmpl
---
# Generate Missing Public SSH Keys

Attempts to create missing public SSH keys for all private keys that are missing a public key file

## Overview

Using private SSH keys, you can generate the corresponding public key. This script ensures that any SSH private key
that does not have a matching `.pub` public key file has one generated.



## Source Code

```
#!/usr/bin/env bash
# @file Generate Missing Public SSH Keys
# @brief Attempts to create missing public SSH keys for all private keys that are missing a public key file
# @description
#     Using private SSH keys, you can generate the corresponding public key. This script ensures that any SSH private key
#     that does not have a matching `.pub` public key file has one generated.

{{ $sshFiles := (output "find" (joinPath .chezmoi.homeDir ".ssh") "-type" "f") -}}
{{- range $sshFile := splitList "\n" $sshFiles -}}
{{- if ne $sshFile "" -}}
# {{ $sshFile }} hash: {{ $sshFile | sha256sum }}
{{ end -}}
{{- end }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

logg info 'Ensuring public keys are present'

find "$HOME/.ssh" -type f -maxdepth 1 ! -name "*.pub" ! -name "authorized_keys*" ! -name "known_host*" ! -name "config" | while read FILE; do
  if [ ! -f "${FILE}.pub" ]; then
    logg info 'Generating missing public key for '"$FILE"''
    ssh-keygen -f "$FILE" -y > "${FILE}.pub"
    chmod 600 "${FILE}.pub"
  fi
done
```
