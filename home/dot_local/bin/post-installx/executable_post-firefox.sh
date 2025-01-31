#!/usr/bin/env bash
# @file Firefox Settings / Add-Ons / Profiles
# @brief This script configures system-wide settings, sets up Firefox Profile Switcher, creates various profiles from different sources, and installs a configurable list of Firefox Add-Ons.
# @description
#     The Firefox setup script performs a handful of tasks that automate the setup of Firefox as well as
#     useful utilities that will benefit Firefox power-users. The script also performs the same logic on
#     [LibreWolf](https://librewolf.net/) installations.
#
#     ## Features
#
#     * Installs and sets up [Firefox Profile Switcher](https://github.com/null-dev/firefox-profile-switcher)
#     * Sets up system-wide enterprise settings (with configurations found in `~/.local/share/firefox`)
#     * Sets up a handful of default profiles to use with the Firefox Profile Switcher
#     * Automatically installs the plugins defined in the firefoxAddOns key of [`home/.chezmoidata.yaml`](https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoidata.yaml) to the Standard and Private profiles
#     * Configures the default profile to clone its settings from the profile stored in firefoxPublicProfile of `home/.chezmoidata.yaml`
#     * Optionally, if the Chezmoi encryption key is present, then the default profile will be set to the contents of an encrypted `.tar.gz` that must be stored in the cloud somewhere (with the firefoxPrivateProfile key in `home/.chezmoidata.yaml` defining the URL of the encrypted `.tar.gz`)
#
#     ## Profiles
#
#     The script sets up numerous profiles for user flexibility. They can be switched by using the Firefox Profile Switcher
#     that this script sets up. The map of the profiles is generated by using the template file stored in `~/.local/share/firefox/profiles.ini`.
#     The following details the features of each profile:
#
#     | Name             | Description                                                                                 |
#     |------------------|---------------------------------------------------------------------------------------------|
#     | Factory          | Default browser settings (system-wide configurations still apply)                           |
#     | default-release  | Same as Factory (unmodified and generated by headlessly opening Firefox / LibreWolf)        |
#     | Git (Public)     | Pre-configured profile with address stored in `firefoxPublicProfile`                        |
#     | Standard         | Cloned from the profile above with `firefoxAddOns` also installed                           |
#     | Miscellaneous    | Cloned from the Factory profile (with the user.js found in `~/.config/firefox` applied)     |
#     | Development      | Same as Miscellaneous                                                                       |
#     | Automation       | Same as Miscellaneous                                                                       |
#     | Private          | Populated from an encrypted profile stored in the cloud (also installs `firefoxAddOns`)     |
#
#     ## Notes
#
#     * The Firefox Profile Switcher is only compatible with Firefox and not LibreWolf
#     * This script is only designed to properly provision profiles on a fresh installation (so it does not mess around with pre-existing / already configured profiles)
#     * Additional profiles for LibreWolf are not added because the Firefox Profile Switcher is not compatible with LibreWolf
#
#     ## Links
#
#     * [System-wide configurations](https://github.com/megabyte-labs/install.doctor/tree/master/home/dot_local/share/firefox) as well as the location of the `profile.ini` and some other configurations
#     * [User-specific configurations](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/firefox/user.js) added to all profiles except Factory

set -Eeo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

function installFirefoxProfileConnector() {
  gum log -sl info 'Installing the Firefox Profile Connector'
  if command -v apt-get > /dev/null; then
    sudo apt-get install -y https://github.com/null-dev/firefox-profile-switcher-connector/releases/latest/download/linux-x64.deb
  elif command -v dnf > /dev/null; then
    sudo dnf install -y https://github.com/null-dev/firefox-profile-switcher-connector/releases/latest/download/linux-x64.rpm
  elif command -v yay > /dev/null; then
    yay -Ss firefox-profile-switcher-connector
  else
    gum log -sl warn 'apt-get, dnf, and yay were all unavailable so the Firefox Profile Connector helper executable could not be installed'
  fi
}

function firefoxSetup() {
  ### Installs the Firefox Profile Connector on Linux systems (Snap / Flatpak installs are not included in this function, but instead inline below)
  ### Add Firefox enterprise profile
  # TODO - figure out how to do this for other installations like Flatpak and macOS and Librewolf
  for FIREFOX_DIR in '/usr/lib/firefox' '/usr/lib/firefox-esr' '/etc/firefox' '/etc/firefox-esr' '/Applications/Firefox.app/Contents/Resources'; do
    if [ -d "$FIREFOX_DIR" ] && [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/firefox" ] && command -v rsync > /dev/null; then
      gum log -sl info "Syncing enterprise profiles from ${XDG_DATA_HOME:-$HOME/.local/share}/firefox to $FIREFOX_DIR"
      sudo rsync -artuE --chown=root:root --chmod=Du=rwx,Dg=rx,Do=rx,Fu=rwX,Fg=rX,Fo=rX --inplace --exclude .git/ "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/" "$FIREFOX_DIR" > /dev/null
    fi
  done

  ### Loop through various Firefox profile locations
  for SETTINGS_DIR in "$HOME/snap/firefox/common/.mozilla/firefox" "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox" "$HOME/Library/Application Support/Firefox/Profiles" "$HOME/.mozilla/firefox"; do
    ### Determine executable to use
    gum log -sl info "Processing Firefox profile location $SETTINGS_DIR"
    unset FIREFOX_EXE
    if [ "$SETTINGS_DIR" == "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox" ]; then
      if ! command -v org.mozilla.firefox > /dev/null || [ ! -d "$HOME/.var/app/org.mozilla.firefox" ]; then
        continue
      else
        FIREFOX_EXE="$(which org.mozilla.firefox)"
        ### Firefox Profile Switcher
        BASE_DIR="$HOME/.var/app/org.mozilla.firefox"
        BIN_INSTALL_DIR="$BASE_DIR/data/firefoxprofileswitcher-install"
        MANIFEST_INSTALL_DIR="$BASE_DIR/.mozilla/native-messaging-hosts"
        DOWNLOAD_URL="https://github.com/null-dev/firefox-profile-switcher-connector/releases/latest/download/linux-x64.deb"
        ### Ensure Firefox Profile Switcher is not already installed
        if [ ! -f "$BIN_INSTALL_DIR/usr/bin/ff-pswitch-connector" ] || [ ! -f "$MANIFEST_INSTALL_DIR/ax.nd.profile_switcher_ff.json" ]; then
          ### Download profile switcher
          mkdir -p "$BIN_INSTALL_DIR"
          TMP_FILE="$(mktemp)"
          gum log -sl info 'Downloading Firefox Profile Switch connector'
          curl -sSL "$DOWNLOAD_URL" -o "$TMP_FILE"
          ar p "$TMP_FILE" data.tar.xz | tar xfJ - --strip-components=2 -C "$BIN_INSTALL_DIR" usr/bin/ff-pswitch-connector
          rm -f "$TMP_FILE"
          ### Create manifest
          gum log -sl info 'Copying profile switcher configuration to manifest directory'
          mkdir -p "$MANIFEST_INSTALL_DIR"
          cat "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/profile-switcher.json" | sed 's=PATH_PLACEHOLDER='"$BIN_INSTALL_DIR"'=' > "$MANIFEST_INSTALL_DIR/ax.nd.profile_switcher_ff.json"
        fi
      fi
    elif [ "$SETTINGS_DIR" == "$HOME/.var/app/io.gitlab.librewolf-community/.librewolf" ]; then
      if ! command -v io.gitlab.librewolf-community > /dev/null || [ ! -d "$HOME/.var/app/io.gitlab.librewolf-community" ]; then
        continue
      else
        continue
        # FIREFOX_EXE="$(which io.gitlab.librewolf-community)"
      fi
    elif [ "$SETTINGS_DIR" == "$HOME/Library/Application Support/Firefox/Profiles" ]; then
      FIREFOX_EXE="/Applications/Firefox.app/Contents/MacOS/firefox"
      if [ ! -f "$FIREFOX_EXE" ] || [ ! -d /Applications ]; then
        continue
      else
        ### Download Firefox Profile Switcher
        if [ ! -d /usr/local/Cellar/firefox-profile-switcher-connector ]; then
          gum log -sl info 'Ensuring Firefox Profile Switcher is installed'
          brew install --quiet null-dev/firefox-profile-switcher/firefox-profile-switcher-connector
        fi

        ### Ensure Firefox Profile Switcher configuration is symlinked
        if [ ! -d "/Library/Application Support/Mozilla/NativeMessagingHosts/ax.nd.profile_switcher_ff.json" ]; then
          gum log -sl info 'Ensuring Firefox Profile Switcher is configured'
          sudo mkdir -p "/Library/Applcation Support/Mozilla/NativeMessagingHosts"
          sudo ln -sf "$(brew ls -l firefox-profile-switcher-connector | grep -i ax.nd.profile_switcher_ff.json | head -n1)" "/Library/Application Support/Mozilla/NativeMessagingHosts/ax.nd.profile_switcher_ff.json"
        fi
      fi
    elif [ "$SETTINGS_DIR" == "$HOME/Library/Application Support/LibreWolf/Profiles" ]; then
      continue
      # FIREFOX_EXE="/Applications/LibreWolf.app/Contents/MacOS/librewolf"
      # if [ ! -f "$FIREFOX_EXE" ] || [ ! -d /Applications ]; then
      #   gum log -sl info "$FIREFOX_EXE is not a file"
      #   continue
      # fi
    elif [ "$SETTINGS_DIR" == "$HOME/snap/firefox/common/.mozilla/firefox" ]; then
      FIREFOX_EXE="/snap/bin/firefox"
      if [ ! -f "$FIREFOX_EXE" ] || [ ! -d "$HOME/snap/firefox" ]; then
        continue
      else
        ### Firefox Profile Switcher
        BASE_DIR="$HOME/snap/firefox/common"
        BIN_INSTALL_DIR="$BASE_DIR/firefoxprofileswitcher-install"
        MANIFEST_INSTALL_DIR="$BASE_DIR/.mozilla/native-messaging-hosts"
        DOWNLOAD_URL="https://github.com/null-dev/firefox-profile-switcher-connector/releases/latest/download/linux-x64.deb"

        ### Ensure Firefox Profile Switcher is not already installed
        if [ ! -f "$BIN_INSTALL_DIR/usr/bin/ff-pswitch-connector" ] || [ ! -f "$MANIFEST_INSTALL_DIR/ax.nd.profile_switcher_ff.json" ]; then
          ### Download profile switcher
          mkdir -p "$BIN_INSTALL_DIR"
          TMP_FILE="$(mktemp)"
          gum log -sl info 'Downloading Firefox Profile Switch connector'
          curl -sSL "$DOWNLOAD_URL" -o "$TMP_FILE"
          ar p "$TMP_FILE" data.tar.xz | tar xfJ - --strip-components=2 -C "$BIN_INSTALL_DIR" usr/bin/ff-pswitch-connector
          rm -f "$TMP_FILE"

          ### Create manifest
          gum log -sl info 'Copying profile switcher configuration to manifest directory'
          mkdir -p "$MANIFEST_INSTALL_DIR"
          cat "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/profile-switcher.json" | sed 's/PATH_PLACEHOLDER/'"$BIN_INSTALL_DIR"'/' > "$MANIFEST_INSTALL_DIR/ax.nd.profile_switcher_ff.json"
        fi
      fi
    elif [ "$SETTINGS_DIR" == "$HOME/.mozilla/firefox" ]; then
      if command -v firefox-esr > /dev/null; then
        FIREFOX_EXE="$(which firefox-esr)"
        installFirefoxProfileConnector
      elif command -v firefox > /dev/null && [ "$(which firefox)" != *'snap'* ] && [ "$(which firefox)" != *'flatpak'* ] && [ ! -d /Applications ] && [ ! -d /System ]; then
        # Conditional check ensures Snap / Flatpak / macOS Firefox versions do not try to install to the wrong folder
        FIREFOX_EXE="$(which firefox)"
        installFirefoxProfileConnector
      else
        if [ -d /Applications ] && [ -d /System ]; then
          # Continue on macOS without logging because profiles are not stored here on macOS
          continue
        else
          gum log -sl warn 'Unable to register Firefox executable'
          gum log -sl info "Settings directory: $SETTINGS_DIR"
          continue
        fi
      fi
    fi

    ### Initiatize Firefox default profiles
    gum log -sl info "Processing executable located at $FIREFOX_EXE"
    if command -v "$FIREFOX_EXE" > /dev/null; then
      ### Create default profile by launching Firefox headlessly
      gum log -sl info "Firefox executable set to $FIREFOX_EXE"
      if [ ! -d "$SETTINGS_DIR" ]; then
        gum log -sl info 'Running Firefox (or its derivative) headlessly to generate default profiles'
        timeout 14 "$FIREFOX_EXE" --headless || EXIT_CODE=$?
        gum log -sl info 'Finished running Firefox headlessly'
      elif [ -d /Applications ] && [ -d /System ] && [ ! -f "$SETTINGS_DIR/../installs.ini" ]; then
        gum log -sl info 'Running Firefox (or its derivative) headlessly to generate default profiles because install.ini is not at the macOS default location.'
        timeout 14 "$FIREFOX_EXE" --headless || EXIT_CODE=$?
        gum log -sl info 'Finished running Firefox headlessly (while fixing the missing macOS installs.ini issue)'
      fi

      if [ -n "${EXIT_CODE:-}" ]; then
        gum log -sl info 'Encountered error while headlessly warming up Firefox - error does not seem to impact functionality'
      fi

      ### Ensure settings directory exists (since the application was brought up temporarily headlessly)
      if [ ! -d "$SETTINGS_DIR" ]; then
        gum log -sl warn "The settings directory located at $SETTINGS_DIR failed to be populated by running the browser headlessly"
        continue
      fi

      ### Add the populated profiles.ini
      gum log -sl info "Copying "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/profiles.ini" to profile directory"
      gum log -sl info "The settings directory is $SETTINGS_DIR"
      if [ -d /Applications ] && [ -d /System ]; then
        # macOS
        gum log -sl info "Copying ~/.local/share/firefox/profiles.ini to $SETTINGS_DIR/../profiles.ini"
        cp -f "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/profiles.ini" "$SETTINGS_DIR/../profiles.ini"
        SETTINGS_INI="$SETTINGS_DIR/../installs.ini"
      else
        # Linux
        gum log -sl info "Copying ~/.local/share/firefox/profiles.ini to $SETTINGS_DIR/profiles.ini"
        cp -f "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/profiles.ini" "$SETTINGS_DIR/profiles.ini"
        SETTINGS_INI="$SETTINGS_DIR/installs.ini"
      fi

      ### Default profile (created by launching Firefox headlessly)
      DEFAULT_RELEASE_PROFILE="$(find "$SETTINGS_DIR" -mindepth 1 -maxdepth 1 -name "*.default" -not -name "profile.default")"
      if [ -n "$DEFAULT_RELEASE_PROFILE" ]; then
        gum log -sl info "Syncing $DEFAULT_RELEASE_PROFILE to $SETTINGS_DIR/profile.default"
        rsync -a "$DEFAULT_RELEASE_PROFILE/" "$SETTINGS_DIR/profile.default"
      else
        gum log -sl warn 'Unable to sync default Mozilla Firefox profile'
      fi

      ### Ensure original installs.ini is removed
      if [ -f "$SETTINGS_INI" ]; then
        # DEFAULT_PROFILE_PROFILE="$SETTINGS_DIR/$(cat "$SETTINGS_INI" | grep 'Default=' | sed 's/.*Profiles\///')"
        gum log -sl info 'Removing previous installs.ini file'
        rm -f "$SETTINGS_INI"
      else
        gum log -sl info 'installs.ini was not present in the Mozilla Firefox settings folder'
      fi

      ### Miscellaneous default profiles
      for NEW_PROFILE in "automation" "development" "miscellaneous"; do
        if [ ! -d "$SETTINGS_DIR/profile.${NEW_PROFILE}" ] && [ -d "$SETTINGS_DIR/profile.default" ]; then
          gum log -sl info "Cloning $NEW_PROFILE from profile.default"
          rsync -a "$SETTINGS_DIR/profile.default/" "$SETTINGS_DIR/profile.${NEW_PROFILE}"
          rsync -a "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/" "$SETTINGS_DIR/profile.${NEW_PROFILE}"
          cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/firefox/user.js" "$SETTINGS_DIR/profile.${NEW_PROFILE}"
        fi
      done

      ### Public git profile
      if [ -d "$SETTINGS_DIR/profile.git" ]; then
        gum log -sl info 'Resetting the Firefox git profile'
        cd "$SETTINGS_DIR/profile.git"
        git reset --hard HEAD
        git clean -fxd
        gum log -sl info 'Pulling latest updates to the Firefox git profile'
        git pull origin master
      else
        gum log -sl info 'Cloning the public Firefox git profile'
        cd "$SETTINGS_DIR" && git clone "$(yq '.firefoxPublicProfile' "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoidata.yaml")" profile.git
      fi

      ### Copy user.js to profile.git profile
      cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/firefox/user.js" "$SETTINGS_DIR/profile.git"

      ### Git profile w/ plugins installed (installation happens below)
      if [ ! -d "$SETTINGS_DIR/profile.plugins" ]; then
        gum log -sl info "Syncing $SETTINGS_DIR/profile.git to $SETTINGS_DIR/profile.plugins"
        rsync -a "$SETTINGS_DIR/profile.git/" "$SETTINGS_DIR/profile.plugins"
        rsync -a "${XDG_DATA_HOME:-$HOME/.local/share}/firefox/" "$SETTINGS_DIR/profile.plugins"
        cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/firefox/user.js" "$SETTINGS_DIR/profile.plugins"
      fi

      ### Private hosted profile
      # Deprecated in favor of using the Restic profile tasks saved in `~/.config/task/Taskfile.yml`
      # if [ ! -d "$SETTINGS_DIR/profile.private" ]; then
      #     gum log -sl info 'Downloading the encrypted Firefox private profile'
      #     cd "$SETTINGS_DIR"
      #     curl -sSL '{ { .firefoxPrivateProfile } }' -o profile.private.tar.gz.age
      #     gum log -sl info 'Decrypting the Firefox private profile'
      #     chezmoi decrypt profile.private.tar.gz.age > profile.private.tar.gz || EXIT_DECRYPT_CODE=$?
      #     if [ -z "$EXIT_DECRYPT_CODE" ]; then
      #         rm -f profile.private.tar.gz.age
      #         gum log -sl info 'Decompressing the Firefox private profile'
      #         tar -xzf profile.private.tar.gz
      #         gum log -sl info 'The Firefox private profile was successfully installed'
      #         cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/firefox/user.js" "$SETTINGS_DIR/profile.private"
      #         gum log -sl info 'Copied ~/.config/firefox/user.js to profile.private profile'
      #     else
      #         gum log -sl error 'Failed to decrypt the private Firefox profile'
      #     fi
      # fi

      ### Install Firefox addons (using list declared in .chezmoidata.yaml)
      for SETTINGS_PROFILE in "profile.plugins" "profile.private"; do
        if [ -d "$SETTINGS_DIR/$SETTINGS_PROFILE" ]; then
          while read FIREFOX_PLUGIN; do
            gum log -sl info "Processing the $FIREFOX_PLUGIN Firefox add-on"
            PLUGIN_HTML="$(mktemp)"
            curl --silent "https://addons.mozilla.org/en-US/firefox/addon/$FIREFOX_PLUGIN/" > "$PLUGIN_HTML"
            PLUGIN_TMP="$(mktemp)"
            if ! command -v htmlq > /dev/null && command -v brew > /dev/null; then
              gum log -sl info 'Installing htmlq using Homebrew since it is a dependency for populating Firefox add-ons' && brew install htmlq
            fi
            cat "$PLUGIN_HTML" | htmlq '#redux-store-state' | sed 's/^<scri.*application\/json">//' | sed 's/<\/script>$//' > "$PLUGIN_TMP"
            PLUGIN_ID="$(jq '.addons.bySlug["'"$FIREFOX_PLUGIN"'"]' "$PLUGIN_TMP")"
            if [ "$PLUGIN_ID" != 'null' ]; then
              PLUGIN_FILE_ID="$(jq -r '.addons.byID["'"$PLUGIN_ID"'"].guid' "$PLUGIN_TMP")"
              if [ "$PLUGIN_FILE_ID" != 'null' ]; then
                PLUGIN_URL="$(cat "$PLUGIN_HTML" | htmlq '.InstallButtonWrapper-download-link' --attribute href)"
                PLUGIN_FILENAME="${PLUGIN_FILE_ID}.xpi"
                PLUGIN_FOLDER="$(echo "$PLUGIN_FILENAME" | sed 's/.xpi$//')"
                if [ ! -d "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions/$PLUGIN_FOLDER" ]; then
                  gum log -sl info 'Downloading add-on XPI file for '"$PLUGIN_FILENAME"' ('"$FIREFOX_PLUGIN"')'
                  if [ ! -d "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions" ]; then
                    mkdir -p "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions"
                  fi
                  curl -sSL "$PLUGIN_URL" -o "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions/$PLUGIN_FILENAME"
                  # Unzipping like this causes Firefox to complain about unsigned plugins
                  # TODO - figure out how to headlessly enable the extensions in such a way that is compatible with Flatpak / Snap
                  # using the /usr/lib/firefox/distribution/policies.json works but this is not compatible with Flatpak / Snap out of the box
                  # it seems since they do not have access to the file system by default. Also, using the policies.json approach forces
                  # all Firefox profiles to use the same extensions. Ideally, we should find a way to enable the extensions scoped
                  # to the user profile.
                  # gum log -sl info 'Unzipping '"$PLUGIN_FILENAME"' ('"$FIREFOX_PLUGIN"')'
                  # unzip "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions/$PLUGIN_FILENAME" -d "$SETTINGS_DIR/$SETTINGS_PROFILE/extensions/$PLUGIN_FOLDER"
                  gum log -sl info 'Installed '"$FIREFOX_PLUGIN"''
                fi
              else
                gum log -sl warn 'A null Firefox add-on filename was detected for '"$FIREFOX_PLUGIN"''
              fi
            else
              gum log -sl warn 'A null Firefox add-on ID was detected for '"$FIREFOX_PLUGIN"''
            fi
          done< <(yq '.firefoxAddOns[]' ~/.local/share/chezmoi/home/.chezmoidata.yaml)
        fi
      done
    fi
  done
}

firefoxSetup
