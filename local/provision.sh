#!/usr/bin/env bash

# @file local/provision.sh
# @brief Installs dependencies, clones the Sexy Start repository, and then starts Chezmoi
# @description
#   This script ensures Chezmoi, Glow, and Gum are installed. It also includes logging functions for styled logging.
#   After dependencies are installed, it adds the necessary files from https://gitlab.com/megabyte-labs/sexy-start.git into
#   ~/.local/share/chezmoi. Finally, it begins the TUI experience by displaying styled documentation, prompts, and finishes
#   by calling the appropriate Chezmoi commands.

### Ensure ~/.local/share/megabyte-labs is a directory
if [ ! -d "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs" ]; then
  mkdir -p "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs"
fi

# @description Installs glow (a markdown renderer) from GitHub releases
# @example installGlow
installGlow() {
  # TODO: Add support for other architecture types
  if [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; then
    GLOW_DOWNLOAD_URL="https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_Darwin_x86_64.tar.gz"
  elif [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
    GLOW_DOWNLOAD_URL="https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_linux_x86_64.tar.gz"
  fi
  if type curl &> /dev/null; then
    if { [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; } || [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
      TMP="$(mktemp)"
      TMP_DIR="$(dirname "$TMP")"
      curl -sSL "$GLOW_DOWNLOAD_URL" > "$TMP"
      tar -xzf "$TMP" -C "$TMP_DIR"
      if [ -n "$HOME" ]; then
        if mkdir -p "$HOME/.local/bin" && mv "$TMP_DIR/glow" "$HOME/.local/bin/glow"; then
          GLOW_PATH="$HOME/.local/bin/glow"
        else
          GLOW_PATH="$(dirname "${BASH_SOURCE[0]}")/glow"
          mv "$TMP_DIR/gum" "$GLOW_PATH"
        fi
        chmod +x "$GLOW_PATH"
      else
        echo "WARNING: The HOME environment variable is not set! (Glow)"
      fi
    else
      echo "WARNING: Unable to detect system type. (Glow)"
    fi
  fi
}

# @description Installs gum (a logging CLI) from GitHub releases
# @example installGum
installGum() {
  # TODO: Add support for other architecture types
  if [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; then
    GUM_DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v0.4.0/gum_0.4.0_Darwin_x86_64.tar.gz"
  elif [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
    GUM_DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v0.4.0/gum_0.4.0_linux_x86_64.tar.gz"
  fi
  if type curl &> /dev/null; then
    if { [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; } || [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
      TMP="$(mktemp)"
      TMP_DIR="$(dirname "$TMP")"
      curl -sSL "$GUM_DOWNLOAD_URL" > "$TMP"
      tar -xzf "$TMP" -C "$TMP_DIR"
      if [ -n "$HOME" ]; then
        if mkdir -p "$HOME/.local/bin" && mv "$TMP_DIR/gum" "$HOME/.local/bin/gum"; then
          GUM_PATH="$HOME/.local/bin/gum"
        else
          GUM_PATH="$(dirname "${BASH_SOURCE[0]}")/gum"
          mv "$TMP_DIR/gum" "$GLOW_PATH"
        fi
        chmod +x "$GUM_PATH"
      else
        echo "WARNING: The HOME environment variable is not set! (Gum)"
      fi
    else
      echo "WARNING: Unable to detect system type. (Gum)"
    fi
  fi
}

# @description Configure the logger to use echo or gum
if [ "${container:=}" != 'docker' ]; then
  # Acquire gum's path or attempt to install it
  if type gum &> /dev/null; then
    GUM_PATH="$(which gum)"
  elif [ -f "$HOME/.local/bin/gum" ]; then
    GUM_PATH="$HOME/.local/bin/gum"
  elif [ -f "$(dirname "${BASH_SOURCE[0]}")/gum" ]; then
    GUM_PATH="$(dirname "${BASH_SOURCE[0]}")/gum"
  elif type brew &> /dev/null; then
    brew install gum
    GUM_PATH="$(which gum)"
  else
    if ! command -v qubesctl > /dev/null; then
      # Qubes dom0
      installGum
    fi
  fi

  # If gum's path was set, then turn on enhanced logging
  if [ -n "$GUM_PATH" ]; then
    chmod +x "$GUM_PATH"
  fi
fi

format() {
  # shellcheck disable=SC2001,SC2016
  ANSI_STR_FORMATTED="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`.*/\1\\u001b[47;30m \2 \\e[49;m/')"
  # shellcheck disable=SC2001,SC2016
  ANSI_STR="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`\(.*\)$/\3/')"
  if [ "$ANSI_STR_FORMATTED" != "$ANSI_STR" ]; then
    if [[ $ANSI_STR == *'`'*'`'* ]]; then
      ANSI_STR_FORMATTED="$ANSI_STR_FORMATTED$(format "$("$GUM_PATH" style --bold "$ANSI_STR")")"
    else
      ANSI_STR_FORMATTED="$ANSI_STR_FORMATTED$("$GUM_PATH" style --bold "$ANSI_STR")"
    fi
  fi
  echo -e "$ANSI_STR_FORMATTED"
}

formatFaint() {
  # shellcheck disable=SC2001,SC2016
  ANSI_STR_FORMATTED="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`.*/\1\\u001b[47;30m \2 \\e[49;m/')"
  # shellcheck disable=SC2001,SC2016
  ANSI_STR="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`\(.*\)$/\3/')"
  if [ "$ANSI_STR_FORMATTED" != "$ANSI_STR" ]; then
    if [[ $ANSI_STR == *'`'*'`'* ]]; then
      ANSI_STR_FORMATTED="$ANSI_STR_FORMATTED$(formatFaint "$("$GUM_PATH" style --faint "$ANSI_STR")")"
    else
      ANSI_STR_FORMATTED="$ANSI_STR_FORMATTED$("$GUM_PATH" style --faint "$ANSI_STR")"
    fi
  fi
  echo -e "$ANSI_STR_FORMATTED"
}

# @description Logs using Node.js
# @example logger info "An informative log"
logg() {
  TYPE="$1"
  MSG="$2"
  if [ "$TYPE" == 'error' ]; then
    "$GUM_PATH" style --border="thick" "$("$GUM_PATH" style --foreground="#ff0000" "✖") $("$GUM_PATH" style --bold --background="#ff0000" --foreground="#ffffff"  " ERROR ") $("$GUM_PATH" style --bold "$(format "$MSG")")"
  elif [ "$TYPE" == 'info' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ffff" "○") $("$GUM_PATH" style --faint "$(formatFaint "$MSG")")"
  elif [ "$TYPE" == 'md' ]; then
    # @description Ensure glow is installed
    if [ "${container:=}" != 'docker' ]; then
      if type glow &> /dev/null; then
        GLOW_PATH="$(which glow)"
      elif [ -f "$HOME/.local/bin/glow" ]; then
        GLOW_PATH="$HOME/.local/bin/glow"
      elif [ -f "$(dirname "${BASH_SOURCE[0]}")/glow" ]; then
        GLOW_PATH="$(dirname "${BASH_SOURCE[0]}")/glow"
      elif type brew &> /dev/null; then
        brew install glow
        GLOW_PATH="$(which glow)"
      else
        if ! command -v qubesctl > /dev/null; then
          # Qubes dom0
          installGlow
        fi
      fi

      if [ -n "$GLOW_PATH" ]; then
        chmod +x "$GLOW_PATH"
      fi
    fi
    "$GLOW_PATH" "$MSG"
  elif [ "$TYPE" == 'prompt' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00008b" "▶") $("$GUM_PATH" style --bold "$(format "$MSG")")"
  elif [ "$TYPE" == 'star' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#d1d100" "◆") $("$GUM_PATH" style --bold "$(format "$MSG")")"
  elif [ "$TYPE" == 'start' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ff00" "▶") $("$GUM_PATH" style --bold "$(format "$MSG")")"
  elif [ "$TYPE" == 'success' ]; then
    "$GUM_PATH" style "$("$GUM_PATH" style --foreground="#00ff00" "✔")  $("$GUM_PATH" style --bold "$(format "$MSG")")"
  elif [ "$TYPE" == 'warn' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#d1d100" "◆") $("$GUM_PATH" style --bold --background="#ffff00" --foreground="#000000"  " WARNING ") $("$GUM_PATH" style --bold "$(format "$MSG")")"
  else
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ff00" "▶") $("$GUM_PATH" style --bold "$(format "$TYPE")")"
  fi
}

### Qubes dom0
if command -v qubesctl > /dev/null; then
  # The VM name that will manage the Ansible provisioning (for Qubes dom0)
  ANSIBLE_PROVISION_VM="provision"

  # Ensure sys-whonix is configured (for Qubes dom0)
  CONFIG_WIZARD_COUNT=0
  function configureWizard() {
    if xwininfo -root -tree | grep "Anon Connection Wizard"; then
      WINDOW_ID="$(xwininfo -root -tree | grep "Anon Connection Wizard" | sed 's/^ *\([^ ]*\) .*/\1/')"
      xdotool windowactivate "$WINDOW_ID" && sleep 1 && xdotool key 'Enter' && sleep 1 && xdotool key 'Tab Tab Enter' && sleep 24 && xdotool windowactivate "$WINDOW_ID" && sleep 1 && xdotool key 'Enter' && sleep 300
      qvm-shutdown --wait sys-whonix
      sleep 3
      qvm-start sys-whonix
      if xwininfo -root -tree | grep "systemcheck | Whonix" > /dev/null; then
        WINDOW_ID_SYS_CHECK="$(xwininfo -root -tree | grep "systemcheck | Whonix" | sed 's/^ *\([^ ]*\) .*/\1/')"
        if xdotool windowactivate "$WINDOW_ID_SYS_CHECK"; then
          sleep 1
          xdotool key 'Enter'
        fi
      fi
    else
      sleep 3
      CONFIG_WIZARD_COUNT=$((CONFIG_WIZARD_COUNT + 1))
      if [[ "$CONFIG_WIZARD_COUNT" == '4' ]]; then
        echo "The sys-whonix anon-connection-wizard utility did not open."
      else
        echo "Checking for anon-connection-wizard again.."
        configureWizard
      fi
    fi
  }

  ### Ensure dom0 is updated
  if [ ! -f /root/dom0-updated ]; then
    sudo qubesctl --show-output state.sls update.qubes-dom0
    sudo qubes-dom0-update --clean -y
    touch /root/dom0-updated
  fi

  ### Ensure sys-whonix is running
  if ! qvm-check --running sys-whonix; then
    qvm-start sys-whonix --skip-if-running
    configureWizard > /dev/null
  fi

  ### Ensure TemplateVMs are updated
  if [ ! -f /root/templatevms-updated ]; then
    # timeout of 10 minutes is added here because the whonix-gw VM does not like to get updated
    # with this method. Anyone know how to fix this?
    sudo timeout 600 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm &> /dev/null || true
    while read -r RESTART_VM; do
      qvm-shutdown --wait "$RESTART_VM"
    done< <(qvm-ls --all --no-spinner --fields=name,state | grep Running | grep -v sys-net | grep -v sys-firewall | grep -v sys-whonix | grep -v dom0 | awk '{print $1}')
    sudo touch /root/templatevms-updated
  fi

  ### Ensure provisioning VM can run commands on any VM
  echo "/bin/bash" | sudo tee /etc/qubes-rpc/qubes.VMShell
  sudo chmod 755 /etc/qubes-rpc/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' dom0 allow' | sudo tee /etc/qubes-rpc/policy/qubes.VMShell
  # shellcheck disable=SC2016
  echo "$ANSIBLE_PROVISION_VM"' $anyvm allow' | sudo tee -a /etc/qubes-rpc/policy/qubes.VMShell
  sudo chown "$(whoami):$(whoami)" /etc/qubes-rpc/policy/qubes.VMShell
  sudo chmod 644 /etc/qubes-rpc/policy/qubes.VMShell


  ### Create provisioning VM and initialize the provisioning process from there
  qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || true
  qvm-volume extend "$ANSIBLE_PROVISION_VM:private" "40G"
  if [ -f ~/.vaultpass ]; then
    qvm-run "$ANSIBLE_PROVISION_VM" 'rm -f ~/QubesIncoming/dom0/.vaultpass'
    qvm-copy-to-vm "$ANSIBLE_PROVISION_VM" ~/.vaultpass
    qvm-run "$ANSIBLE_PROVISION_VM" 'cp ~/QubesIncoming/dom0/.vaultpass ~/.vaultpass'
  fi
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" 'curl -sSL https://install.doctor/start > ~/start.sh && bash ~/start.sh'
  exit 0
fi

### Source Homebrew if it installed but not in PATH
if ! command -v brew > /dev/null && [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v brew > /dev/null || ! command -v rsync > /dev/null || ! command -v unbuffer > /dev/null; then
  # shellcheck disable=SC2016
  logg info 'Ensuring `curl`, `expect`, `git`, and `rsync` are installed via the system package manager'
  if command -v apt-get > /dev/null; then
    # Debian / Ubuntu
    sudo apt-get update
    sudo apt-get install -y build-essential curl expect git rsync
  elif command -v dnf > /dev/null; then
    # Fedora
    sudo dnf install -y curl expect git rsync
  elif command -v yum > /dev/null; then
    # CentOS
    sudo yum install -y curl expect git rsync
  elif command -v pacman > /dev/null; then
    # Archlinux
    sudo pacman update
    sudo pacman -Sy curl expect git rsync
  elif command -v zypper > /dev/null; then
    # OpenSUSE
    sudo zypper install -y curl expect git rsync
  elif command -v apk > /dev/null; then
    # Alpine
    apk add curl expect git rsync
  elif [ -d /Applications ] && [ -d /Library ]; then
    # macOS
    sudo xcode-select -p >/dev/null 2>&1 || xcode-select --install
  elif command -v nix-env > /dev/null; then
    # NixOS
    echo "TODO - Add support for NixOS"
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    # FreeBSD
    echo "TODO - Add support for FreeBSD"
  elif command -v pkg > /dev/null; then
    # Termux
    echo "TODO - Add support for Termux"
  elif command -v xbps-install > /dev/null; then
    # Void
    echo "TODO - Add support for Void"
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    # Windows
    choco install -y curl expect git node rsync
  fi
fi

### Install Homebrew
ensurePackageManagerHomebrew() {
  if ! command -v brew > /dev/null; then
    logg info 'Installing Homebrew'
    if command -v sudo > /dev/null && sudo -n true; then
      echo | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install gcc
      fi
    else
      logg info 'Looks like the user does not have passwordless sudo privileges. A sudo password may be required.'
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
      if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install gcc
      fi
      if [ -n "$BREW_EXIT_CODE" ]; then
        if command -v brew > /dev/null; then
          logg warn 'Homebrew was installed but part of the installation failed. Attempting to fix..'
          BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
          for BREW_DIR in $BREW_DIRS; do
            if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
              sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
            fi
          done
          brew update --force --quiet
        fi
      fi
    fi
  fi
}
ensurePackageManagerHomebrew

### Install installer dependencies via Homebrew
installBrewPackage() {
  if ! command -v "$1" > /dev/null; then
    logg 'Installing `'"$1"'`'
    brew install "$1"
  fi
}
if command -v brew > /dev/null; then
  installBrewPackage chezmoi
  installBrewPackage glow
  installBrewPackage gum
  installBrewPackage node
  installBrewPackage zx
fi

### Clones the source repository
cloneStart() {
  logg info "Cloning ${START_REPO:-https://gitlab.com/megabyte-labs/sexy-start.git} to /usr/local/src/sexy-start"
  rm -rf /usr/local/src/sexy-start
  sudo git clone ${START_REPO:-https://gitlab.com/megabyte-labs/sexy-start.git} /usr/local/src/sexy-start
  chown -Rf "$USER":"$(id -g -n)" /usr/local/src/sexy-start
}

### Ensure source files are present
logg 'Ensuring /usr/local/src/sexy-start is owned by the user'
if [ -d /usr/local/src/sexy-start ] && [ ! -w /usr/local/src/sexy-start ]; then
  sudo chown -Rf "$USER":"$(id -g -n)" /usr/local/src/sexy-start
fi
if [ -d /usr/local/src/sexy-start/.git ]; then
  cd /usr/local/src/sexy-start || exit 1
  if [ "$(git remote get-url origin)" == 'https://gitlab.com/megabyte-labs/sexy-start.git' ]; then
    logg info "Pulling the latest changes from ${START_REPO:-https://gitlab.com/megabyte-labs/sexy-start.git} to /usr/local/src/sexy-start"
    git config pull.rebase false
    git reset --hard HEAD
    git clean -fxd
    git pull origin master
  else
    logg info "The repository's origin URL has changed so /usr/local/src/sexy-start will be removed and re-cloned using the origin specified by the START_REPO variable"
    cloneStart
  fi
else
  cloneStart
fi

### Copy new files from src git repository to dotfiles with rsync
rsyncChezmoiFiles() {
  rsync -rtvu --delete /usr/local/src/sexy-start/docs/ "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/docs/" &
  rsync -rtvu --delete /usr/local/src/sexy-start/home/ "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/home/" &
  rsync -rtvu --delete /usr/local/src/sexy-start/system/ "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/system/" &
  rsync -rtvu /usr/local/src/sexy-start/.chezmoiignore "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/.chezmoiignore" &
  rsync -rtvu /usr/local/src/sexy-start/.chezmoiroot "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/.chezmoiroot" &
  rsync -rtvu /usr/local/src/sexy-start/software.yml "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi/software.yml" &
  wait
  logg success 'Successfully updated the ~/.local/share/chezmoi folder with changes from the upstream repository'
}

### Copy files to HOME folder with rsync
logg info 'Copying files from /usr/local/src/sexy-start to the HOME directory via rsync'
mkdir -p "${XDG_DATA_DIR:-$HOME/.local/share}/chezmoi"
rsyncChezmoiFiles
### Ensure ~/.local/bin files are executable
logg info 'Ensuring scripts in ~/.local/bin are executable'
find "$HOME/.local/bin" -maxdepth 1 -mindepth 1 -type f | while read -r BINFILE; do
  chmod +x "$BINFILE"
done

### Run chezmoi init
if [ ! -f "$HOME/.config/chezmoi/chezmoi.yaml" ]; then
  ### Show README.md snippet
  if command -v glow > /dev/null; then
    glow "$HOME/.local/share/chezmoi/docs/CHEZMOI-INTRO.md"
  fi

  ### Prompt for variables
  if command -v gum > /dev/null; then
    if [ -z "$SOFTWARE_GROUP" ]; then
      logg prompt 'Select the software group you would like to install. If your environment is a macOS, Windows, or environment with the DISPLAY environment variable then desktop software will be installed too. The software groups are in the ~/.local/share/chezmoi/home/.chezmoidata.yaml file.'
      SOFTWARE_GROUP="$(gum choose "Basic" "Standard" "Full")"
      export SOFTWARE_GROUP
    fi
  fi
  # shellcheck disable=SC2016
  logg info 'Running `chezmoi init` since the ~/.config/chezmoi/chezmoi.yaml is not present'
  chezmoi init
fi

### Ensure Debian noninteractive mode
export DEBIAN_FRONTEND=noninteractive

### Run chezmoi apply
# shellcheck disable=SC2016
logg info 'Running `chezmoi apply`'
if [ "$DEBUG_MODE" == 'true' ]; then
  DEBUG_MODIFIER="-vvvvv"
else
  DEBUG_MODIFIER=""
fi
if [ -n "$FORCE_CHEZMOI" ]; then
  if command -v unbuffer > /dev/null; then
    unbuffer -p chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log"
  else
    chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log"
  fi
else
  if command -v unbuffer > /dev/null; then
    unbuffer -p chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log"
  else
    chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "${XDG_DATA_DIR:-$HOME/.local/share}/megabyte-labs/betelgeuse.$(date +%s).log"
  fi
fi
