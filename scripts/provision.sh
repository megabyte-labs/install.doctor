#!/usr/bin/env bash
# @file Quick Start
# @brief Main entry point for Install Doctor that ensures Homebrew and a few dependencies are installed before cloning the repository and running Chezmoi.
# @description
#     This script ensures Homebrew is installed and then installs a few dependencies that Install Doctor relies on.
#     After setting up the minimal amount of changes required, it clones the Install Doctor repository (which you
#     can customize the location of so you can use your own fork). It then proceeds by handing things over to
#     Chezmoi which handles the dotfile application and synchronous scripts. Task is used in conjunction with
#     Chezmoi to boost the performance in some spots by introducing asynchronous features.
#
#     **Note**: `https://install.doctor/start` points to this file.
#
#     ## Dependencies
#
#     The chart below shows the dependencies we rely on to get Install Doctor going. The dependencies that are bolded
#     are mandatory. The ones that are not bolded are conditionally installed only if they are required.
#
#     | Dependency         | Description                                                                          |
#     |--------------------|--------------------------------------------------------------------------------------|
#     | **Chezmoi**        | Dotfile configuration manager (on-device provisioning)                               |
#     | **Task**           | Task runner used on-device for task parallelization and dependency management        |
#     | **ZX / Node.js**   | ZX is a Node.js abstraction that allows for better scripts                           |
#     | Gum                | Gum is a terminal UI prompt CLI (which allows sweet, interactive prompts)            |
#     | Glow               | Glow is a markdown renderer used for applying terminal-friendly styled to markdown   |
#
#     There are also a handful of system packages that are installed like `curl` and `git`. Then, during the Chezmoi provisioning
#     process, there are a handful of system packages that are installed to ensure things run smoothly. You can find more details
#     about these extra system packages by browsing through the `home/.chezmoiscripts/${DISTRO_ID}/` folder and other applicable
#     folders (e.g. `universal`).
#
#     Although Install Doctor comes with presets that install a whole gigantic amount of software, it can actually
#     be quite good at provisioning minimal server environments where you want to keep the binaries to a minimum.
#
#     ## Variables
#
#     Specify certain environment variables to customize the behavior of Install Doctor. With the right combination of
#     environment variables, this script can be run completely headlessly. This allows us to do things like test our
#     provisioning script on a wide variety of operating systems.
#
#     | Variable               | Description                                                                       |
#     |------------------------|-----------------------------------------------------------------------------------|
#     | `START_REPO` (or `REPO`)           | Variable to specify the Git fork to use when provisioning                         |
#     | `ANSIBLE_PROVISION_VM` | **For Qubes**, determines the name of the VM used to provision the system         |
#     | `DEBUG_MODE`           | Set to true to enable verbose logging                                             |
#
#     For a full list of variables you can use to customize Install Doctor, check out our [Customization](https://install.doctor/docs/customization)
#     and [Secrets](https://install.doctor/docs/customization/secrets) documentation.
#
#     ## Links
#
#     [Install Doctor homepage](https://install.doctor)
#     [Install Doctor documentation portal](https://install.doctor/docs) (includes tips, tricks, and guides on how to customize the system to your liking)

# @description Ensure Ubuntu / Debian run in `noninteractive` mode
export DEBIAN_FRONTEND=noninteractive

# @description Load default settings if it is in a CI setting
if [ -n "$CI" ]; then
  export HOST="$HOST"
  export NO_RESTART=true
  export HEADLESS_INSTALL=true
  export SOFTWARE_GROUP="Full"
  export FULL_NAME="Brian Zalewski"
  export PRIMARY_EMAIL="help@megabyte.space"
  export PUBLIC_SERVICES_DOMAIN="megabyte.space"
  export RESTRICTED_ENVIRONMENT=false
  export WORK_ENVIRONMENT=false
fi

# @description Detect `START_REPO` format and determine appropriate git address, otherwise use the master Install Doctor branch
if [ -z "$START_REPO" ]; then
    START_REPO="https://github.com/megabyte-labs/install.doctor.git"
else
    if [[ "$START_REPO == *"/"* ]]; then
        # Either full git address or GitHubUser/RepoName
        if [[ "$START_REPO" == *":"* ]] || [[ "$START_REPO" == *"//"* ]]; then
            START_REPO="$START_REPO"
        else
            START_REPO="https://github.com/${START_REPO}.git"
        fi
    else
        START_REPO="https://github.com/$START_REPO/install.doctor.git"
    fi
fi

# @description Logs with style using Gum if it is installed, otherwise it uses `echo`. It also leverages Glow to render markdown.
# When Glow is not installed, it uses `cat`.
# @example logger info "An informative log"
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
        gum style " $(gum style --foreground="#00ffff" "○") $(gum style --faint --foreground="#ffffff" "$MSG")"
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

# @description Notify user that they can press CTRL+C to prevent /etc/sudoers from being modified (which is currently required for headless installs on some systems)
sudo -n true || SUDO_EXIT_CODE=$?
logg info 'Your user will temporarily be granted passwordless sudo for the duration of the script'
if [ -n "$SUDO_EXIT_CODE" ]; then
  logg info 'Press `CTRL+C` to bypass this prompt to either enter your password when needed or perform a non-privileged installation'
  logg info 'Note: Non-privileged installations are not yet supported'
fi

# @description Add current user to /etc/sudoers so that headless automation is possible
if ! sudo cat /etc/sudoers | grep '# TEMPORARY FOR INSTALL DOCTOR' > /dev/null; then
  echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL # TEMPORARY FOR INSTALL DOCTOR" | sudo tee -a /etc/sudoers
  REMOVE_TMP_SUDOERS_MACOS=true
fi

# @section Qubes dom0 Bootstrap
# @description Perform Qubes dom0 specific logic like updating system packages, setting up the Tor VM, updating TemplateVMs, and
# beginning the provisioning process using Ansible and an AppVM used to handle the provisioning process
if command -v qubesctl > /dev/null; then
  # @description Ensure sys-whonix is configured (for Qubes dom0)
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

  # @description Ensure dom0 is updated
  if [ ! -f /root/dom0-updated ]; then
    sudo qubesctl --show-output state.sls update.qubes-dom0
    sudo qubes-dom0-update --clean -y
    touch /root/dom0-updated
  fi

  # @description Ensure sys-whonix is running
  if ! qvm-check --running sys-whonix; then
    qvm-start sys-whonix --skip-if-running
    configureWizard > /dev/null
  fi

  # @description Ensure TemplateVMs are updated
  if [ ! -f /root/templatevms-updated ]; then
    # timeout of 10 minutes is added here because the whonix-gw VM does not like to get updated
    # with this method. Anyone know how to fix this?
    sudo timeout 600 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm &> /dev/null || true
    while read -r RESTART_VM; do
      qvm-shutdown --wait "$RESTART_VM"
    done< <(qvm-ls --all --no-spinner --fields=name,state | grep Running | grep -v sys-net | grep -v sys-firewall | grep -v sys-whonix | grep -v dom0 | awk '{print $1}')
    sudo touch /root/templatevms-updated
  fi

  # @description Ensure provisioning VM can run commands on any VM
  echo "/bin/bash" | sudo tee /etc/qubes-rpc/qubes.VMShell
  sudo chmod 755 /etc/qubes-rpc/qubes.VMShell
  echo "${ANSIBLE_PROVISION_VM:=provision}"' dom0 allow' | sudo tee /etc/qubes-rpc/policy/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' $anyvm allow' | sudo tee -a /etc/qubes-rpc/policy/qubes.VMShell
  sudo chown "$(whoami):$(whoami)" /etc/qubes-rpc/policy/qubes.VMShell
  sudo chmod 644 /etc/qubes-rpc/policy/qubes.VMShell


  # @description Create provisioning VM and initialize the provisioning process from there
  qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || true
  qvm-volume extend "$ANSIBLE_PROVISION_VM:private" "40G"
  if [ -f ~/.vaultpass ]; then
    qvm-run "$ANSIBLE_PROVISION_VM" 'rm -f ~/QubesIncoming/dom0/.vaultpass'
    qvm-copy-to-vm "$ANSIBLE_PROVISION_VM" ~/.vaultpass
    qvm-run "$ANSIBLE_PROVISION_VM" 'cp ~/QubesIncoming/dom0/.vaultpass ~/.vaultpass'
  fi

  # @description Restart the provisioning process with the same script but from the provisioning VM
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" 'curl -sSL https://install.doctor/start > ~/start.sh && bash ~/start.sh'
  exit 0
fi

# @description Ensure basic system packages are available on the device
if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null; then
    if command -v apt-get > /dev/null; then
        # @description Ensure `build-essential`, `curl`, `expect`, `git`, and `rsync` are installed on Debian / Ubuntu
        sudo apt-get update
        sudo apt-get install -y build-essential curl expect git rsync
    elif command -v dnf > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Fedora
        sudo dnf install -y curl expect git rsync
    elif command -v yum > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on CentOS
        sudo yum install -y curl expect git rsync
    elif command -v pacman > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Archlinux
        sudo pacman update
        sudo pacman -Sy curl expect git rsync
    elif command -v zypper > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on OpenSUSE
        sudo zypper install -y curl expect git rsync
    elif command -v apk > /dev/null; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Alpine
        apk add curl expect git rsync
    elif [ -d /Applications ] && [ -d /Library ]; then
        # @description Ensure CLI developer tools are available on macOS (via `xcode-select`)
        sudo xcode-select -p >/dev/null 2>&1 || xcode-select --install
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
        # @description Ensure `curl`, `expect`, `git`, and `rsync` are installed on Windows
        choco install -y curl expect git rsync
    fi
fi

# @description Ensure Homebrew is installed and available
if ! command -v brew > /dev/null; then
    if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        if ! command -v brew > /dev/null; then
            echo "The /home/linuxbrew/.linuxbrew directory exists but something is not right. Try removing it and running the script again." && exit 1
        fi
    else
        # @description Installs Homebrew and addresses a couple potential issues
        if command -v sudo > /dev/null && sudo -n true; then
            echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
            if [ -n "$BREW_EXIT_CODE" ]; then
                if command -v brew > /dev/null; then
                    echo "Homebrew was installed but part of the installation failed. Trying a few things to fix the installation.."
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

        # @description Ensures the `brew` binary is available on Linux machines. macOS installs `brew` into the default `PATH`
        # so nothing needs to be done for macOS.
        if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        fi
    fi
fi

# @description Ensure Chezmoi is installed
if ! command -v chezmoi > /dev/null; then
    brew install chezmoi
fi

# @description Ensure Node.js is installed
if ! command -v node > /dev/null; then
    brew install node
fi

# @description Ensure ZX is installed
if ! command -v zx > /dev/null; then
    brew install zx
fi

# @description Install Glow / Gum if the `HEADLESS_INSTALL` variable is not set to true
if [ "$HEADLESS_INSTALL" != 'true' ]; then
    # @description Ensure Gum is installed
    if ! command -v gum > /dev/null; then
        brew install gum
    fi

    # @description Ensure Glow is installed
    if ! command -v glow > /dev/null; then
        brew install glow
    fi
fi

# @description Ensure the ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi directory is cloned and up-to-date
if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/.git" ]; then
  cd "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
  logg info "Pulling the latest changes from ${START_REPO:-https://github.com/megabyte-labs/install.doctor.git}"
  git pull origin master
else
  logg info "Cloning ${START_REPO} to ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
  git clone ${START_REPO} "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
fi

# @description If the `${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml` file is missing, then guide the user through the initial setup
if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml" ]; then
  # @description Show introduction message if Glow is installed
  if command -v glow > /dev/null; then
    glow "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/CHEZMOI-INTRO.md"
  fi

  # @description Prompt for the software group if the `SOFTWARE_GROUP` variable is not defined
  if command -v gum > /dev/null; then
    if [ -z "$SOFTWARE_GROUP" ]; then
      logg prompt 'Select the software group you would like to install. If your environment is a macOS, Windows, or environment with the DISPLAY environment variable then desktop software will be installed too. The software groups are in the '"${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml"' file.'
      SOFTWARE_GROUP="$(gum choose "Basic" "Standard" "Full")"
      export SOFTWARE_GROUP
    fi
  else
    logg error 'Woops! Gum needs to be installed for the guided installation. Try running brew install gum' && exit 1
  fi

  # @description Run `chezmoi init` when the Chezmoi configuration is missing
  logg info 'Running `chezmoi init` since the '"${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml"' is not present'
  chezmoi init
fi

# @description Run `chezmoi apply` and enable verbose mode if the `DEBUG_MODE` environment variable is set to true
logg info 'Running `chezmoi apply`'
if [ "$DEBUG_MODE" = 'true' ]; then
  DEBUG_MODIFIER="-vvvvv"
fi

# @description Save the log of the provision process to `${XDG_DATA_HOME:-$HOME/.local/share}/install.doctor.$(date +%s).log` and add the Chezmoi
# `--force` flag if the `HEADLESS_INSTALL` variable is set to true.
if [ "$HEADLESS_INSTALL" = 'true' ]; then
  if command -v unbuffer > /dev/null; then
    unbuffer -p chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "${XDG_DATA_HOME:-$HOME/.local/share}/install.doctor.$(date +%s).log"
  else
    chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "${XDG_DATA_HOME:-$HOME/.local/share}/install.doctor.$(date +%s).log"
  fi
else
  if command -v unbuffer > /dev/null; then
    unbuffer -p chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "${XDG_DATA_HOME:-$HOME/.local/share}/install.doctor.$(date +%s).log"
  else
    chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "${XDG_DATA_HOME:-$HOME/.local/share}/install.doctor.$(date +%s).log"
  fi
fi

# @description Ensure gsed is available on macOS (for modifying `/etc/sudoers` to remove passwordless sudo)
if [ -n "$REMOVE_TMP_SUDOERS" ] && [ -d /Applications ] && [ -d /System ]; then
  if ! command -v gsed > /dev/null; then
    if command -v brew > /dev/null; then
      brew install gsed
    else
      logg warn 'Homebrew is not available and passwordless sudo might still be enabled in /etc/sudoers. Modify the file manually if you wish to disable passwordless sudo.'
    fi
  fi
fi

# @description Ensure temporary passwordless sudo privileges are removed from `/etc/sudoers`
if command -v gsed > /dev/null; then
    sudo gsed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
else
    sudo sed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
fi

# @description Render the `docs/POST-INSTALL.md` file to the terminal at the end of the provisioning process
logg success 'Provisioning complete!'
if command -v glow > /dev/null && [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/POST-INSTALL.md" ]; then
  glow "$HOME/.local/share/chezmoi/docs/POST-INSTALL.md"
fi
