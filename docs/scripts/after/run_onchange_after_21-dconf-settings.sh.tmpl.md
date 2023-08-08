---
title: DConf Settings
description: Applies repository-housed `dconf` settings.
sidebar_label: 21 DConf Settings
slug: /scripts/after/run_onchange_after_21-dconf-settings.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_21-dconf-settings.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_21-dconf-settings.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_21-dconf-settings.sh.tmpl
---
# DConf Settings

Applies repository-housed `dconf` settings.

## Overview

This script allows you to apply `dconf` settings that you can store in your fork of Install Doctor. By default,
it makes a handful of `dconf` settings optimizations.



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file DConf Settings
# @brief Applies repository-housed `dconf` settings.
# @description
#     This script allows you to apply `dconf` settings that you can store in your fork of Install Doctor. By default,
#     it makes a handful of `dconf` settings optimizations.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Update background to be OS-specific
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dconf/settings/org.gnome.desktop.background" ]; then
    logg info 'Checking for presence of /usr/local/share/wallpapers/Betelgeuse-{{ title .host.distro.id }}/contents/source.jpg'
    if [ -f /usr/local/share/wallpapers/Betelgeuse-{{ title .host.distro.id }}/contents/source.jpg ]; then
        logg info "Updating ${XDG_CONFIG_HOME:-$HOME/.config}/dconf/settings/org.gnome.desktop.background to point to OS-specific background"
        TMP="$(mktemp)"
        sed 's/Betelgeuse/Betelgeuse-{{ title .host.distro.id }}/g' < "${XDG_CONFIG_HOME:-$HOME/.config}/dconf/settings/org.gnome.desktop.background" > "$TMP"
        mv "$TMP" "${XDG_CONFIG_HOME:-$HOME/.config}/dconf/settings/org.gnome.desktop.background"
    else
        logg info 'OS-specific background not found'
    fi
fi

### Backup system settings
DCONF_TMP="$(mktemp)"
dconf dump / > "$DCONF_TMP"
logg info 'Backed up system dconf settings to '"$DCONF_TMP"

### Reset system settings / load saved configurations from ~/.config/dconf/settings
if [ -d "$XDG_CONFIG_HOME/dconf/settings" ]; then
    find "$XDG_CONFIG_HOME/dconf/settings" -mindepth 1 -maxdepth 1 -type f | while read DCONF_CONFIG_FILE; do
        if [ "$DEBUG_MODE" == 'true' ]; then
            logg info 'Dconf configuration file:'
            echo "$DCONF_CONFIG_FILE"
        fi
        DCONF_SETTINGS_ID="/$(basename "$DCONF_CONFIG_FILE" | sed 's/\./\//g')/"
        if [ "$DEBUG_MODE" == 'true' ]; then
            logg info 'Dconf settings ID:'
            echo "$DCONF_SETTINGS_ID"
        fi
        # Reset dconf settings if environment variable RESET_DCONF is set to true
        if [ "$RESET_DCONF" == 'true' ]; then
            logg info 'Resetting dconf settings for `'"$DCONF_SETTINGS_ID"'`'
            dconf reset -f "$DCONF_SETTINGS_ID"
        fi
        logg info 'Loading versioned dconf settings for `'"$DCONF_SETTINGS_ID"'`'
        dconf load "$DCONF_SETTINGS_ID" < "$DCONF_CONFIG_FILE"
        logg success 'Finished applying dconf settings for `'"$DCONF_SETTINGS_ID"'`'
    done
else
    logg warn '~/.config/dconf/settings does not exist!'
fi

{{ end -}}
```
