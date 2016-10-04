#! /bin/zsh
# Distributed under terms of the GPLv3 license.

: ${LOADENV_HOME:=${HOME}/.local/share/ez}

typeset -gA _loadenv_cmd

ez () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		vz help
		return
	fi

	local cmd=$1 fname="_loadenv-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
		echo "The subcommand '${cmd}' is not defined" 1>&2
	fi
}

_loadenv_cmd[activate]='Activate a loadenv'
_loadenv-activate () {
	if [[ $# -ne 1 ]] ; then
		echo 'No loadenv specified.' 1>&2
		return 1
	fi

	# If a loadenv is in use, deactivate it first
	if [[ ${LOADENV_ENV:+set} = set ]] ; then
		_loadenv-deactivate
	fi

	LOADENV_ENV_NAME="$1"
	LOADENV_ENV="${LOADENV_HOME}"

	while read line
	do
	  eval "export $line"
  done < <(PASSWORD_STORE_DIR="${LOADENV_ENV}" pass show "$1")
}

_loadenv_cmd[deactivate]='Deactivate the active loadenv'
_loadenv-deactivate () {
	if [[ ${LOADENV_ENV:+set} != set ]] ; then
		echo 'No loadenv is active.' 1>&2
		return 1
	fi

	while read line
	do
	  IFS='=' read key _ <<< "$line"
	  eval unset "$key"
  done < <(PASSWORD_STORE_DIR="${LOADENV_HOME}" pass show "$LOADENV_ENV_NAME")

	unset LOADENV_ENV LOADENV_ENV_NAME
}

_loadenv_cmd[rm]='Delete a loadenv'
_loadenv-rm () {
	if [[ $# -lt 1 ]] ; then
		echo 'No loadenv specified.' 1>&2
		return 1
	fi
	if [[ ${LOADENV_ENV_NAME} = $1 ]] ; then
		echo 'Cannot delete loadenv while in use' 1>&2
		return 2
	fi

	PASSWORD_STORE_DIR="${LOADENV_HOME}" pass rm "$1"
}

_loadenv_cmd[ls]='List available loadenvs'
_loadenv-ls () {
	if [[ -d ${LOADENV_HOME} ]] ; then
	  PASSWORD_STORE_DIR="${LOADENV_HOME}" pass ls
	fi
}

_loadenv_cmd[help]='Show usage information'
_loadenv-help () {
	cat <<-EOF
	Usage: ez <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_loadenv_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_loadenv_cmd[${cmd}]}"
	done
	echo
}

readonly _loadenv_cmd
