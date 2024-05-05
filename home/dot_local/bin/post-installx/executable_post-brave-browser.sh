#!/usr/bin/env bash
# @file Brave Browser Setup
# @brief Applies browser policy configurations

function chromeSetUp() {
  ### Ensure Chrome policies directory is present
  logg info 'Processing policy directories for Chromium based browsers'
  for POLICY_DIR in "/etc/brave/policies"; do
    if [ -d "$(dirname "$POLICY_DIR")" ]; then
      ### Managed policies
      if [ ! -f "$POLICY_DIR/managed/policies.json" ]; then
        logg info "Ensuring directory $POLICY_DIR/managed exists"
        sudo mkdir -p "$POLICY_DIR/managed"
        logg info "Copying ${XDG_CONFIG_HOME:-$HOME/.config}/chrome/managed.json to $POLICY_DIR/managed/policies.json"
        sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/managed.json" "$POLICY_DIR/managed/policies.json"
      fi

      ### Recommended policies
      if [ ! -f "$POLICY_DIR/recommended/policies.json" ]; then
        logg info "Ensuring directory $POLICY_DIR/recommended exists" && sudo mkdir -p "$POLICY_DIR/recommended"
        logg info "Copying ${XDG_CONFIG_HOME:-$HOME/.config}/chrome/recommended.json to $POLICY_DIR/recommended/policies.json"
        sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/recommended.json" "$POLICY_DIR/recommended/policies.json"
      fi
    else
      logg info "Skipping extension injection into $POLICY_DIR - create these folders prior to running to create managed configs"
    fi
  done
  ### Add Chrome extension JSON
  # logg info 'Populating Chrome extension JSON'
  # for EXTENSION_DIR in "/etc/brave/extensions" "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/External Extensions"; do
  #   ### Ensure program-type is installed
  #   if [ -d "$(dirname "$EXTENSION_DIR")" ]; then
  #     ### Ensure extension directory exists
  #     if [[ "$EXTENSION_DIR" == '/opt/'* ]] || [[ "$EXTENSION_DIR" == '/etc/'* ]]; then
  #       if [ ! -d "$EXTENSION_DIR" ]; then
  #         logg info "Creating directory $EXTENSION_DIR" && sudo mkdir -p "$EXTENSION_DIR"
  #       fi
  #     else
  #       if [ ! -d "$EXTENSION_DIR" ]; then
  #         logg info "Creating directory $EXTENSION_DIR" && mkdir -p "$EXTENSION_DIR"
  #       fi
  #     fi
  #     ### Add extension JSON
  #     logg info "Adding Chrome extensions to $EXTENSION_DIR"
  #     for EXTENSION in { { list (.chromeExtensions | toString | replace "[" "" | replace "]" "") | uniq | join " " } }; do
  #       logg info "Adding Chrome extension manifest ($EXTENSION)"
  #       if ! echo "$EXTENSION" | grep 'https://chrome.google.com/webstore/detail/' > /dev/null; then
  #         EXTENSION="https://chrome.google.com/webstore/detail/$EXTENSION"
  #       fi
  #       EXTENSION_ID="$(echo "$EXTENSION" | sed 's/^.*\/\([^\/]*\)$/\1/')"
  #       if [[ "$EXTENSION_DIR" == '/opt/'* ]] || [[ "$EXTENSION_DIR" == '/etc/'* ]]; then
  #         sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/extension.json" "$EXTENSION_DIR/${EXTENSION_ID}.json"
  #       else
  #         cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/chrome/extension.json" "$EXTENSION_DIR/${EXTENSION_ID}.json"
  #       fi
  #     done
  #   else
  #     logg info "$EXTENSION_DIR does not exist"
  #   fi
  # done
}

chromeSetUp
