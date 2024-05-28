#!/usr/bin/env bash
# @file JuiceFS
# @brief Mounts various S3-backed storage volumes (assuming correct secrets are in place)
# @description
#     This script handles the mounting of various S3-backed storage volumes via [JuiceFS](https://juicefs.com/en/).
#     The script will attempt to mount four different S3 volumes:
#
#     1. `public-{ { .juicefsVolumeNamePostfix } }`
#     2. `private-{ { .juicefsVolumeNamePostfix } }`
#     3. `docker-{ { .juicefsVolumeNamePostfix } }`
#     4. `user-{ { .juicefsVolumeNamePostfix } }`
#
#     Where `{ { .juicefsVolumeNamePostfix } }` is replaced with the name stored in `home/.chezmoidata.yaml`.
#     When creating the four volumes in the [JuiceFS console](https://juicefs.com/console/), it is important that you name the volumes using
#     these four volume names.

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

MOUNT_FOLDER="/mnt"
UPDATE_FSTAB="--update-fstab"
if [ -d /Applications ] && [ -d /System ]; then
  ### macOS
  MOUNT_FOLDER="/Volumes"
  UPDATE_FSTAB=""
elif [ -f /snap/juicefs/current/juicefs ]; then
  gum log -sl info 'Symlinking /snap/juicefs/current/juicefs to /snap/bin/juicefs' && sudo ln -s -f /snap/juicefs/current/juicefs /snap/bin/juicefs
fi

gum log -sl info "Acquiring juicefsVolumeNamePostfix from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoidata.yaml"
JUICEFS_VOLUME_PREFIX="$(yq '.juicefsVolumeNamePostfix' "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoidata.yaml")"
for MOUNT_NAME in "docker" "private" "public" "user"; do
  if [ "$MOUNT_NAME" == "user" ]; then
    sudo juicefs mount --enable-xattr -o user_id="$(id -u "$USER")",group_id="$(id -g "$USER")" --conf-dir "${XDG_CONFIG_HOME:-$HOME/.config}/juicefs" -b $UPDATE_FSTAB "${JUICEFS_VOLUME_PREFIX}-${MOUNT_NAME}" "$HOME/.local/jfs"
  else
    sudo juicefs mount --enable-xattr --conf-dir /root/.juicefs $UPDATE_FSTAB -b "${JUICEFS_VOLUME_PREFIX}-${MOUNT_NAME}" "${MOUNT_FOLDER}/jfs-${MOUNT_NAME}"
  fi
done

### Linux systemd
if command -v systemctl > /dev/null; then
  gum log -sl info 'Ensuring /etc/systemd/system/docker.service.d exists as a directory' && sudo mkdir -p /etc/systemd/system/docker.service.d
  gum log -sl info 'Creating /etc/systemd/system/docker.service.d/override.conf which ensures JuiceFS is loaded before Docker starts'
  echo '[Unit]' | sudo tee /etc/systemd/system/docker.service.d/override.conf
  echo 'After=network-online.target firewalld.service containerd.service jfs.mount' | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
fi
