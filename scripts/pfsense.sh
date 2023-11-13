#!/bin/sh
# @file pfSense Setup
# @brief Configures pfSense
# @description
#     This script sets up pfSense with features like:
#
#     1. [Netdata Cloud](https://learn.netdata.cloud/docs/installing/pfsense)

# @description Logs with style using Gum if it is installed, otherwise it uses `echo`. It also leverages Glow to render markdown.
#     When Glow is not installed, it uses `cat`.
# @example
#     logger info "An informative log"
logg() {
  TYPE="$1"
  MSG="$2"
  if [ "$TYPE" == 'error' ]; then
    if command -v gum > /dev/null; then
        gum style --border="thick" "$(gum style --foreground="#ff0000" "✖") $(gum style --bold --background="#ff0000" --foreground="#ffffff"  " ERROR ") $(gum style --bold "$MSG")"
    else
        echo "ERROR: $MSG"
    fi
  elif [ "$TYPE" == 'info' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ffff" "○") $(gum style --faint "$MSG")"
    else
        echo "INFO: $MSG"
    fi
  elif [ "$TYPE" == 'md' ]; then
    if command -v glow > /dev/null; then
        glow "$MSG"
    else
        cat "$MSG"
    fi
  elif [ "$TYPE" == 'prompt' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00008b" "▶") $(gum style --bold "$MSG")"
    else
        echo "PROMPT: $MSG"
    fi
  elif [ "$TYPE" == 'star' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold "$MSG")"
    else
        echo "STAR: $MSG"
    fi
  elif [ "$TYPE" == 'start' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$MSG")"
    else
        echo "START: $MSG"
    fi
  elif [ "$TYPE" == 'success' ]; then
    if command -v gum > /dev/null; then
        gum style "$(gum style --foreground="#00ff00" "✔")  $(gum style --bold "$MSG")"
    else
        echo "SUCCESS: $MSG"
    fi
  elif [ "$TYPE" == 'warn' ]; then
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#d1d100" "◆") $(gum style --bold --background="#ffff00" --foreground="#000000"  " WARNING ") $(gum style --bold "$MSG")"
    else
        echo "WARNING: $MSG"
    fi
  else
    if command -v gum > /dev/null; then
        gum style " $(gum style --foreground="#00ff00" "▶") $(gum style --bold "$TYPE")"
    else
        echo "$MSG"
    fi
  fi
}

### Enable FreeBSD package repo
logg info 'Enabling FreeBSD package repo'
FILE_PATH="/usr/local/etc/pkg/repos/pfSense.conf"
TMP_FILE=$(mktemp)
REPLACEMENT="FreeBSD: { enabled: yes }"
echo "$REPLACEMENT" > "$TMP_FILE"
tail -n +2 "$FILE_PATH" >> "$TMP_FILE"
mv -f "$TMP_FILE" "$FILE_PATH"
rm -f "$TMP_FILE"

### Install Netdata / dependencies
logg info 'Installing Netdata system package dependencies'
pkg update
pkg install -y curl pkgconf bash e2fsprogs-libuuid libuv nano
pkg install -y json-c-0.15_1
pkg install -y py39-certifi-2023.5.7
pkg install -y py39-asn1crypto
pkg install -y py39-pycparser
pkg install -y py39-cffi
pkg install -y py39-six
pkg install -y py39-cryptography
pkg install -y py39-idna
pkg install -y py39-openssl
pkg install -y py39-pysocks
pkg install -y py39-urllib3
pkg install -y py39-yaml
pkg install -y netdata

### Modify Netdata configuration
logg info 'Configuring Netdata to work with Netdata Cloud'
# TODO: Add below to netdata.conf
# bind to = 127.0.0.1 to bind to = 0.0.0.0
NETDATA_CLOUD_API_TOKEN="YOUR_API_TOKEN_HERE"
cat <<EOF > /usr/local/etc/netdata/netdata.conf
[backend]
    enabled = yes
    data source = netdata
    destination = https://app.netdata.cloud
    api key = ${NETDATA_CLOUD_API_TOKEN}
EOF

### Start Netdata
logg info 'Starting Netdata service'
service netdata onestart
