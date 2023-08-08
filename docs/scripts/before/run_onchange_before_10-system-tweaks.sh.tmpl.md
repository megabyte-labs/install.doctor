---
title: Linux System Tweaks
description: Applies a set of generic Linux system tweaks such as ensuring the hostname is set, setting the timezone, and more
sidebar_label: 10 Linux System Tweaks
slug: /scripts/before/run_onchange_before_10-system-tweaks.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_10-system-tweaks.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_10-system-tweaks.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_10-system-tweaks.sh.tmpl
---
# Linux System Tweaks

Applies a set of generic Linux system tweaks such as ensuring the hostname is set, setting the timezone, and more

## Overview

This script applies generic Linux system tweaks that should be made before the rest of the provisioning process.



## Source Code

```
{{- if (eq .host.distro.family "linux") -}}
#!/usr/bin/env bash
# @file Linux System Tweaks
# @brief Applies a set of generic Linux system tweaks such as ensuring the hostname is set, setting the timezone, and more
# @description
#     This script applies generic Linux system tweaks that should be made before the rest of the provisioning process.

{{ includeTemplate "universal/profile-before" }}
{{ includeTemplate "universal/logg-before" }}

### Set hostname (if redefined)
if command -v hostnamectl > /dev/null; then
  # Betelgeuse is the default hostname so only change when it is different
  if [ '{{ .host.hostname }}' != 'Betelgeuse' ]; then
    logg info "Setting hostname to {{ .host.hostname }}"
    sudo hostnamectl set-hostname {{ .host.hostname }}
  fi
fi

### Set timezone
if command -v timedatectl > /dev/null; then
  logg info 'Setting timezone to `{{ .user.timezone }}`'
  sudo timedatectl set-timezone {{ .user.timezone }}
fi

### Modify vm.max_map_count
if command -v sysctl > /dev/null; then
  logg info 'Increasing vm.max_map_count size to 262144'
  sudo sysctl -w vm.max_map_count=262144 > /dev/null
fi
{{ end -}}
```
