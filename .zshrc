# History configuration (move to top - lightweight)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

# Environment variables (set early)
export EDITOR='nvim'
export PATH=$PATH:/home/s1mple/.spicetify

# Antidote setup
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

source ~/.antidote/antidote.zsh

# Generate static plugins file only when needed
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source plugins FIRST (this loads zsh-defer)
source ${zsh_plugins}.zsh

# Compile plugin file for faster loading
[[ ! -f ${zsh_plugins}.zsh.zwc ]] || [[ ${zsh_plugins}.zsh -nt ${zsh_plugins}.zsh.zwc ]] && \
    zcompile ${zsh_plugins}.zsh

# Completion system - optimized
autoload -Uz compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Only run full compinit (with security checks) once per day
# Use -C (skip checks) for all other loads
for dump in ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24); do
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
done
if [[ -s "${ZDOTDIR:-$HOME}/.zcompdump" ]]; then
    compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# Compile for faster loading
if [[ ! -f "${ZDOTDIR:-$HOME}/.zcompdump.zwc" ]] || \
   [[ "${ZDOTDIR:-$HOME}/.zcompdump" -nt "${ZDOTDIR:-$HOME}/.zcompdump.zwc" ]]; then
    zcompile "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# Autosuggestions configuration (after plugin load)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Lazy-load expensive commands
function record() {
    local datetime=$(date +%Y-%m-%d_%H-%M-%S)
    gpu-screen-recorder -w portal -f 60 -k hevc -q 50000 -bm cbr \
        -a default_output \
        -o "$HOME/Videos/recording_${datetime}.mp4"
}

# Aliases (cheap - keep as-is)
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

# Defer expensive initialization (load after prompt appears)
function _deferred_init() {
    compdef eza=ls
    eval "$(zoxide init zsh)"
}

# Schedule deferred init to run after prompt (NOW zsh-defer is loaded)
zsh-defer _deferred_init

# Starship (keep at end - it's already fast)
eval "$(starship init zsh)"
