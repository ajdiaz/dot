# This file is sourced by .bashrc. This script change ulimit and
# security options.

# This actions only works for superuser
if [ $UID -eq 0 ]
then
	# Prevent fork(3) bombs from this user.
	ulimit -u 10000
fi

# -- end -- vim:ft=sh:

