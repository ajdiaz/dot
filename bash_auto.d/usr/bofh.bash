# This file contains a set of UID 0 commodities

[ $UID -eq 0 ] || return

# Some bad distributions do not append the sbin directories to the path
# when run shell with sudo.
PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin"
export PATH

# We also defined an IRC based usefull functions.
#
#  *  Kick locate the shell of the user(s) specified as arguments and
#     kill them.
#  *  Ban replace the shell of the user(s) provided as arguments with
#     nologin shell.
#
# Obviously you can do ban $user && kick $user, as in old times.
kick ()
{
	while [ "$1" ]; do
		local shell=$(grep "$1" /etc/passwd | cut -f 7 -d':')
		su -c "fuser -k $shell" "$1" 2>&1 >/dev/null
		shift
	done
}

ban ()
{
	while [ "$1" ]; do
		chsh -s "/sbin/nologin" "$1"
		shift
	done
}

# vim:ft=sh:
