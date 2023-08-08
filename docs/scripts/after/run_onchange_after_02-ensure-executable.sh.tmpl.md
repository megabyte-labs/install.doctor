---
title: Ensure Local Bin Executable
description: Ensures all the scripts located in `~/.local/bin` have executable permissions
sidebar_label: 02 Ensure Local Bin Executable
slug: /scripts/after/run_onchange_after_02-ensure-executable.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_02-ensure-executable.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_02-ensure-executable.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_02-ensure-executable.sh.tmpl
---
# Ensure Local Bin Executable

Ensures all the scripts located in `~/.local/bin` have executable permissions

## Overview

This script cycles through the scripts in `~/.local/bin` are executable. It only cycles through
the scripts that are exactly one level deep in the `~/.local/bin` folder.



## Source Code

```
#!/usr/bin/env bash
# @file Ensure Local Bin Executable
# @brief Ensures all the scripts located in `~/.local/bin` have executable permissions
# @description
#     This script cycles through the scripts in `~/.local/bin` are executable. It only cycles through
#     the scripts that are exactly one level deep in the `~/.local/bin` folder.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

{{ $exeFiles := (output "find" (joinPath .chezmoi.homeDir ".local" "bin") "-mindepth" "1" "-maxdepth" "1" "-type" "f") -}}
{{- range $exeFile := splitList "\n" $exeFiles -}}
{{- if ne $exeFile "" -}}
# {{ $exeFile }}
{{ end -}}
{{- end }}

logg info 'Ensuring all files in ~/.local/bin are executable'
find "$HOME/.local/bin" -mindepth 1 -maxdepth 1 -type f | while read EXE_FILE; do
  chmod +x "$EXE_FILE"
done
```
