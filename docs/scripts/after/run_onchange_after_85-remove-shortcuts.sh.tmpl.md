---
title: Linux Shortcut Removal
description: Cleans up desktop shortcuts that are out of place or unwanted on Linux devices
sidebar_label: 85 Linux Shortcut Removal
slug: /scripts/after/run_onchange_after_85-remove-shortcuts.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_85-remove-shortcuts.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_85-remove-shortcuts.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_85-remove-shortcuts.sh.tmpl
---
# Linux Shortcut Removal

Cleans up desktop shortcuts that are out of place or unwanted on Linux devices

## Overview

This script loops through the `.removeLinuxShortcuts` value in `home/.chezmoidata.yaml` and removes
desktop shortcuts that have been deemed to be unnecessary or obtrusive.



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file Linux Shortcut Removal
# @brief Cleans up desktop shortcuts that are out of place or unwanted on Linux devices
# @description
#     This script loops through the `.removeLinuxShortcuts` value in `home/.chezmoidata.yaml` and removes
#     desktop shortcuts that have been deemed to be unnecessary or obtrusive.

{{ $removeShortcuts := join " " .removeLinuxShortcuts }}
# shortcuts to remove: {{ $removeShortcuts }}

### Remove unnecessary desktop shortcuts
for DESKTOP_ICON in {{ $removeShortcuts }}; do
    for SHORTCUT_FOLDER in {{ .host.home }}/.local/share/applications {{ .host.home }}/.local/share/applications/wine/Programs; do
        if [ -f "$SHORTCUT_FOLDER/$DESKTOP_ICON" ]; then
            rm -f "$SHORTCUT_FOLDER/$DESKTOP_ICON"
        fi
    done
    for SHORTCUT_FOLDER in /usr/share/applications /usr/local/share/applications /var/lib/snapd/desktop/applications; do
        if [ -f "$SHORTCUT_FOLDER/$DESKTOP_ICON" ]; then
            sudo rm -f "$SHORTCUT_FOLDER/$DESKTOP_ICON"
        fi
    done
done

{{- end -}}
```
