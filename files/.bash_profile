#
# ~/.bash_profile
#
export XDG_CONFIG_HOME=$HOME/.config


GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="/home/user0/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

if [ -d "$HOME/.guix-home/profile/bin" ]; then
	export PATH="$HOME/.guix-home/profile/bin:$PATH"
fi

if [ -d "$HOME/.guix-home/profile/share/info" ]; then
	export INFOPATH="$HOME/.guix-home/profile/share/info:$INFOPATH"
fi

export EDITOR=nvim
export VISUAL=nvim

export XMODIFIERS=@im=fcitx

export PATH="$PATH:$HOME/tmp"


[[ -f ~/.bashrc ]] && . ~/.bashrc


