#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

bash ${SCRIPT_DIR}/deps/bootstrap.sh 
JUST=${HOME}/.cargo/bin/just

cd ${SCRIPT_DIR}/deps

${JUST} install-zsh
${JUST} install-oh-my-zsh
  
${JUST} change-shell-zsh
${JUST} setup-cargo-zsh

cd ${SCRIPT_DIR}/configs/zsh
${JUST} setup

echo "Zsh and Oh My Zsh have been set up successfully."

cd ${SCRIPT_DIR}/deps
${JUST} install-unzip
${JUST} install-neovim
${JUST} setup-nvim-path-zsh
${JUST} install-lazygit 
${JUST} install-vcode-debugger
${JUST} install-luarocks-penlight
${JUST} install-njs

cd ${SCRIPT_DIR}/configs/nvim
${JUST} setup

echo "Neovim has been set up successfully."

cd ${SCRIPT_DIR}/deps
${JUST} install-tmux
${JUST} setup-tmux-auto-start-bash

cd ${SCRIPT_DIR}/configs/tmux
${JUST} setup

echo "Tmux has been set up successfully."

echo "Installing additional utilities..."
cd ${SCRIPT_DIR}/deps
${JUST} install-ripgrep 
${JUST} install-bottom 
${JUST} install-fd-find
echo "Utilities installed successfully."
