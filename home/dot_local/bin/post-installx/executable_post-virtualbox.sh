#!/usr/bin/env bash
# @file VirtualBox Extension Pack
# @brief Ensures the VirtualBox extension pack is installed.
# @description
#     This script ensures the VirtualBox extension pack that corresponds with VirtualBox's version is properly installed.

### Run logic if VirtualBox is installed
if command -v VirtualBox > /dev/null; then
  ### Install VirtualBox extension pack if it is not installed already
  if [ ! -d /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ] && [ ! -d /Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ]; then
    logg info 'Acquiring VirtualBox version information'
    VBOX_VERSION="$(VirtualBox --help | head -n 1 | cut -f 6 -d' ')"
    VBOX_VERSION="${VBOX_VERSION//v}"
    ### Set up folders
    # Check for macOS installation before creating ExtensionPacks folder on Linux machines
    if [ ! -d /Applications/VirtualBox.app ]; then
      sudo mkdir -p /usr/lib/virtualbox/ExtensionPacks
    fi
    mkdir -p /tmp/vbox
    cd /tmp/vbox
    ### Download extension pack
    logg info 'Downloading VirtualBox extension pack'
    curl -sSL https://download.virtualbox.org/virtualbox/$VBOX_VERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack -o /tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack || logg error 'Failed to download the VirtualBox extension pack so the extension pack installation will be skipped'
    ### Install extension pack
    if [ -f /tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack ]; then
      logg info 'Installing VirtualBox extension pack'
      echo 'y' | sudo VBoxManage extpack install --replace /tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack
      logg success 'Successfully installed VirtualBox extension pack'
    fi
  else
    logg info 'VirtualBox Extension pack is already installed'
  fi
else
  logg info 'VirtualBox is not installed so VirtualBox Extension pack will not be installed'
fi
