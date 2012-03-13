# This file is sourced by .bashrc. This script provide a suite
# of screen(1) specified utils.

if ! installed screen
then return 0
fi

sshc ()
{
	ssh "$@" -t screen
}

# -- end -- vim:ft=sh:

