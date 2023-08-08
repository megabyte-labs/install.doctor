---
title: Netdata
description: Connects Netdata with Netdata's free cloud dashboard and applies some system optimizations, if necessary
sidebar_label: 57 Netdata
slug: /scripts/after/run_onchange_after_57-netdata.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_57-netdata.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_57-netdata.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_57-netdata.sh.tmpl
---
# Netdata

Connects Netdata with Netdata's free cloud dashboard and applies some system optimizations, if necessary

## Overview

This script connects Netdata with Netdata Cloud if Netdata is installed, the `NETDATA_TOKEN` is provided, and the
`NETDATA_ROOM` is defined. This allows you to graphically browse through system metrics on all your connected devices
from a single free web application.



## Source Code

```
{{- if and (ne .host.distro.family "windows") (stat (joinPath .host.home ".config" "age" "chezmoi.txt")) (or (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "NETDATA_TOKEN")) (env "NETDATA_TOKEN")) (or (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "NETDATA_ROOM")) (env "NETDATA_ROOM")) -}}
#!/usr/bin/env bash
# @file Netdata
# @brief Connects Netdata with Netdata's free cloud dashboard and applies some system optimizations, if necessary
# @description
#     This script connects Netdata with Netdata Cloud if Netdata is installed, the `NETDATA_TOKEN` is provided, and the
#     `NETDATA_ROOM` is defined. This allows you to graphically browse through system metrics on all your connected devices
#     from a single free web application.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Claim the instance with Netdata Cloud
if command -v netdata-claim.sh > /dev/null; then
    NETDATA_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "NETDATA_TOKEN")) }}{{ includeTemplate "secrets/NETDATA_TOKEN" | decrypt }}{{ else }}{{ env "NETDATA_TOKEN" }}{{ end }}"
    NETDATA_ROOM="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "NETDATA_ROOM")) }}{{ includeTemplate "secrets/NETDATA_ROOM" | decrypt }}{{ else }}{{ env "NETDATA_ROOM" }}{{ end }}"
    # netdata-claim.sh must be run as netdata user
    sudo -H -u netdata bash -c 'netdata-claim.sh -token="$NETDATA_TOKEN" -rooms="$NETDATA_ROOM" -url="{{ .netdataClaimURL }}"'

    # Kernel optimizations
    # These are mentioned while installing via the kickstart.sh script method. We are using Homebrew for the installation though.
    # Assuming these optimizations do not cause any harm.
    if [ -d /Applications ] && [ -d /System ]; then
        # macOS
        logg info 'System is macOS so Netdata kernel optimizations are not required'
    else
        # Linux
        if [ -d /sys/kernel/mm/ksm ]; then
            logg info 'Adding Netdata kernel optimization for `/sys/kernel/mm/ksm/run`'
            echo 1 | sudo tee /sys/kernel/mm/ksm/run
            logg info 'Adding Netdata kernel optimization for `/sys/kernel/mm/ksm/sleep_millisecs`'
            echo 1000 | sudo tee /sys/kernel/mm/ksm/sleep_millisecs
        else
            logg info 'The `/sys/kernel/mm/ksm` directory does not exist so Netdata kernel optimizations are not being applied'
        fi
    fi
else
    logg warn '`netdata-claim.sh` is not available in the PATH'
fi

{{ end -}}
```
