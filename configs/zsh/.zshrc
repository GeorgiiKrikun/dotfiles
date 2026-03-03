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

# Toggleable prompt logic
PROMPT_STATE="minimal"
setopt PROMPT_SUBST

_update_prompt() {
    if [[ "$PROMPT_STATE" == "minimal" ]]; then
        PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) '
        RPROMPT=''
    else
        PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%n@%m:%{$fg[yellow]%}%~%{$reset_color%} $(git_prompt_info) '
        RPROMPT='%{$fg[blue]%}%D{%H:%M:%S}%{$reset_color%}'
    fi
}

toggle_prompt() {
    if [[ "$PROMPT_STATE" == "minimal" ]]; then
        PROMPT_STATE="full"
        echo "Prompt set to FULL"
    else
        PROMPT_STATE="minimal"
        echo "Prompt set to MINIMAL"
    fi
    _update_prompt
}

# Alias for convenience
alias tp=toggle_prompt

# Initial prompt setup
_update_prompt
