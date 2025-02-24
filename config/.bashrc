#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME=$HOME/.config

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

source /usr/share/git/git-prompt.sh

export PS1='\n\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]\n$ '

export QSYS_ROOTDIR="/home/jaha/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/23.1/quartus/sopc_builder/bin"

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

