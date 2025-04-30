#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias update-system='sudo guix system -L ~/projects/public/guix-setup reconfigure ~/projects/public/guix-setup/guix-config/systems/$(hostname).scm'
alias update-home='guix home -L ~/projects/public/guix-setup reconfigure ~/projects/public/guix-setup/guix-config/home/home-config.scm'
# PS1='[\u@\h \W]\$ '

source ~/.guix-home/profile/bin/git-prompt

export PS1='\n\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]\n$ '

# scala specific configuration. remove if unneeded, along with sbt folder in home.
export SBT_HOME=~/sbt
export PATH=$SBT_HOME/bin:$PATH

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

