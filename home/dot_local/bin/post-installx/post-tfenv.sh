#!/usr/bin/env bash
# @file tfenv
# @brief Configures tfenv to use the latest version of Terraform

if command -v tfenv > /dev/null; then
    tfenv use latest
fi
