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
if [[ -z "$TMUX" && -z "$SSH_TTY" && $- == *i* && -z "$SKIP_TMUX" ]]; then
    SESSION_NAME=${TMUX_SESSION:-default}
    if command -v tmux >/dev/null; then
        tmux attach-session -t "$SESSION_NAME" || tmux new-session -s "$SESSION_NAME"
        # If the session was closed (not just detached), exit the shell to close the terminal
        if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
            exit
        fi
    fi
fi
