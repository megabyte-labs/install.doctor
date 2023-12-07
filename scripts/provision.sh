#!/usr/bin/env bash
# @file Quick Start Provision Script
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
#     | Variable                  | Description                                                                       |
#     |---------------------------|-----------------------------------------------------------------------------------|
#     | `START_REPO` (or `REPO`)  | Variable to specify the Git fork to use when provisioning                         |
#     | `ANSIBLE_PROVISION_VM`    | **For Qubes**, determines the name of the VM used to provision the system         |
#     | `DEBUG_MODE` (or `DEBUG`) | Set to true to enable verbose logging                                             |
#
#     For a full list of variables you can use to customize Install Doctor, check out our [Customization](https://install.doctor/docs/customization)
#     and [Secrets](https://install.doctor/docs/customization/secrets) documentation.
#
#     ## Links
#
#     [Install Doctor homepage](https://install.doctor)
#     [Install Doctor documentation portal](https://install.doctor/docs) (includes tips, tricks, and guides on how to customize the system to your liking)

# @description This function logs with style using Gum if it is installed, otherwise it uses `echo`. It is also capable of leveraging Glow to render markdown.
#     When Glow is not installed, it uses `cat`. The following sub-commands are available:
#
#     | Sub-Command | Description                                                                                         |
#     |-------------|-----------------------------------------------------------------------------------------------------|
#     | `error`     | Logs a bright red error message                                                                     |
#     | `info`      | Logs a regular informational message                                                                |
#     | `md`        | Tries to render the specified file using `glow` if it is installed and uses `cat` as a fallback     |
#     | `prompt`    | Alternative that logs a message intended to describe an upcoming user input prompt                  |
#     | `star`      | Alternative that logs a message that starts with a star icon                                        |
#     | `start`     | Same as `success`                                                                                   |
#     | `success`   | Logs a success message that starts with green checkmark                                             |
#     | `warn`      | Logs a bright yellow warning message                                                                |
# @example
#     logger info "An informative log"
# @example
#     logger md ~/README.md
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
        gum style " $(gum style --foreground="#00ff00" "✔") $(gum style --bold "$MSG")"
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

# @section Environment variables and system dependencies
# @description Ensure Ubuntu / Debian run in `noninteractive` mode. Detect `START_REPO` format and determine appropriate git address,
#     otherwise use the master Install Doctor branch
setEnvironmentVariables() {
  export DEBIAN_FRONTEND=noninteractive
  export HOMEBREW_NO_ENV_HINTS=true
  if [ -z "$START_REPO" ] && [ -z "$REPO" ]; then
    export START_REPO="https://github.com/megabyte-labs/install.doctor.git"
  else
    if [ -n "$REPO" ] && [ -z "$START_REPO" ]; then
      export START_REPO="$REPO"
    fi
    if [[ "$START_REPO" == *"/"* ]]; then
      # Either full git address or GitHubUser/RepoName
      if [[ "$START_REPO" == *":"* ]] || [[ "$START_REPO" == *"//"* ]]; then
        export START_REPO="$START_REPO"
      else
        export START_REPO="https://github.com/${START_REPO}.git"
      fi
    else
      export START_REPO="https://github.com/$START_REPO/install.doctor.git"
    fi
  fi
}

# @description This function ensures dependencies like `git` and `curl` are installed. More specifically, this function will:
#
#     1. Check if `curl`, `git`, `expect`, `rsync`, and `unbuffer` are on the system
#     2. If any of the above are missing, it will then use the appropriate system package manager to satisfy the requirements. *Note that some of the requirements are not scanned for in order to keep it simple and fast.*
#     3. On macOS, the official Xcode Command Line Tools are installed.
ensureBasicDeps() {
  if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null || ! command -v unbuffer > /dev/null; then
    if command -v apt-get > /dev/null; then
      ### Debian / Ubuntu
      logg info 'Running sudo apt-get update' && sudo apt-get update
      logg info 'Running sudo apt-get install -y build-essential curl expect git rsync procps file' && sudo apt-get install -y build-essential curl expect git rsync procps file
    elif command -v dnf > /dev/null; then
      ### Fedora
      logg info 'Running sudo dnf groupinstall -y "Development Tools"' && sudo dnf groupinstall -y 'Development Tools'
      logg info 'Running sudo dnf install -y curl expect git rsync procps-ng file' && sudo dnf install -y curl expect git rsync procps-ng file
    elif command -v yum > /dev/null; then
      ### CentOS
      logg info 'Running sudo yum groupinstall -y "Development Tools"' && sudo yum groupinstall -y 'Development Tools'
      logg info 'Running sudo yum install -y curl expect git rsync procps-ng file' && sudo yum install -y curl expect git rsync procps-ng file
    elif command -v pacman > /dev/null; then
      ### Archlinux
      logg info 'Running sudo pacman update' && sudo pacman update
      logg info 'Running sudo pacman -Syu base-devel curl expect git rsync procps-ng file' && sudo pacman -Syu base-devel curl expect git rsync procps-ng file
    elif command -v zypper > /dev/null; then
      ### OpenSUSE
      logg info 'Running sudo zypper install -yt pattern devel_basis' && sudo zypper install -yt pattern devel_basis
      logg info 'Running sudo zypper install -y curl expect git rsync procps file' && sudo zypper install -y curl expect git rsync procps file
    elif command -v apk > /dev/null; then
      ### Alpine
      logg info 'Running sudo apk add build-base curl expect git rsync ruby procps file' && sudo apk add build-base curl expect git rsync ruby procps file
    elif [ -d /Applications ] && [ -d /Library ]; then
      ### macOS
      logg info "Ensuring Xcode Command Line Tools are installed.."
      if ! xcode-select -p >/dev/null 2>&1; then
        logg info "Command Line Tools for Xcode not found"
        ### This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
        XCODE_PKG="$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')"
        logg info "Installing from softwareupdate" && softwareupdate -i "$XCODE_PKG" && logg success "Successfully installed $XCODE_PKG"
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      ### Windows
      logg info 'Running choco install -y curl expect git rsync' && choco install -y curl expect git rsync
    elif command -v nix-env > /dev/null; then
      ### NixOS
      logg warn "TODO - Add support for NixOS"
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      ### FreeBSD
      logg warn "TODO - Add support for FreeBSD"
    elif command -v pkg > /dev/null; then
      ### Termux
      logg warn "TODO - Add support for Termux"
    elif command -v xbps-install > /dev/null; then
      ### Void
      logg warn "TODO - Add support for Void"
    fi
  fi
}

# @description This function ensures Homebrew is installed and available in the `PATH`. It handles the installation of Homebrew on both **Linux and macOS**.
#     It will attempt to bypass sudo password entry if it detects that it can do so. The function also has some error handling in regards to various
#     directories falling out of the correct ownership and permission states. Finally, it loads Homebrew into the active profile (allowing other parts of the script
#     to use the `brew` command).
#
#     With Homebrew installed and available, the script finishes by installing the `gcc` Homebrew package which is a very common dependency.
ensureHomebrew() {
  if ! command -v brew > /dev/null; then
    if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
      logg info "Sourcing from /home/linuxbrew/.linuxbrew/bin/brew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      if ! command -v brew > /dev/null; then
        logg error "The /home/linuxbrew/.linuxbrew directory exists but something is not right. Try removing it and running the script again." && exit 1
      fi
    elif [ -d "$HOME/.linuxbrew" ]; then
      logg info "Sourcing from $HOME/.linuxbrew/bin/brew" && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
      if ! command -v brew > /dev/null; then
        logg error "The $HOME/.linuxbrew directory exists but something is not right. Try removing it and running the script again." && exit 1
      fi
    else
      ### Installs Homebrew and addresses a couple potential issues
      if command -v sudo > /dev/null && sudo -n true; then
        logg info "Installing Homebrew"
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      else
        logg info "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || BREW_EXIT_CODE="$?"
        if [ -n "$BREW_EXIT_CODE" ]; then
          if command -v brew > /dev/null; then
            logg warn "Homebrew was installed but part of the installation failed. Trying a few things to fix the installation.."
            BREW_DIRS="share/man share/doc share/zsh/site-functions etc/bash_completion.d"
            for BREW_DIR in $BREW_DIRS; do
              if [ -d "$(brew --prefix)/$BREW_DIR" ]; then
                logg info "Chowning $(brew --prefix)/$BREW_DIR" && sudo chown -R "$(whoami)" "$(brew --prefix)/$BREW_DIR"
              fi
            done
            logg info "Running brew update --force --quiet" && brew update --force --quiet && logg success "Successfully ran brew update --force --quiet"
          fi
        fi
      fi

      ### Ensures the `brew` binary is available on Linux machines. macOS installs `brew` into the default `PATH` so nothing needs to be done for macOS.
      if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
        logg info "Sourcing shellenv from /home/linuxbrew/.linuxbrew/bin/brew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      elif [ -f /usr/local/bin/brew ]; then
        logg info "Sourcing shellenv from /usr/local/bin/brew" && eval "$(/usr/local/bin/brew shellenv)"
      elif [ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" ]; then
        logg info "Sourcing shellenv from "${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew"" && eval "$("${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew" shellenv)"
      fi
    fi
  fi

  ### Ensure GCC is installed via Homebrew
  if command -v brew > /dev/null; then
    if ! brew list | grep gcc > /dev/null; then
      logg info "Installing Homebrew gcc" && brew install --quiet gcc
    fi
  else
    logg error "Failed to initialize Homebrew" && exit 2
  fi
}

# @description This function determines whether or not a reboot is required on the target system.
#     On Linux, it will check for the presence of the `/var/run/reboot-required` file to determine
#     whether or not a reboot is required. On macOS, it will reboot `/Library/Updates/index.plist`
#     to determine whether or not a reboot is required.
#
#     After determining whether or not a reboot is required, the script will attempt to automatically
#     reboot the machine.
handleRequiredReboot() {
    if [ -d /Applications ] && [ -d /System ]; then
        ### macOS
        logg info 'Checking if there is a pending update' && defaults read /Library/Updates/index.plist InstallAtLogout
        # TODO - Uncomment this when we can determine conditions for reboot
        # sudo shutdown -r now
    elif [ -f /var/run/reboot-required ]; then
        ### Linux
        logg info '/var/run/reboot-required is present so a reboot is required'
        if command -v systemctl > /dev/null; then
            logg info 'systemctl present so rebooting with sudo systemctl start reboot.target' && sudo systemctl start reboot.target
        elif command -v reboot > /dev/null; then
            logg info 'reboot available as command so rebooting with sudo reboot' && sudo reboot
        elif command -v shutdown > /dev/null; then
            logg info 'shutdown command available so rebooting with sudo shutdown -r now' && sudo shutdown -r now
        else
            logg warn 'Reboot required but unable to determine appropriate restart command'
        fi
    fi
}
# @description Load default settings if it is in a CI setting
setCIEnvironmentVariables() {
  if [ -n "$CI" ] || [ -n "$TEST_INSTALL" ]; then
    logg info "Automatically setting environment variables since the CI environment variable is defined"
    logg info "Setting NO_RESTART to true" && export NO_RESTART=true
    logg info "Setting HEADLESS_INSTALL to true " && export HEADLESS_INSTALL=true
    logg info "Setting SOFTWARE_GROUP to Full-Desktop" && export SOFTWARE_GROUP="Full-Desktop"
    logg info "Setting FULL_NAME to Brian Zalewski" && export FULL_NAME="Brian Zalewski"
    logg info "Setting PRIMARY_EMAIL to brian@megabyte.space" && export PRIMARY_EMAIL="brian@megabyte.space"
    logg info "Setting PUBLIC_SERVICES_DOMAIN to lab.megabyte.space" && export PUBLIC_SERVICES_DOMAIN="lab.megabyte.space"
    logg info "Setting RESTRICTED_ENVIRONMENT to false" && export RESTRICTED_ENVIRONMENT=false
    logg info "Setting WORK_ENVIRONMENT to false" && export WORK_ENVIRONMENT=false
    logg info "Setting HOST to $(hostname -s)" && export HOST="$(hostname -s)"
  fi
}

# @description Disconnect from WARP, if connected
ensureWarpDisconnected() {
  if command -v warp-cli > /dev/null; then
    if warp-cli status | grep 'Connected' > /dev/null; then
      logg info "Disconnecting from WARP" && warp-cli disconnect && logg success "Disconnected WARP to prevent conflicts"
    fi
  fi
}

# @description Notify user that they can press CTRL+C to prevent `/etc/sudoers` from being modified (which is currently required for headless installs on some systems).
#     Additionally, this function will add the current user to `/etc/sudoers` so that headless automation is possible.
setupPasswordlessSudo() {
  sudo -n true || SUDO_EXIT_CODE=$?
  logg info 'Your user will temporarily be granted passwordless sudo for the duration of the script'
  if [ -n "$SUDO_EXIT_CODE" ] && [ -z "$SUDO_PASSWORD" ] && command -v chezmoi > /dev/null && [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/SUDO_PASSWORD" ]; then
    logg info "Acquiring SUDO_PASSWORD by using Chezmoi to decrypt ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/SUDO_PASSWORD"
    SUDO_PASSWORD="$(cat "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/SUDO_PASSWORD" | chezmoi decrypt)"
    export SUDO_PASSWORD
  fi
  if [ -n "$SUDO_PASSWORD" ]; then
    logg info 'Using the acquired sudo password to automatically grant the user passwordless sudo privileges for the duration of the script'
    echo "$SUDO_PASSWORD" | sudo -S sh -c "echo '$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL # TEMPORARY FOR INSTALL DOCTOR' | sudo -S tee -a /etc/sudoers > /dev/null"
    # Old method below does not work on macOS due to multiple sudo prompts
    # printf '%s\n%s\n' "$SUDO_PASSWORD" | sudo -S echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL # TEMPORARY FOR INSTALL DOCTOR" | sudo -S tee -a /etc/sudoers > /dev/null
  else
    logg info 'Press CTRL+C to bypass this prompt to either enter your password when needed or perform a non-privileged installation'
    logg info 'Note: Non-privileged installations are not yet supported'
    echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL # TEMPORARY FOR INSTALL DOCTOR" | sudo tee -a /etc/sudoers > /dev/null
  fi
}

# @section Qubes dom0
# @description Ensure sys-whonix is configured (for Qubes dom0)
ensureSysWhonix() {
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
}

# @description Ensure dom0 is updated
ensureDom0Updated() {
  if [ ! -f /root/dom0-updated ]; then
    sudo qubesctl --show-output state.sls update.qubes-dom0
    sudo qubes-dom0-update --clean -y
    touch /root/dom0-updated
  fi
}

# @description Ensure sys-whonix is running
ensureSysWhonixRunning() {
  if ! qvm-check --running sys-whonix; then
    qvm-start sys-whonix --skip-if-running
    configureWizard > /dev/null
  fi
}

# @description Ensure TemplateVMs are updated
ensureTemplateVMsUpdated() {
  if [ ! -f /root/templatevms-updated ]; then
    # timeout of 10 minutes is added here because the whonix-gw VM does not like to get updated
    # with this method. Anyone know how to fix this?
    sudo timeout 600 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm &> /dev/null || true
    while read -r RESTART_VM; do
      qvm-shutdown --wait "$RESTART_VM"
    done< <(qvm-ls --all --no-spinner --fields=name,state | grep Running | grep -v sys-net | grep -v sys-firewall | grep -v sys-whonix | grep -v dom0 | awk '{print $1}')
    sudo touch /root/templatevms-updated
  fi
}

# @description Ensure provisioning VM can run commands on any VM
ensureProvisioningVMPermissions() {
  echo "/bin/bash" | sudo tee /etc/qubes-rpc/qubes.VMShell
  sudo chmod 755 /etc/qubes-rpc/qubes.VMShell
  echo "${ANSIBLE_PROVISION_VM:=provision}"' dom0 allow' | sudo tee /etc/qubes-rpc/policy/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' $anyvm allow' | sudo tee -a /etc/qubes-rpc/policy/qubes.VMShell
  sudo chown "$(whoami):$(whoami)" /etc/qubes-rpc/policy/qubes.VMShell
  sudo chmod 644 /etc/qubes-rpc/policy/qubes.VMShell
}

# @description Create provisioning VM and initialize the provisioning process from there
createAndInitProvisionVM() {
  qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || true
  qvm-volume extend "$ANSIBLE_PROVISION_VM:private" "40G"
  if [ -f ~/.vaultpass ]; then
    qvm-run "$ANSIBLE_PROVISION_VM" 'rm -f ~/QubesIncoming/dom0/.vaultpass'
    qvm-copy-to-vm "$ANSIBLE_PROVISION_VM" ~/.vaultpass
    qvm-run "$ANSIBLE_PROVISION_VM" 'cp ~/QubesIncoming/dom0/.vaultpass ~/.vaultpass'
  fi
}

# @description Restart the provisioning process with the same script but from the provisioning VM
runStartScriptInProvisionVM() {
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" 'curl -sSL https://install.doctor/start > ~/start.sh && bash ~/start.sh'
}

# @description Perform Qubes dom0 specific logic like updating system packages, setting up the Tor VM, updating TemplateVMs, and
#     beginning the provisioning process using Ansible and an AppVM used to handle the provisioning process
handleQubesDom0() {
  if command -v qubesctl > /dev/null; then
    ensureSysWhonix
    ensureDom0Updated
    ensureSysWhonixRunning
    ensureTemplateVMsUpdated
    ensureProvisioningVMPermissions
    createAndInitProvisionVM
    runStartScriptInProvisionVM
    exit 0
  fi
}

# @section Homebrew dependencies
# @description Helper function used by [[ensureHomebrewDeps]] to ensure a Homebrew package is installed after
#     first checking if it is already available on the system.
installBrewPackage() {
  if ! command -v "$1" > /dev/null; then
    logg 'Installing '"$1"''
    brew install --quiet "$1"
  fi
}

# @description Installs various dependencies using Homebrew.
#
#     1. Ensures Glow, Gum, Chezmoi, Node.js, and ZX are installed.
#     2. If the system is macOS, then also install `gsed` and `coreutils`.
ensureHomebrewDeps() {
  ### Base dependencies
  installBrewPackage "glow"
  installBrewPackage "gum"
  installBrewPackage "chezmoi"
  installBrewPackage "node"
  installBrewPackage "zx"

  ### macOS
  if [ -d /Applications ] && [ -d /System ]; then
    installBrewPackage "expect"
    installBrewPackage "gsed"
    if ! command -v gtimeout > /dev/null; then
      brew install --quiet coreutils
    fi
  fi
}

# @section Chezmoi
# @description Ensure the `${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi` directory is cloned and up-to-date using the previously
#     set `START_REPO` as the source repository.
cloneChezmoiSourceRepo() {
  if ! git config --get --global http.postBuffer > /dev/null; then
    logg info 'Setting git http.postBuffer value high for large source repository' && git config --global http.postBuffer 524288000
  fi
  if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/.git" ]; then
    logg info "Changing directory to ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi" && cd "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
    logg info "Pulling the latest changes in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi" && git pull origin master
  else
    logg info "Ensuring ${XDG_DATA_HOME:-$HOME/.local/share} is a folder" && mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"
    logg info "Cloning ${START_REPO} to ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi" && git clone "${START_REPO}" "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
  fi
}

# @description Guide the user through the initial setup by showing TUI introduction and accepting input through various prompts.
#
#     1. Show `chezmoi-intro.md` with `glow`
#     2. Prompt for the software group if the `SOFTWARE_GROUP` variable is not defined
#     3. Run `chezmoi init` when the Chezmoi configuration is missing (i.e. `${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml`)
initChezmoiAndPrompt() {
  ### Show `chezmoi-intro.md` with `glow`
  if command -v glow > /dev/null; then
    glow "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/chezmoi-intro.md"
  fi

  ### Prompt for the software group if the `SOFTWARE_GROUP` variable is not defined
  if command -v gum > /dev/null; then
    if [ -z "$SOFTWARE_GROUP" ]; then
      logg prompt 'Select the software group you would like to install. If your environment is a macOS, Windows, or environment with the DISPLAY environment variable then desktop software will be installed too. The software groups are in the '"${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml"' file.'
      SOFTWARE_GROUP="$(gum choose "Basic" "Server" "Standard" "Full")"
      export SOFTWARE_GROUP
    fi
  else
    logg error 'Woops! Gum needs to be installed for the guided installation. Try running brew install gum' && exit 1
  fi

  if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml" ]; then
    ### Run `chezmoi init` when the Chezmoi configuration is missing
    logg info 'Running chezmoi init since the '"${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml"' is not present'
    chezmoi init
  fi
}

# @description Run `chezmoi apply` and enable verbose mode if the `DEBUG_MODE` or `DEBUG` environment variable is set to true
configureDebugMode() {
  if [ -n "$DEBUG_MODE" ] || [ -n "$DEBUG" ]; then
    logg info "Either DEBUG_MODE or DEBUG environment variables were set so Chezmoi will be run in debug mode"
    export DEBUG_MODIFIER="-vvvvv"
  fi
}

# @description Save the log of the provision process to `$HOME/.local/var/log/install.doctor/install.doctor.$(date +%s).log` and add the Chezmoi
#     `--force` flag if the `HEADLESS_INSTALL` variable is set to `true`.
runChezmoi() {
  mkdir -p "$HOME/.local/var/log/install.doctor"
  LOG_FILE="$HOME/.local/var/log/install.doctor/install.doctor.$(date +%s).log"
  if [ "$HEADLESS_INSTALL" = 'true' ]; then
    logg info 'Running chezmoi apply forcefully'
    if command -v unbuffer > /dev/null; then
      if command -v caffeinate > /dev/null; then
        caffeinate unbuffer -p chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "$LOG_FILE"
      else
        unbuffer -p chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "$LOG_FILE"
      fi
    else
      if command -v caffeinate > /dev/null; then
        caffeinate chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "$LOG_FILE"
      else
        chezmoi apply $DEBUG_MODIFIER -k --force 2>&1 | tee "$LOG_FILE"
      fi
    fi
  else
    logg info 'Running chezmoi apply'
    if command -v unbuffer > /dev/null; then
      if command -v caffeinate > /dev/null; then
        caffeinate unbuffer -p chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "$LOG_FILE"
      else
        unbuffer -p chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "$LOG_FILE"
      fi    
    else
      if command -v caffeinate > /dev/null; then
        caffeinate chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "$LOG_FILE"
      else
        chezmoi apply $DEBUG_MODIFIER -k 2>&1 | tee "$LOG_FILE"
      fi    
    fi
  fi
}

# @section Post-provision logic
# @description Ensure temporary passwordless sudo privileges are removed from `/etc/sudoers`
removePasswordlessSudo() {
  if command -v gsed > /dev/null; then
    sudo gsed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
  else
    sudo sed -i '/# TEMPORARY FOR INSTALL DOCTOR/d' /etc/sudoers || logg warn 'Failed to remove passwordless sudo from the /etc/sudoers file'
  fi
}

# @description Render the `docs/terminal/post-install.md` file to the terminal at the end of the provisioning process
postProvision() {
  logg success 'Provisioning complete!'
  if command -v glow > /dev/null && [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/post-install.md" ]; then
    glow "${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/docs/terminal/post-install.md"
  fi
}


# @section Execution order
# @description The `provisionLogic` function is used to define the order of the script. All of the functions it relies on are defined
#     above.
provisionLogic() {
  logg info "Setting environment variables" && setEnvironmentVariables
  logg info "Handling CI variables" && setCIEnvironmentVariables
  logg info "Ensuring WARP is disconnected" && ensureWarpDisconnected
  logg info "Applying passwordless sudo" && setupPasswordlessSudo
  logg info "Ensuring system Homebrew dependencies are installed" && ensureBasicDeps
  logg info "Ensuring Homebrew is available" && ensureHomebrew
  logg info "Installing Homebrew packages" && ensureHomebrewDeps
  logg info "Handling Qubes dom0 logic (if applicable)" && handleQubesDom0
  logg info "Cloning / updating source repository" && cloneChezmoiSourceRepo
  logg info "Handling pre-provision logic" && initChezmoiAndPrompt
  logg info "Handling debug mode if DEBUG or DEBUG_MODE are defined" && configureDebugMode
  logg info "Running the Chezmoi provisioning" && runChezmoi
  logg info "Ensuring temporary passwordless sudo is removed" && removePasswordlessSudo
  logg info "Handling post-provision logic" && postProvision
  logg info "Determing whether or not reboot" && handleRequiredReboot
}
provisionLogic
