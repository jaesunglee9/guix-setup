#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias update-system='sudo -E guix system -L ~/projects/public/guix-setup reconfigure ~/projects/public/guix-setup/config/systems/$(hostname).scm'
alias update-home='guix home -L ~/projects/public/guix-setup reconfigure ~/projects/public/guix-setup/config/home/home-config.scm'

export GPG_TTY=$(tty)

export PATH="$PATH:$HOME/tmp"

source ~/.guix-home/profile/bin/git-prompt

export PS1='\n\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]\n$ '

# Automatically added by the Guix install sucript.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi


##################
# Some new bash configuration I have never seen before.

# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
# export SHELL

# if [[ $- != *i* ]]
# then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
#     [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
#     return
# fi

# Source the system-wide file.
# source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
# if [ -n "$GUIX_ENVIRONMENT" ]
# then
#     PS1='\u@\h \w [env]\$ '
# else
#     PS1='\u@\h \w\$ '
# fi

