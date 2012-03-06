# This file is sourced by .bashrc. This script provide a suite
# of transmission(1) specified utils.

if ! installed transmission-remote; then
	return 0
fi

btrm () { transmission-remote -t "$1" --remove; }
btinfo () { transmission-remote -t "$1" --info; }
btstart () { transmission-remote -t "$1" -s; }
btstop () { transmission-remote -t "$1" -S; }

alias btlist="transmission-remote -l"

