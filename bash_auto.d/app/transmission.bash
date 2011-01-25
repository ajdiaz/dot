# This file is sourced by .bashrc. This script provide a suite
# of transmission(1) specified utils.

if ! installed transmission-remote; then
	return 0
fi

alias btlist="transmission-remote -l"
