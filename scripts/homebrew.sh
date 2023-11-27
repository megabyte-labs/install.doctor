#!/usr/bin/env bash
# @file Homebrew Install
# @brief Installs Homebrew on macOS and / or Linux.
# @description
#     This script installs Homebrew on macOS and/or Linux machines. The script:
#
#     1. Ensures Homebrew is not already installed
#     2. Installs Homebrew headlessly if sudo privileges are already given
#     3. Prompts for the sudo password, if required
#     4. Performs some clean up and update tasks when the Homebrew installation reports an error
#
#     **Note**: `https://install.doctor/brew` points to this file.

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

# @description This function ensures dependencies like `git` and `curl` are installed. More specifically, this function will:
#
#     1. Check if `curl`, `git`, `expect`, `rsync`, and `unbuffer` are on the system
#     2. If any of the above are missing, it will then use the appropriate system package manager to satisfy the requirements. *Note that some of the requirements are not scanned for in order to keep it simple and fast.*
#     3. On macOS, the official Xcode Command Line Tools are installed.
ensureBasicDeps() {
  if ! command -v curl > /dev/null || ! command -v git > /dev/null || ! command -v expect > /dev/null || ! command -v rsync > /dev/null || ! command -v unbuffer; then
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
ensureBasicDeps

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
      elif [ -f /opt/homebrew/bin/brew ]; then
        logg info "Sourcing shellenv from /opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    fi
  fi

  ### Ensure GCC is installed via Homebrew
  if command -v brew > /dev/null; then
    if ! brew list | grep gcc > /dev/null; then
      logg info "Installing Homebrew gcc" && brew install gcc
    fi
  else
    logg error "Failed to initialize Homebrew" && exit 2
  fi
}
ensureHomebrew
