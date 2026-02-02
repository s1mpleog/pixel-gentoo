# Uncomment for profiling only
# zmodload zsh/zprof

# History configuration (move to top - lightweight)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE

# Environment variables (set early)
export EDITOR='nvim'
export PATH=$PATH:/home/s1mple/.spicetify
export PATH="$HOME/.local/bin:$PATH"


export TERM=xterm-256color

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
# ZSH_AUTOSUGGEST_USE_ASYNC=1
# ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '-e'
bindkey '^?' backward-delete-char  # Backspace
bindkey '^[[3~' delete-char        # Delete
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[1;5C' forward-word     # Ctrl+Right
bindkey '^[[1;5D' backward-word    # Ctrl+Left

# Functions
function record() {
    local datetime=$(date +%Y-%m-%d_%H-%M-%S)
    gpu-screen-recorder -w portal -f 60 -k hevc -q 50000 -bm cbr \
        -a default_output \
        -o "$HOME/Videos/recording_${datetime}.mp4"
}

# Aliases
alias cd='z'
alias ls='eza -a --icons --git --group-directories-first'
alias ll='eza -al --icons --git --header --group'
alias lt='eza -a --tree --level=2 --icons --git-ignore'
alias lt2='eza -a --tree --level=2 --icons'
alias lt3='eza -a --tree --level=3 --icons'
alias llt='eza -al --icons --git --sort=modified --reverse'
alias lls='eza -al --icons --git --sort=size --reverse'
alias lsd='eza -aD --icons'
alias lla='eza -al --icons --git --header --group --extended --octal-permissions'

alias n="nvim"


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

 # fzf - use official key bindings if available, otherwise manual
    if [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
        source /usr/share/fzf/shell/key-bindings.zsh
    elif [[ -f ~/.fzf/shell/key-bindings.zsh ]]; then
        source ~/.fzf/shell/key-bindings.zsh
    else
        # Fallback to manual bindings only if official ones don't exist
        if command -v fzf &> /dev/null; then
            fzf-history-widget() {
                local selected
                #selected=$(fc -rl 1 | fzf +s --query="$LBUFFER")
                selected=$(fc -rl 1 | fzf +s --query="$LBUFFER" --no-hscroll --bind 'ctrl-/:toggle-preview' --preview 'echo {}' --preview-window 'hidden:wrap')
               
                # selected=$(fc -rl 1 | fzf +s --query="$LBUFFER")

                # selected=$(fc -rl 1 | fzf +s --query="$LBUFFER" --no-multi --wrap)
                if [[ -n $selected ]]; then
                    LBUFFER=$(echo $selected | sed 's/^[ ]*[0-9]*\*\?[ ]*//')
                fi
                zle reset-prompt
            }
            zle -N fzf-history-widget
            bindkey '^R' fzf-history-widget
        fi
    fi
    
    fpath+=/usr/share/zsh/site-functions

export FZF_DEFAULT_OPTS='
  --layout=reverse
  --border
  --inline-info
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#b8bb26
  --color=fg:#d5c4a1,header:#b8bb26,info:#fabd2f,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#b8bb26'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'


[ -s "/home/s1mple/.bun/_bun" ] && source "/home/s1mple/.bun/_bun"
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

# bun completions


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
