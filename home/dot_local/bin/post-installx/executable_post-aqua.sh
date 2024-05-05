#!/usr/bin/env bash
# @file Aqua Initialization
# @brief Updates and installs any Aqua dependencies that are defined in Aqua's configuration file.
# @description
#     This script updates Aqua and then installs any Aqua dependencies that are defined.

if command -v aqua > /dev/null; then
  logg info 'Updating Aqua'
  aqua update-aqua
  logg info 'Installing Aqua dependencies (if any are defined)'
  aqua install -a
else
  logg info 'Skipping aqua install script because aqua was not installed'
fi
