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
PS1='\[\033[01;32m\][\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;32m\]]\$\[\033[00m\] '

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

# Vi mode if you want it
set -o vi

# Put your fun stuff here.
export PATH="$HOME/.npm-global/bin:$PATH"

source /usr/share/bash-completion/bash_completion
source /usr/share/fzf/key-bindings.bash
source /usr/share/bash-completion/completions/fzf
