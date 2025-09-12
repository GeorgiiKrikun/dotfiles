#!/bin/bash
set -e

if command -v sudo >/dev/null; then
  echo "Sudo exists"
else
  echo "Sudo does not exist, we will still need it to install nvim/node/zsh"
  exit 1
fi
  
# sudo apt update && sudo apt install -y curl build-essential git

if command -v cargo >/dev/null; then
  echo "Cargo exists"
else
  echo "Cargo does not exist, installing rust"
  curl --proto '=https' --tlsv1.2 -ssf https://sh.rustup.rs | sh -s -- -y
  . $HOME/.cargo/env
  rustup default stable
fi

if command -v just >/dev/null; then
  echo "Just exists"
else 
  cargo install just
fi

if cat ${HOME}/.bashrc | grep $HOME/.cargo/env >/dev/null; then 
  echo "$HOME/.cargo/env already exists in ${HOME}/.bashrc"
else
  echo ". $HOME/.cargo/env" >> ${HOME}/.bashrc
fi
