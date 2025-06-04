#!/bin/bash
set -ex

apt update && apt install -y curl build-essential sudo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. $HOME/.cargo/env
rustup default stable
cargo install just

# put cargo into bashrc
#if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' "$HOME/.bashrc"; then
#    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
#fi

echo ". $HOME/.cargo/env" >> ${HOME}/.bashrc


