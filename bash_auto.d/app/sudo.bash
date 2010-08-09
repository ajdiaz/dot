# This file contains a set of commodities to use with
# program sudo(1).

# If sudo(1) no installed into PATH then skip the content
# of this file and continue loading other bash_autoload.d
# scripts.
if ! installed sudo
	then return 0
fi

# Wraper over standard sudo application, this wrapper do
# not decrease the implicit security.
sudo () {
	local _oldPATH="$PATH"
	export PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin"
	if [ $# -gt 0 ]
	then
		command sudo "$@"
	else
		command sudo -s
 	fi
 	local ret=$?
 	export PATH="$_oldPATH"
 	return $ret
}

# vim:ft=sh:
