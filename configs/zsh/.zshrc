export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git aws docker docker-compose extract pip rust kitty z)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
xhost +local:docker

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

export USER_ID=1000
export GROUP_ID=1000

export EDITOR="nvim"


# Start tmux if not already in a session
if [[ -z "$TMUX" && -z "$SSH_TTY" && $- == *i* ]]; then
    tmux attach-session -t default || tmux new-session -s default
fi
