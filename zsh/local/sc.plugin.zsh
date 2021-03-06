#! /bin/zsh
# Helper to open root (or not) shell
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.


: ${SC_HOME:=${HOME}/var/demo}

typeset -gA _sc_cmd

sc () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		sc help
		return
	fi

	local cmd=$1 fname="_sc-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
		echo "The subcommand '${cmd}' is not defined" 1>&2
	fi
}

_sc_cmd[rec]='Starting a script recording'
_sc-rec () {
	if [[ $# -ne 1 ]] ; then
		echo 'No name specified.' 1>&2
		return 1
	fi

	local rec_path="${SC_HOME}/$1"

	if [[ -d "$rec_path" ]]; then
	  echo 'Record name already exists.' 1>&2
	  return 1
	else
	  mkdir -p "${rec_path}"
    script -e -a -T "${rec_path}/timing" -B "${rec_path}/content"
  fi
}

_sc_cmd[play]='Replay a saved record'
_sc-play () {
	if [[ $# -lt 1 ]] ; then
		echo 'No name specified.' 1>&2
		return 1
	fi

  if [[ -d "${SC_HOME}/$1" ]]; then
    echo "======================================="
    scriptreplay -T "${SC_HOME}/$1/timing" \
                 -B "${SC_HOME}/$1/content" ${2:+-d "$2"}
    echo "======================================="
  else
    echo 'Record not found.' 1>&2
    return 1
  fi
}

_sc_cmd[ls]='List recorded scripts'
_sc-ls () ( cd "${SC_HOME}" && tree -d; )


_sc_cmd[rm]='Delete a recorded script'
_sc-rm () {
	if [[ $# -lt 1 ]] ; then
		echo 'No name specified.' 1>&2
		return 1
	fi

	if [[ -d "${SC_HOME}/$1" ]]; then
	  rm -rf "${SC_HOME}/$1"
	else
	  echo 'Record not found' 1>&2
	fi
}

_sc_cmd[help]='Show usage information'
_sc-help () {
	cat <<-EOF
	Usage: sc <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_sc_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_sc_cmd[${cmd}]}"
	done
	echo
}

_sc () {
  local -a sc_commands
  for cmd in ${(k)_sc_cmd[@]} ; do
    sc_commands=( "${sc_commands[@]}" "${cmd}:${_sc_cmd[${cmd}]}" )
  done

  typeset -A opt_args
  local state

  _arguments \
    "1: :{_describe 'command' sc_commands}" \
    '*:: :->args'

  case ${words[1]} in
    play | rm)
      local -a sc_records=( $(sc ls) )
      _arguments "1: :{_describe 'sc' sc_records}"
      ;;
  esac
}

compdef _sc sc
