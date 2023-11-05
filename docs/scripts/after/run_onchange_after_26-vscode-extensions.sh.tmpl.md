---
title: VSCode Extensions
description: Installs all of the Visual Studio Code extensions specified in the [`home/dot_config/Code/User/extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json) file.
sidebar_label: 26 VSCode Extensions
slug: /scripts/after/run_onchange_after_26-vscode-extensions.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_26-vscode-extensions.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_26-vscode-extensions.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_26-vscode-extensions.sh.tmpl
---
# VSCode Extensions

Installs all of the Visual Studio Code extensions specified in the [`home/dot_config/Code/User/extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json) file.

## Overview

This script loops through all the extensions listed in the [`home/dot_config/Code/User/extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json)
file. It installs the extensions when either Visual Studio Code or VSCodium is installed. If both are installed, then both will
have the plugins automatically installed.

The `extensions.json` file is used to house the plugin list so that if you decide to remove this auto-installer script then
VSCode will retain some functionality from the file. It will show a popover card that recommends installing any plugins in the
list that are not already installed.

## Plugin Settings

Most of the plugin settings have been configured and optimized to work properly with the other default settings
included by Install Doctor. These settings can be found in the [`home/dot_config/Code/User/settings.json` file](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/settings.json).
If you manage to come up with an improvement, please open a pull request so other users can benefit from your work.

## Default Extensions

The default plugins in the `extensions.json` list are catered mostly towards full-stack web development. The technologies
that are catered to by the default extensions relate to TypeScript, JavaScript, Go, Python, Rust, and many more technologies.
Most of the plugins are not language-specific.

## Links

* [Visual Studio Code settings folder](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User)
* [Visual Studio Code `extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json)



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file VSCode Extensions
# @brief Installs all of the Visual Studio Code extensions specified in the [`home/dot_config/Code/User/extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json) file.
# @description
#     This script loops through all the extensions listed in the [`home/dot_config/Code/User/extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json)
#     file. It installs the extensions when either Visual Studio Code or VSCodium is installed. If both are installed, then both will
#     have the plugins automatically installed.
#
#     The `extensions.json` file is used to house the plugin list so that if you decide to remove this auto-installer script then
#     VSCode will retain some functionality from the file. It will show a popover card that recommends installing any plugins in the
#     list that are not already installed.
#
#     ## Plugin Settings
#
#     Most of the plugin settings have been configured and optimized to work properly with the other default settings
#     included by Install Doctor. These settings can be found in the [`home/dot_config/Code/User/settings.json` file](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/settings.json).
#     If you manage to come up with an improvement, please open a pull request so other users can benefit from your work.
#
#     ## Default Extensions
#
#     The default plugins in the `extensions.json` list are catered mostly towards full-stack web development. The technologies
#     that are catered to by the default extensions relate to TypeScript, JavaScript, Go, Python, Rust, and many more technologies.
#     Most of the plugins are not language-specific.
#
#     ## Links
#
#     * [Visual Studio Code settings folder](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User)
#     * [Visual Studio Code `extensions.json`](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/Code/User/extensions.json)

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Hides useless error during extension installations
# Error looks like:
#     (node:53151) [DEP0005] DeprecationWarning: Buffer() is deprecated due to security and usability issues. Please use the Buffer.alloc(), Buffer.allocUnsafe(), or Buffer.from() methods instead.
#     (Use `Electron --trace-deprecation ...` to show where the warning was created)
export NODE_OPTIONS=--throw-deprecation

# @description Install Visual Studio Code extensions if they are not already installed (by checking the `code --list-extensions` output)
if command -v code > /dev/null; then
    EXTENSIONS="$(code --list-extensions)"
    jq -r '.recommendations[]' "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/extensions.json" | while read EXTENSION; do
        if ! echo "$EXTENSIONS" | grep -iF "$EXTENSION" > /dev/null; then
            logg info 'Installing Visual Studio Code extension '"$EXTENSION"''
            code --install-extension "$EXTENSION"
            logg success 'Installed '"$EXTENSION"''
        else
            logg info ''"$EXTENSION"' already installed'
        fi
    done
else
    logg warn 'code executable not available'
fi

# @description Check for the presence of the `codium` command in the `PATH` and install extensions for VSCodium if it is present
if command -v codium > /dev/null; then
    EXTENSIONS="$(codium --list-extensions)"
    jq -r '.recommendations[]' "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/extensions.json" | while read EXTENSION; do
        if ! echo "$EXTENSIONS" | grep -iF "$EXTENSION" > /dev/null; then
            logg info 'Installing VSCodium extension '"$EXTENSION"''
            codium --install-extension "$EXTENSION"
            logg success 'Installed '"$EXTENSION"''
        else
            logg info ''"$EXTENSION"' already installed'
        fi
    done
else
    logg warn 'codium executable not available'
fi

{{ end -}}
```
