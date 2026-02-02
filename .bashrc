# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Prompt
# PS1='\[\033[01;32m\][\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;32m\]]\$\[\033[00m\] '
# Add to .bashrc instead of starship
PS1='\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] '

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Better globbing
shopt -s globstar # ** for recursive globbing
shopt -s nullglob # empty glob = empty array

# Basic aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias n="nvim"
alias find='fd'

# Vi mode if you want it
set -o vi

# Put your fun stuff here.
export PATH="$HOME/.npm-global/bin:$PATH"

source /usr/share/bash-completion/bash_completion
source /usr/share/fzf/key-bindings.bash
source /usr/share/bash-completion/completions/fzf

export TERM=foot-256color
# or if that doesn't work:
export TERM=xterm-256color

# Better fzf defaults in .bashrc
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#b8bb26
  --color=fg:#d5c4a1,header:#b8bb26,info:#fabd2f,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#b8bb26'

# Use fd instead of find for fzf file search (faster, respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Better directory search with fd
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

# eval "$(starship init bash)"
