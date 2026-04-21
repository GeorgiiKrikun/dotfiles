export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git aws docker docker-compose extract pip rust kitty z)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

if (( $+commands[xhost] )); then
    xhost +local:docker
fi

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

export USER_ID=1000
export GROUP_ID=1000

export EDITOR="nvim"
