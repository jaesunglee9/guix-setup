#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME=$HOME/.config

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias update-system='sudo guix system -L ~/projects/personal/public/guix-setup reconfigure ~/projects/personal/public/guix-setup/guix-config/systems/$(hostname).scm'
alias update-home='guix home -L ~/projects/personal/public/guix-setup reconfigure ~/projects/personal/public/guix-setup/guix-config/home/home-config.scm'
# PS1='[\u@\h \W]\$ '

source /usr/share/git/git-prompt.sh

export PS1='\n\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]\n$ '

# hopefully remove it later
export JAVA_HOME=/usr/lib/jvm/java-22-openjdk
export PATH=$JAVA_HOME/bin:$PATH

export RISCV=/opt/riscv
export PATH=$RISCV/bin:$PATH

[ -f "/home/jaha/.ghcup/env" ] && . "/home/jaha/.ghcup/env" # ghcup-env

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

