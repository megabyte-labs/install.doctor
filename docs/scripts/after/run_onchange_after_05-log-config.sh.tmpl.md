---
title: User Log Folders
description: Creates an empty directory for each user in `/var/log/user`
sidebar_label: 05 User Log Folders
slug: /scripts/after/run_onchange_after_05-log-config.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_05-log-config.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_05-log-config.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_05-log-config.sh.tmpl
---
# User Log Folders

Creates an empty directory for each user in `/var/log/user`

## Overview

This script creates an empty directory with each user's name in `/var/log/user`. It initializes the folder in hopes
that we can eventually store all user logs in a single directory alongside the system logs folder.



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file User Log Folders
# @brief Creates an empty directory for each user in `/var/log/user`
# @description
#     This script creates an empty directory with each user's name in `/var/log/user`. It initializes the folder in hopes
#     that we can eventually store all user logs in a single directory alongside the system logs folder.

{{ $homeDirs := (output "find" .host.homeParentFolder "-mindepth" "1" "-maxdepth" "1" "-type" "d") -}}
{{- range $homeDir := splitList "\n" $homeDirs -}}
{{- if ne $homeDir "" -}}
# home dir: {{ $homeDir }}
{{ end -}}
{{- end }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

find '{{ .host.homeParentFolder }}' -mindepth 1 -maxdepth 1 -type d | while read HOME_DIR; do
  USER_FOLDER="$(echo "$HOME_DIR" | sed 's/.*\/\([^\/]*\)$/\1/')"
  if [ -d "$HOME_DIR/.local" ]; then
    if [ ! -d "/var/log/user/$USER_FOLDER" ]; then
      logg info 'Creating /var/log/user/'"$USER_FOLDER"''
      sudo mkdir -p "/var/log/user/$USER_FOLDER"
    fi
  fi
done

{{ end -}}
```
