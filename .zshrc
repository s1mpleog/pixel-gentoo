# Uncomment for profiling only
# zmodload zsh/zprof

# History configuration (move to top - lightweight)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

# Environment variables (set early)
export EDITOR='nvim'
export PATH=$PATH:/home/s1mple/.spicetify

# Antidote - only load when regenerating bundles
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Regenerate only when plugin list changes
if [[ ! -f ${zsh_plugins}.zsh ]] || [[ ${zsh_plugins}.txt -nt ${zsh_plugins}.zsh ]]; then
    source ~/.antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Just source the static bundle - no antidote runtime overhead
source ${zsh_plugins}.zsh

# Compile plugin file for faster loading
[[ ! -f ${zsh_plugins}.zsh.zwc ]] || \
   [[ ${zsh_plugins}.zsh -nt ${zsh_plugins}.zsh.zwc ]] && \
    zcompile ${zsh_plugins}.zsh

# Autosuggestions configuration (after plugin load)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Functions
function record() {
    local datetime=$(date +%Y-%m-%d_%H-%M-%S)
    gpu-screen-recorder -w portal -f 60 -k hevc -q 50000 -bm cbr \
        -a default_output \
        -o "$HOME/Videos/recording_${datetime}.mp4"
}

# Aliases
alias cd='z'
alias n='nvim .'
alias ls='eza -a --icons --git --group-directories-first'
alias ll='eza -al --icons --git --header --group'
alias lt='eza -a --tree --level=2 --icons --git-ignore'
alias lt2='eza -a --tree --level=2 --icons'
alias lt3='eza -a --tree --level=3 --icons'
alias llt='eza -al --icons --git --sort=modified --reverse'
alias lls='eza -al --icons --git --sort=size --reverse'
alias lsd='eza -aD --icons'
alias lla='eza -al --icons --git --header --group --extended --octal-permissions'

# Deferred initialization - runs after prompt
function _deferred_init() {
    # Completion system - deferred and cached
    autoload -Uz compinit
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zsh/cache
    
    # Run full compinit only if dump is >24h old or missing
    if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
    else
        compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
    fi
    
    # Compile compdump for faster loading
    [[ "${ZDOTDIR:-$HOME}/.zcompdump" -nt "${ZDOTDIR:-$HOME}/.zcompdump.zwc" ]] && \
        zcompile "${ZDOTDIR:-$HOME}/.zcompdump"
    
    # Other deferred initializations
    compdef eza=ls
    eval "$(zoxide init zsh)"
}

# Schedule deferred init
zsh-defer _deferred_init

# Starship prompt (keep synchronous for instant prompt)
# eval "$(starship init zsh)"
# Replace synchronous starship with instant prompt
eval "$(starship init zsh --print-full-init)"

# Compile .zshrc for faster loading
[[ ! -f ~/.zshrc.zwc ]] || [[ ~/.zshrc -nt ~/.zshrc.zwc ]] && zcompile ~/.zshrc

# Uncomment for profiling only
# zprof
