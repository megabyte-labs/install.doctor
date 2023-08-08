---
title: Timeshift Configuration
description: Updates the Timeshift system configuration with the Timeshift configuration stored in the `home/dot_config/timeshift/timeshift.json` location.
sidebar_label: 14 Timeshift Configuration
slug: /scripts/after/run_onchange_after_14-timeshift.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_14-timeshift.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_14-timeshift.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_14-timeshift.sh.tmpl
---
# Timeshift Configuration

Updates the Timeshift system configuration with the Timeshift configuration stored in the `home/dot_config/timeshift/timeshift.json` location.

## Overview

This script applies a Timeshift configuration that defines how Timeshift should maintain system backups.



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file Timeshift Configuration
# @brief Updates the Timeshift system configuration with the Timeshift configuration stored in the `home/dot_config/timeshift/timeshift.json` location.
# @description
#     This script applies a Timeshift configuration that defines how Timeshift should maintain system backups.

# timeshift.json hash: {{ include (joinPath .chezmoi.homeDir ".config" "timeshift" "timeshift.json") | sha256sum }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

if command -v timeshift > /dev/null; then
    logg info 'Ensuring /etc/timeshift is a directory'
    sudo mkdir -p /etc/timeshift
    
    TIMESHIFT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/timeshift/timeshift.json"
    logg info "Copying $TIMESHIFT_CONFIG to /etc/timeshift/timeshift.json"
    sudo cp -f "$TIMESHIFT_CONFIG" /etc/timeshift/timeshift.json
else
    logg info 'The `timeshift` executable is not available'
fi

{{ end -}}
```
