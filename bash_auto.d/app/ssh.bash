# This file is sourced by .bashrc. This script provide a suite
# of ssh(1) specified utils.

if ! installed ssh
then return 0
fi

_ports=()
port () {
	local l="$1" && shift
	[ "$1"  != "via" ] && local r="$1" && shift; shift
	[ "$1" ] && [ "$l" ] || { 
		echo "usage: port <port> [remote_addr:port] via [user@]gw[:port]">&2
		return 2
	}
	local r="${r:=127.0.0.1:${l%%:*}}"
	ssh -N -T "-L${l}:${r}" "$1" &
	_ports[$!]="[$!] $l to $r via $1"
}

ports () {
	for x in "${_ports[@]}"; do
		echo "$x"
	done
}

pclose () {
	[ "$1" ] || {
		echo "usage: pclose <id>">&2
		return 2
	}
	kill "$1" && unset _ports[$1]
}

