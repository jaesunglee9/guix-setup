#
# ~/.bash_profile
#
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="/home/user0/.config/guix/current"
     . "$GUIX_PROFILE/etc/profile"

export EDITOR=nvim
export VISUAL=nvim

[[ -f ~/.bashrc ]] && . ~/.bashrc


