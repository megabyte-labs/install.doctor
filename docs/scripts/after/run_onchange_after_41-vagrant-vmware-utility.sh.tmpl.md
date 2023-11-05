---
title: Vagrant VMWare Utility
description: Installs the `vagrant-vmware-utility` if both Vagrant and VMWare are installed
sidebar_label: 41 Vagrant VMWare Utility
slug: /scripts/after/run_onchange_after_41-vagrant-vmware-utility.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_41-vagrant-vmware-utility.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_41-vagrant-vmware-utility.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_41-vagrant-vmware-utility.sh.tmpl
---
# Vagrant VMWare Utility

Installs the `vagrant-vmware-utility` if both Vagrant and VMWare are installed

## Overview

This script first checks if `vagrant`, `vmware`, and `vagrant-vmware-utility` are available in the `PATH`. If they are present, then the script
configures the [`vagrant-vmware-utility`](https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility) by generating the required security certificates and enabling the service.
This system package enables the capability of controlling both VMWare Workstation and VMWare Fusion with Vagrant.

Since this script runs only when `vagrant`, `vmware`, and `vagrant-vmware-utility` are in the `PATH`, this means that it will run
when you use an installation template that includes all three pieces of software in the software list defined in
`home/.chezmoidata.yaml`.

## Links

* [Vagrant VMWare Utility on GitHub](https://github.com/hashicorp/vagrant-vmware-desktop)
* [`home/.chezmoidata.yaml`](https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoidata.yaml)



## Source Code

```
{{- if ne .host.distro.family "windows" -}}
#!/usr/bin/env bash
# @file Vagrant VMWare Utility
# @brief Installs the `vagrant-vmware-utility` if both Vagrant and VMWare are installed
# @description
#     This script first checks if `vagrant`, `vmware`, and `vagrant-vmware-utility` are available in the `PATH`. If they are present, then the script
#     configures the [`vagrant-vmware-utility`](https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility) by generating the required security certificates and enabling the service.
#     This system package enables the capability of controlling both VMWare Workstation and VMWare Fusion with Vagrant.
#
#     Since this script runs only when `vagrant`, `vmware`, and `vagrant-vmware-utility` are in the `PATH`, this means that it will run
#     when you use an installation template that includes all three pieces of software in the software list defined in
#     `home/.chezmoidata.yaml`.
#
#     ## Links
#
#     * [Vagrant VMWare Utility on GitHub](https://github.com/hashicorp/vagrant-vmware-desktop)
#     * [`home/.chezmoidata.yaml`](https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoidata.yaml)

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

# @description Only run logic if both Vagrant and VMWare are installed
if command -v vagrant > /dev/null && command -v vmware > /dev/null; then
    # @description  Vagrant VMWare Utility configuration
    if command -v vagrant-vmware-utility > /dev/null; then
        if [ -f /usr/local/bin/certificates/vagrant-utility.key ]; then
            logg info 'Assuming Vagrant VMWare Utility certificates have been properly generated since /usr/local/bin/certificates/vagrant-utility.key is present'
        else
            logg info 'Generating Vagrant VMWare Utility certificates'
            sudo vagrant-vmware-utility certificate generate
            logg success 'Generated Vagrant VMWare Utility certificates via vagrant-vmware-utility certificate generate'
        fi
        logg info 'Ensuring the Vagrant VMWare Utility service is enabled'
        sudo vagrant-vmware-utility service install || EXIT_CODE=$?
        if [ -n "$EXIT_CODE" ]; then
            logg info 'The Vagrant VMWare Utility command vagrant-vmware-utility service install failed. It is probably already setup.'
        fi
    fi
else
    logg warn 'Vagrant is not installed so the Vagrant plugins will not be installed'
    logg warn 'Vagrant or VMWare is not installed so the Vagrant VMWare utility will not be configured'
fi

{{ end -}}
```
