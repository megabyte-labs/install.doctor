#!/usr/bin/env bash
# @file VIM Plugins AOT Installation
# @brief This script triggers VIM to pre-install plugins so that VIM loads into the desired state the first time it is invoked

logg info "Installing VIM plugins" && vim +'PlugInstall --sync' +qall

# @description This script installs the extensions defined in `${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json`
#     which should correlate to the Coc extensions defined in `${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc`.
installCocExtensions() {
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json" ]; then
    logg info "Running npm i --no-progress --no-package-lock in ${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions"
    cd "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions" && npm i --no-progress --no-package-lock
    logg info "Running vim +CocUpdateSync +qall" && vim +CocUpdateSync +qall
  else
    logg info "Skipping Coc extension installation because ${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json is missing"
  fi
}

logg info "Updating VIM coc extensions" && installCocExtensions
