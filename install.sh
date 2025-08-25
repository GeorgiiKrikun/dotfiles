#!/bin/bash
set -ex

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

bash ${SCRIPT_DIR}/deps/bootstrap.sh 
JUST=${HOME}/.cargo/bin/just

if ! command -v zsh >/dev/null; then
  ZSH_EXISTS=false
else
  ZSH_EXISTS=true
fi

if [ -d "${HOME}/.oh-my-zsh" ]; then
  OH_MY_ZSH_EXISTS=true
else
  OH_MY_ZSH_EXISTS=false
fi
  
cd ${SCRIPT_DIR}/deps

if [ "$ZSH_EXISTS" = true ]; then
  echo "Zsh exists, skipping Zsh install."
else
  echo "Zsh does not exist, we will install it."
  ${JUST} install-zsh
fi

if [ "$OH_MY_ZSH_EXISTS" = true ]; then
  echo "Oh My Zsh exists, skipping Oh My Zsh install."
else
  echo "Oh My Zsh does not exist, we will install it."
  ${JUST} install-oh-my-zsh
fi

${JUST} change-shell-zsh
${JUST} setup-cargo-zsh

cd ${SCRIPT_DIR}/configs/zsh
${JUST} setup

echo "Zsh and Oh My Zsh have been set up successfully."

cd ${SCRIPT_DIR}/deps
${JUST} install-neovim
${JUST} setup-nvim-path-zsh
${JUST} install-lazygit 
${JUST} install-vcode-debugger
${JUST} install-luarocks-penlight

cd ${SCRIPT_DIR}/configs/nvim
${JUST} setup

echo "Neovim has been set up successfully."

echo "Installing additional utilities..."
${HOME}/.cargo/bin/cargo install ripgrep 
${HOME}/.cargo/bin/cargo install bottom 
${HOME}/.cargo/bin/cargo install fd-find
echo "Utilities installed successfully."

