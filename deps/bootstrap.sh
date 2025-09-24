#!/bin/bash
set -e

if command -v sudo >/dev/null; then
  echo "Sudo exists"
else
  echo "Sudo does not exist, we will still need it to install nvim/node/zsh"
  exit 1
fi

sudo apt update

if command -v wget >/dev/null; then
  echo "Wget exists"
else 
  sudo apt install -y wget
fi

if command -v curl >/dev/null; then
  echo "Curl exists"
else 
  sudo apt install -y curl
fi

if command -v git >/dev/null; then
  echo "Git exists"
else 
  sudo apt install -y git
fi


if command -v make >/dev/null; then
  echo "Make exists"
else 
  sudo apt install -y make
fi

if command -v cargo >/dev/null; then
  echo "Cargo exists"
else
  echo "Cargo does not exist, installing rust"
  curl --proto '=https' --tlsv1.2 -ssf https://sh.rustup.rs | sh -s -- -y
  . $HOME/.cargo/env
  rustup default stable
fi


if cargo --list | grep binstall ; then
  echo "Cargo binstall exists"
else
  export BINSTALL_NO_CONFIRM=true
  curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | sh -s -- -y
fi

if command -v just >/dev/null; then
  echo "Just exists"
else 
  cargo binstall just
fi


if cat ${HOME}/.bashrc | grep $HOME/.cargo/env >/dev/null; then 
  echo "$HOME/.cargo/env already exists in ${HOME}/.bashrc"
else
  echo ". $HOME/.cargo/env" >> ${HOME}/.bashrc
fi
