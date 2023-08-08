---
title: Keybase Configuration
description: Updates Keybase's system configuration with the Keybase configuration stored in the `home/dot_config/keybase/config.json` location.
sidebar_label: 14 Keybase Configuration
slug: /scripts/after/run_onchange_after_14-keybase.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_14-keybase.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_14-keybase.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_14-keybase.sh.tmpl
---
# Keybase Configuration

Updates Keybase's system configuration with the Keybase configuration stored in the `home/dot_config/keybase/config.json` location.

## Overview

This script ensures Keybase utilizes a configuration that, by default, adds a security fix.



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file Keybase Configuration
# @brief Updates Keybase's system configuration with the Keybase configuration stored in the `home/dot_config/keybase/config.json` location.
# @description
#     This script ensures Keybase utilizes a configuration that, by default, adds a security fix.

# Keybase config hash: {{ include (joinPath .chezmoi.homeDir ".config" "keybase" "config.json") | sha256sum }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

if command -v keybase > /dev/null; then
    KEYBASE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/keybase/config.json"
    if [ -f "$KEYBASE_CONFIG" ]; then
        logg info 'Ensuring /etc/keybase is a directory'
        sudo mkdir -p /etc/keybase
        logg info "Copying $KEYBASE_CONFIG to /etc/keybase/config.json"
        sudo cp -f "$KEYBASE_CONFIG" /etc/keybase/config.json
    else
        logg warn "No Keybase config located at $KEYBASE_CONFIG"
    fi
else
    logg info 'The `keybase` executable is not available'
fi

{{ end -}}
```
