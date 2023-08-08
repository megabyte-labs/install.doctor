---
title: Linux Bloatware Removal
description: Removes Linux bloatware defined in `.removeLinuxPackages` of the `home/.chezmoidata.yaml` file
sidebar_label: 10 Linux Bloatware Removal
slug: /scripts/before/run_onchange_before_10-remove-bloatware.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_10-remove-bloatware.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_10-remove-bloatware.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_10-remove-bloatware.sh.tmpl
---
# Linux Bloatware Removal

Removes Linux bloatware defined in `.removeLinuxPackages` of the `home/.chezmoidata.yaml` file

## Overview

This script removes some of the software deemed to be "bloatware" by cycling through the values defined in
`.removeLinuxPackages` of the `home/.chezmoidata.yaml` file.



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
#!/usr/bin/env bash
# @file Linux Bloatware Removal
# @brief Removes Linux bloatware defined in `.removeLinuxPackages` of the `home/.chezmoidata.yaml` file
# @description
#     This script removes some of the software deemed to be "bloatware" by cycling through the values defined in
#     `.removeLinuxPackages` of the `home/.chezmoidata.yaml` file.

{{ includeTemplate "universal/profile-before" }}
{{ includeTemplate "universal/logg-before" }}

{{- $removePackages := join " " .removeLinuxPackages }}

### Remove bloatware packages defined in .chezmoidata.yaml
for PKG in {{ $removePackages }}; do
    if command -v apk > /dev/null; then
        if apk list "$PKG" | grep "$PKG" > /dev/null; then
            sudo apk delete "$PKG"
        fi
    elif command -v apt-get > /dev/null; then
        if dpkg -l "$PKG" | grep -E '^ii' > /dev/null; then
            sudo apt-get remove -y "$PKG"
            logg success 'Removed `'"$PKG"'` via apt-get'
        fi
    elif command -v dnf > /dev/null; then
        if rpm -qa | grep "$PKG" > /dev/null; then
            sudo dnf remove -y "$PKG"
            logg success 'Removed `'"$PKG"'` via dnf'
        fi
    elif command -v yum > /dev/null; then
        if rpm -qa | grep "$PKG" > /dev/null; then
            sudo yum remove -y "$PKG"
            logg success 'Removed `'"$PKG"'` via yum'
        fi
    elif command -v pacman > /dev/null; then
        if pacman -Qs "$PKG" > /dev/null; then
            sudo pacman -R "$PKG"
            logg success 'Removed `'"$PKG"'` via pacman'
        fi
    elif command -v zypper > /dev/null; then
        if rpm -qa | grep "$PKG" > /dev/null; then
            sudo zypper remove -y "$PKG"
            logg success 'Removed `'"$PKG"'` via zypper'
        fi
    fi
done

{{- end }}
```
