---
title: Global Profile Setup
description: Configures `/etc/environment` to include environment variables that should be applied globally
sidebar_label: 04 Global Profile Setup
slug: /scripts/after/run_onchange_after_04-environment-profile.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_04-environment-profile.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_04-environment-profile.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_04-environment-profile.sh.tmpl
---
# Global Profile Setup

Configures `/etc/environment` to include environment variables that should be applied globally

## Overview

This script modifies the `/etc/environment` file on Linux devices to include:

* `export QT_STYLE_OVERRIDE=kvantum-dark` which is required for the Linux GNOME / KDE themeing that relies on Kvantum.



## Source Code

```
{{- if (eq .host.distro.family "linux") -}}
#!/usr/bin/env bash
# @file Global Profile Setup
# @brief Configures `/etc/environment` to include environment variables that should be applied globally
# @description
#     This script modifies the `/etc/environment` file on Linux devices to include:
#
#     * `export QT_STYLE_OVERRIDE=kvantum-dark` which is required for the Linux GNOME / KDE themeing that relies on Kvantum.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Ensure QT_STYLE_OVERRIDE is set in /etc/environment
logg info 'Ensuring QT_STYLE_OVERRIDE is set in /etc/environment'
if cat /etc/environment | grep QT_STYLE_OVERRIDE > /dev/null; then
  sudo sed -i 's/.*QT_STYLE_OVERRIDE.*/export QT_STYLE_OVERRIDE=kvantum-dark/' /etc/environment
  logg info 'Updated QT_STYLE_OVERRIDE in /etc/environment'
else
  echo 'export QT_STYLE_OVERRIDE=kvantum-dark' | sudo tee -a /etc/environment
  logg info 'Added QT_STYLE_OVERRIDE to /etc/environment'
fi

{{ end -}}
```
