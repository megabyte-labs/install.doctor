---
title: Crontab Jobs
description: Schedules Crontab jobs by importing a configuration stored in `~/.config/crontab/config`
sidebar_label: 50 Crontab Jobs
slug: /scripts/after/run_onchange_after_50-crontab.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_50-crontab.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_50-crontab.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_50-crontab.sh.tmpl
---
# Crontab Jobs

Schedules Crontab jobs by importing a configuration stored in `~/.config/crontab/config`

## Overview

This script loads crontab jobs that are defined and housed in your Install Doctor fork.



## Source Code

```
{{- if false }}
#!/usr/bin/env bash
# @file Crontab Jobs
# @brief Schedules Crontab jobs by importing a configuration stored in `~/.config/crontab/config`
# @description
#     This script loads crontab jobs that are defined and housed in your Install Doctor fork.

# crontab config hash: {{ include (joinPath .chezmoi.homeDir ".config" "crontab" "config")| sha256sum }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

logg 'Installing crontab jobs'
crontab < "$XDG_CONFIG_HOME/crontab/config"
{{ end -}}
```
