---
title: GNOME Restart
description: Reloads `gnome-shell` so that the theme is properly loaded
sidebar_label: 99 GNOME Restart
slug: /scripts/after/run_onchange_after_99-restart-gnome.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_99-restart-gnome.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_99-restart-gnome.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_99-restart-gnome.sh.tmpl
---
# GNOME Restart

Reloads `gnome-shell` so that the theme is properly loaded

## Overview

This script reloads the `gnome-shell` so that the theme is properly loaded without having to reboot. This
only runs when the `HEADLESS_INSTALL` variable is passed because, unless you are provisioning the session headlessly,
you probably want to retain the terminal window that initialized the provisioning process since it contains
all the logs.

## Logs

Regardless of whether or not this script runs, you can access the provisioning logs by browsing through
`${XDG_DATA_HOME:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log`



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file GNOME Restart
# @brief Reloads `gnome-shell` so that the theme is properly loaded
# @description
#     This script reloads the `gnome-shell` so that the theme is properly loaded without having to reboot. This
#     only runs when the `HEADLESS_INSTALL` variable is passed because, unless you are provisioning the session headlessly,
#     you probably want to retain the terminal window that initialized the provisioning process since it contains
#     all the logs.
#
#     ## Logs
#
#     Regardless of whether or not this script runs, you can access the provisioning logs by browsing through
#     `${XDG_DATA_HOME:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log`

### Restart GNOME if `HEADLESS_INSTALL` is defined and `gnome-shell` is available
if [ -n "$HEADLESS_INSTALL" ] && command -v gnome-shell > /dev/null; then
    logg info 'Reloading `gnome-shell`'
    killall -3 gnome-shell
else
    logg info 'Manually reload `gnome-shell` to see changes'
fi

{{ end -}}
```
