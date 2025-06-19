#!/bin/bash
set -ex

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

bash ${SCRIPT_DIR}/deps/bootstrap.sh 
JUST=${HOME}/.cargo/bin/just

if ! command -v zsh >/dev/null; then
  echo "Zsh does not exist, we will install it."
  ZSH_EXISTS=false
else
  echo "Zsh exists, skipping Zsh install."
  ZSH_EXISTS=true
fi

if [ "$ZSH_EXISTS" = true ]; then
  echo "Zsh exists, skipping Zsh install."
else
  echo "Zsh does not exist, we will install it."
  cd ${SCRIPT_DIR}/deps
  ${JUST} install-zsh
  ${JUST} install-oh-my-zsh 
  ${JUST} change-shell-zsh
  ${JUST} setup-cargo-zsh
fi

cd ${SCRIPT_DIR}/configs/zsh
${JUST} setup

echo "Zsh and Oh My Zsh have been set up successfully."

cd ${SCRIPT_DIR}/deps
${JUST} install-neovim
${JUST} setup-nvim-path-zsh

cd ${SCRIPT_DIR}/configs/nvim
${JUST} setup

echo "Neovim has been set up successfully."

echo "Installing additional utilities..."
${HOME}/.cargo/bin/cargo install ripgrep 
${HOME}/.cargo/bin/cargo install bottom 
${HOME}/.cargo/bin/cargo install fd-find
echo "Utilities installed successfully."

