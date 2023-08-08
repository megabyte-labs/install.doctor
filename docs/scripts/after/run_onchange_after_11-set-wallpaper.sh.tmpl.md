---
title: Qubes Set Wallpaper
description: Ensures the Qubes wallpaper is set to the Betelgeuse wallpaper for Qubes.
sidebar_label: 11 Qubes Set Wallpaper
slug: /scripts/after/run_onchange_after_11-set-wallpaper.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_11-set-wallpaper.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_11-set-wallpaper.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_11-set-wallpaper.sh.tmpl
---
# Qubes Set Wallpaper

Ensures the Qubes wallpaper is set to the Betelgeuse wallpaper for Qubes.

## Overview

This script ensures the Qubes desktop wallpaper is set to the Qubes Betelgeuse wallpaper on KDE by
using the `ksetwallpaper` script found in `~/.local/bin/ksetwallpaper`.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Set Wallpaper
# @brief Ensures the Qubes wallpaper is set to the Betelgeuse wallpaper for Qubes.
# @description
#     This script ensures the Qubes desktop wallpaper is set to the Qubes Betelgeuse wallpaper on KDE by
#     using the `ksetwallpaper` script found in `~/.local/bin/ksetwallpaper`.

ksetwallpaper --file /usr/local/share/wallpapers/Betelgeuse/contents/images/3440x1440.jpg
{{ end -}}
```
