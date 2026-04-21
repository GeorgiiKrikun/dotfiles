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

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Toggleable prompt logic
PROMPT_STATE="minimal"
setopt PROMPT_SUBST

# We use a hook to ensure our prompt is set after any other theme hooks (like Oh My Zsh)
_update_prompt() {
    local arrow='%(?.%F{green}%B➜%b%f.%F{red}%B➜%b%f)'
    if [[ "$PROMPT_STATE" == "minimal" ]]; then
        PROMPT="${arrow} %f%b%k"
        RPROMPT=""
    else
        local user_host='%F{cyan}%n@%m%f'
        local path_info='%F{yellow}%~%f'
        PROMPT="${arrow} ${user_host}:${path_info} \$(git_prompt_info) %f%b%k"
        RPROMPT="%F{blue}%D{%H:%M:%S}%f"
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

# Ensure it's registered as a precmd hook to avoid being overridden
autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_prompt

# Alias for convenience
alias tp=toggle_prompt
