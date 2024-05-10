#!/usr/bin/env bash
# @file tfenv
# @brief Configures tfenv to use the latest version of Terraform

if command -v tfenv > /dev/null; then
    logg info 'Configuring tfenv to use latest version of Terraform'
    tfenv use latest
else
    logg warn 'tfenv is not available in the PATH'
fi
