#!/usr/bin/env bash
# @file Rclone S3 Mounts
# @brief This script configures Rclone to provide several S3-compliant mounts by leveraging CloudFlare R2
# @description
#     Install Doctor leverages Rclone and CloudFlare R2 to provide S3-compliant bucket mounts that allow you to retain stateful files and configurations.
#     In general, these buckets are used for backing up files like your browser profiles, Docker backup files, and other files that cannot be stored as
#     as code in your Install Doctor fork.
#
#     This script sets up Rclone to provide several folders that are synchronized with S3-compliant buckets (using CloudFlare R2 by default).
#     The script ensures required directories are created and that proper permissions are applied. This script will only run if `rclone` is
#     available in the `PATH`. It also requires the user to provide `CLOUDFLARE_R2_SECRET` and `CLOUDFLARE_R2_SECRET` as either environment variables
#     or through the encrypted repository-fork-housed method detailed in the [Secrets documentation](https://install.doctor/docs/customization/secrets).
#
#     ## Mounts
#
#     The script will setup five mounts by default and enable / start `systemd` services on Linux systems so that the mounts are available
#     whenever the device is turned on. The mounts are:
#
#     | Mount Location        | Description                                                                                                           |
#     |-----------------------|-----------------------------------------------------------------------------------------------------------------------|
#     | `/mnt/Private`        | Private system-wide bucket used for any private files that should not be able to be accessed publicly over HTTPS      |
#     | `/mnt/Public`         | Public system-wide bucket that can be accessed by anyone over HTTPS with the bucket's URL (provided by CloudFlare R2) |
#     | N/A                   | Private system-wide bucket used for storing Docker-related backups / files                                            |
#     | N/A                   | Private system-wide bucket similar to `/mnt/Private` but intended for system file backups                             |
#     | `$HOME/Public` | Private user-specific bucket (used for backing up application settings)                                               |
#
#     ## Permissions
#
#     The system files are all assigned proper permissions and are owned by the user `rclone` with the group `rclone`. The exception to this is the
#     user-specific mount which uses the user's user name and user group.
#
#     ## Samba
#
#     If Samba is installed, then by default Samba will create two shares that are symlinked to the `/mnt/s3-private` and `/mnt/s3-public`
#     buckets. This feature allows you to easily access the two buckets from other devices in your local network. If Rclone buckets are not
#     available then the Samba setup script will just create regular empty folders as shares.
#
#     ## Notes
#
#     * The mount services all leverage the executable found at `$HOME/.local/bin/rclone-mount` to mount the shares.
#
#     ## Links
#
#     * [Rclone mount script](https://github.com/megabyte-labs/install.doctor/tree/master/home/dot_local/bin/executable_rclone-mount)
#     * [Rclone default configurations](https://github.com/megabyte-labs/install.doctor/tree/master/home/dot_config/rclone)
#     * [Rclone documentation](https://rclone.org/docs/)

set -euo pipefail

### Acquire CLOUDFLARE_R2_ID
if [ -z "$CLOUDFLARE_R2_ID" ]; then
  CLOUDFLARE_R2_ID_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/CLOUDFLARE_R2_ID"
  if [ -f "$CLOUDFLARE_R2_ID_FILE" ]; then
    logg info "Found CLOUDFLARE_R2_ID in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
      logg info 'Decrypting CLOUDFLARE_R2_ID token with Age encryption key'
      CLOUDFLARE_R2_ID="$(cat "$CLOUDFLARE_R2_ID_FILE" | chezmoi decrypt)"
    else
      logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
      exit 1
    fi
  else
    logg warn "CLOUDFLARE_R2_ID is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    exit 1
  fi
else
  logg info 'CLOUDFLARE_R2_ID provided as environment variable'
fi

### Acquire CLOUDFLARE_R2_SECRET
if [ -z "$CLOUDFLARE_R2_SECRET" ]; then
  CLOUDFLARE_R2_SECRET_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/CLOUDFLARE_R2_SECRET"
  if [ -f "$CLOUDFLARE_R2_SECRET_FILE" ]; then
    logg info "Found CLOUDFLARE_R2_SECRET in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
      logg info 'Decrypting CLOUDFLARE_R2_SECRET token with Age encryption key'
      CLOUDFLARE_R2_SECRET="$(cat "$CLOUDFLARE_R2_SECRET_FILE" | chezmoi decrypt)"
    else
      logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
      exit 1
    fi
  else
    logg warn "CLOUDFLARE_R2_SECRET is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    exit 1
  fi
else
  logg info 'CLOUDFLARE_R2_SECRET provided as environment variable'
fi

### Acquire CLOUDFLARE_R2_ID_USER
if [ -z "$CLOUDFLARE_R2_ID_USER" ]; then
  CLOUDFLARE_R2_ID_USER_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/CLOUDFLARE_R2_ID_USER"
  if [ -f "$CLOUDFLARE_R2_ID_USER_FILE" ]; then
    logg info "Found CLOUDFLARE_R2_ID_USER in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
      logg info 'Decrypting CLOUDFLARE_R2_ID_USER token with Age encryption key'
      CLOUDFLARE_R2_ID_USER="$(cat "$CLOUDFLARE_R2_ID_USER_FILE" | chezmoi decrypt)"
    else
      logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
      exit 1
    fi
  else
    logg warn "CLOUDFLARE_R2_ID_USER is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    exit 1
  fi
else
  logg info 'CLOUDFLARE_R2_ID_USER provided as environment variable'
fi

### Acquire CLOUDFLARE_R2_SECRET_USER
if [ -z "$CLOUDFLARE_R2_SECRET_USER" ]; then
  CLOUDFLARE_R2_SECRET_USER_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/CLOUDFLARE_R2_SECRET_USER"
  if [ -f "$CLOUDFLARE_R2_SECRET_USER_FILE" ]; then
    logg info "Found CLOUDFLARE_R2_SECRET_USER in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
      logg info 'Decrypting CLOUDFLARE_R2_SECRET_USER token with Age encryption key'
      CLOUDFLARE_R2_SECRET_USER="$(cat "$CLOUDFLARE_R2_SECRET_USER_FILE" | chezmoi decrypt)"
    else
      logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
      exit 1
    fi
  else
    logg warn "CLOUDFLARE_R2_SECRET_USER is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    exit 1
  fi
else
  logg info 'CLOUDFLARE_R2_SECRET_USER provided as environment variable'
fi

### Begin configuration
if command -v rclone > /dev/null; then
  R2_ENDPOINT="$(yq '.data.user.cloudflare.r2' "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml")"
  if [ "$R2_ENDPOINT" != 'null' ]; then
    logg info 'Removing ~/.config/rclone/rclone.conf Install Doctor managed block'
    CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/rclone/rclone.conf"
    if cat "$CONFIG_FILE" | grep '# INSTALL DOCTOR MANAGED S3 START' > /dev/null; then
      # TODO: Remove old block
      START_LINE="$(echo `grep -n -m 1 "# INSTALL DOCTOR MANAGED S3 START" "$CONFIG_FILE" | cut -f1 -d ":"`)"
      END_LINE="$(echo `grep -n -m 1 "# INSTALL DOCTOR MANAGED S3 END" "$CONFIG_FILE" | cut -f1 -d ":"`)"
      if command -v gsed > /dev/null; then
        gsed -i "$START_LINE,${END_LINE}d" "$CONFIG_FILE" > /dev/null
      else
        sed -i "$START_LINE,${END_LINE}d" "$CONFIG_FILE" > /dev/null
      fi
    fi
    logg info 'Adding ~/.config/rclone/rclone.conf INSTALL DOCTOR managed block'
    tee -a "$CONFIG_FILE" > /dev/null <<EOT
# INSTALL DOCTOR MANAGED S3 START
[User-$USER]
access_key_id = ${CLOUDFLARE_R2_ID_USER}
acl = private
endpoint = ${R2_ENDPOINT}.r2.cloudflarestorage.com
provider = Cloudflare
region = auto
secret_access_key = ${CLOUDFLARE_R2_SECRET_USER}
type = s3
# INSTALL DOCTOR MANAGED S3 END
EOT
  fi

  ### Add user / group with script in ~/.local/bin/add-usergroup, if it is available
  if command -v add-usergroup > /dev/null; then
    sudo add-usergroup rclone rclone
    sudo add-usergroup "$USER" rclone
  fi

  ### User config file permissions
  sudo chmod -f 600 "$CONFIG_FILE"
  sudo chown -f "$USER:rclone" "$CONFIG_FILE"

  ### Setup /var/cache/rclone
  logg info 'Ensuring /var/cache/rclone exists'
  sudo mkdir -p /var/cache/rclone
  sudo chmod 750 /var/cache/rclone
  sudo chown -Rf rclone:rclone /var/cache/rclone

  ### Setup /var/log/rclone
  logg info 'Ensuring /var/log/rclone exists'
  sudo mkdir -p /var/log/rclone
  sudo chmod 750 /var/log/rclone
  sudo chown -Rf rclone:rclone /var/log/rclone

  ### Add rclone-mount to /usr/local/bin
  logg info 'Adding ~/.local/bin/rclone-mount to /usr/local/bin'
  sudo cp -f "$HOME/.local/bin/rclone-mount" /usr/local/bin/rclone-mount
  sudo chmod +x /usr/local/bin/rclone-mount

  ### Setup /etc/rcloneignore
  logg info 'Adding ~/.config/rclone/rcloneignore to /etc/rcloneignore'
  sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/rcloneignore" /etc/rcloneignore
  sudo chown -Rf rclone:rclone /etc/rcloneignore
  sudo chmod 640 /etc/rcloneignore

  ### Setup /etc/rclone.conf
  logg info 'Adding ~/.config/rclone/system-rclone.conf to /etc/rclone.conf'
  sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/system-rclone.conf" /etc/rclone.conf
  sudo chown -Rf rclone:rclone /etc/rclone.conf
  sudo chmod 600 /etc/rclone.conf

  if [ -d /Applications ] && [ -d /System ]; then
    ### Enable Rclone mounts
    logg info 'Ensuring Rclone mount-on-reboot definitions are in place'
    sudo mkdir -p /Library/LaunchDaemons

    ### rclone.private.plist
    sudo cp -f "$HOME/Library/LaunchDaemons/rclone.private.plist" '/Library/LaunchDaemons/rclone.private.plist'
    logg info 'Ensuring rclone.private.plist service is started'
    if sudo launchctl list | grep 'rclone.private.plist' > /dev/null; then
      logg info 'Unloading previous rclone.private.plist configuration'
      sudo launchctl unload /Library/LaunchDaemons/rclone.private.plist
    fi
    logg info 'Starting up rclone.private.plist configuration'
    sudo launchctl load -w /Library/LaunchDaemons/rclone.private.plist

    ### rclone.public.plist
    sudo cp -f "$HOME/Library/LaunchDaemons/rclone.public.plist" '/Library/LaunchDaemons/rclone.public.plist'
    logg info 'Ensuring rclone.public.plist service is started'
    if sudo launchctl list | grep 'rclone.public.plist' > /dev/null; then
      logg info 'Unloading previous rclone.public.plist configuration'
      sudo launchctl unload /Library/LaunchDaemons/rclone.public.plist
    fi
    logg info 'Starting up rclone.public.plist configuration'
    sudo launchctl load -w /Library/LaunchDaemons/rclone.public.plist

    ### rclone.user.plist
    sudo cp -f "$HOME/Library/LaunchDaemons/rclone.user.plist" '/Library/LaunchDaemons/rclone.user.plist'
    logg info 'Ensuring rclone.user.plist service is started'
    if sudo launchctl list | grep 'rclone.user.plist' > /dev/null; then
      logg info 'Unloading previous rclone.user.plist configuration'
      sudo launchctl unload /Library/LaunchDaemons/rclone.user.plist
    fi
    logg info 'Starting up rclone.user.plist configuration'
    sudo launchctl load -w "$HOME/Library/LaunchDaemons/rclone.user.plist"
  elif [ -d /etc/systemd/system ]; then
    find "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/system" -mindepth 1 -maxdepth 1 -type f | while read RCLONE_SERVICE; do
      ### Add systemd service file
      logg info "Adding S3 system mount service defined at $RCLONE_SERVICE"
      FILENAME="$(basename "$RCLONE_SERVICE")"
      SERVICE_ID="$(echo "$FILENAME" | sed 's/.service//')"
      sudo cp -f "$RCLONE_SERVICE" "/etc/systemd/system/$(basename "$RCLONE_SERVICE")"

      ### Ensure mount folder is created
      logg info "Ensuring /mnt/$SERVICE_ID is created with proper permissions"
      sudo mkdir -p "/mnt/$SERVICE_ID"
      sudo chmod 750 "/mnt/$SERVICE_ID"

      ### Enable / restart the service
      logg info "Enabling / restarting the $SERVICE_ID S3 service"
      sudo systemctl enable "$SERVICE_ID"
      sudo systemctl restart "$SERVICE_ID"
    done

    ### Add user Rclone mount
    logg info 'Adding user S3 rclone mount (available at ~/Cloud/User and /Volumes/User)'
    sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/s3-user.service" "/etc/systemd/system/s3-${USER}.service"
    logg info 'Enabling / restarting the S3 user mount'
    sudo systemctl enable "s3-${USER}"
    sudo systemctl restart "s3-${USER}"
  fi
else
  logg info 'rclone is not available'
fi