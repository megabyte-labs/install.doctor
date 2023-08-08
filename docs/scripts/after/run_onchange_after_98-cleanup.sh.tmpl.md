---
title: Miscellaneous Clean Up
description: Removes certain files that should not be necessary
sidebar_label: 98 Miscellaneous Clean Up
slug: /scripts/after/run_onchange_after_98-cleanup.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_98-cleanup.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_98-cleanup.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_98-cleanup.sh.tmpl
---
# Miscellaneous Clean Up

Removes certain files that should not be necessary

## Overview

This script removes various files in the `HOME` directory that are either no longer necessary
or cluttery.



## Source Code

```
#!/usr/bin/env bash
# @file Miscellaneous Clean Up
# @brief Removes certain files that should not be necessary
# @description
#     This script removes various files in the `HOME` directory that are either no longer necessary
#     or cluttery.

### Remove meta sudo file
if [ -f "$HOME/.sudo_as_admin_successful" ]; then
    rm -f "$HOME/.sudo_as_admin_successful"
fi

### Remove .bash_history file
# New dotfiles specify this to be kept in the ~/.local folder
if [ -f "$HOME/.bash_history" ]; then
    rm -f "$HOME/.bash_history"
fi

### Remove wget history file
# New dotfiles include alias that automatically adds the wget-hsts file in the ~/.local folder
if [ -f "$HOME/.wget-hsts" ]; then
    rm -f "$HOME/.wget-hsts"
fi

### Remove .wrangler
# Not sure how this is populating but the proper environment variables appear to be in place and nothing breaks when its removed
if [ -d "$HOME/.wrangler" ]; then
    rm -rf "$HOME/.wrangler"
fi
```
