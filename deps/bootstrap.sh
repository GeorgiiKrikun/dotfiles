#!/bin/bash
set -ex

apt update && apt install -y curl build-essential sudo git
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. $HOME/.cargo/env
rustup default stable
cargo install just

echo ". $HOME/.cargo/env" >> ${HOME}/.bashrc


