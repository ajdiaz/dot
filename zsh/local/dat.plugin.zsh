#! /bin/zsh
# Sync data file using rclone
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

: ${DATDIR:=${HOME}/dat}

typeset -gA _dat_cmd

dat () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		dat help
		return
	fi

	local cmd=$1 fname="_dat-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
		echo "The subcommand '${cmd}' is not defined" 1>&2
	fi
}

_dat_cmd[pull]='Pull changes from remote'
_dat-pull () {
	if [[ ! -r .dat.conf ]] ; then
		echo 'No dat.conf file present' 1>&2
		return 1
  else
    local _dat_remote
    read -r _dat_remote < .dat.conf
  fi

  rclone copy -u "${_dat_remote}" .
}

_dat_cmd[push]='Push changes to remote'
_dat-push () {
	if [[ ! -r .dat.conf ]] ; then
		echo 'No dat.conf file present' 1>&2
		return 1
  else
    local _dat_remote
    read -r _dat_remote < .dat.conf
  fi

  # Experimental TPS parameters. Works in practice and avoid
  # 408 errors related with timeouts.
  rclone --tpslimit 23 --tpslimit-burst 1 sync -u . "${_dat_remote}"
}

_dat_cmd[help]='Show usage information'
_dat-help () {
	cat <<-EOF
	Usage: dat <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_dat_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_dat_cmd[${cmd}]}"
	done
	echo
}

readonly _dat_cmd
