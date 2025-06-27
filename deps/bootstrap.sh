#!/bin/bash
set -ex

if ! command -v sudo >/dev/null; then
  SUDO_EXISTS=false
else
  SUDO_EXISTS=true
fi

if [ "$SUDO_EXISTS" = true ]; then
  echo "Sudo exists, proceeding with sudo commands."
  sudo apt update && sudo apt install -y curl build-essential git
else
  echo "Sudo does not exist, we will still need it to install nvim/node/zsh"
  exit 1
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. $HOME/.cargo/env
rustup default stable
cargo install just
 
# For bash
echo ". $HOME/.cargo/env" >> ${HOME}/.bashrc
