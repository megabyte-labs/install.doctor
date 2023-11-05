---
title: Python Symlink
description: Symlinks `python` to `python3` when Python 2.7 is not installed
sidebar_label: 06 Python Symlink
slug: /scripts/after/run_onchange_after_06-bin-symlink.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_06-bin-symlink.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_06-bin-symlink.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_06-bin-symlink.sh.tmpl
---
# Python Symlink

Symlinks `python` to `python3` when Python 2.7 is not installed

## Overview

This script checks if `python3` is available and if `python` is not available. If both are true, then the script
symlinks `python` to `python3` so that the `python` command uses `python3`.

This is useful if you do not want to install Python 2.7 and would like Python 3 to be used in all scenarios where Python is
invoked with the `python` command.



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file Python Symlink
# @brief Symlinks `python` to `python3` when Python 2.7 is not installed
# @description
#     This script checks if `python3` is available and if `python` is not available. If both are true, then the script
#     symlinks `python` to `python3` so that the `python` command uses `python3`.
#
#     This is useful if you do not want to install Python 2.7 and would like Python 3 to be used in all scenarios where Python is
#     invoked with the `python` command.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Symlink python3 to python if it is unavailable
if ! command -v python > /dev/null && command -v python3 > /dev/null; then
    logg info 'Symlinking python3 to python since the latter is unavailable'
    sudo ln -s "$(which python3)" /usr/local/bin/python
fi

{{ end -}}
```
