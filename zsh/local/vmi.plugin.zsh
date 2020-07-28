#! /bin/zsh
# Helper to run local machines
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

typeset -gA _vmi_cmd


vmi () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		vmi help
		return
	fi

	local cmd=$1 fname="_vmi-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
	  sudo machinectl --no-pager "$@"
	fi
}

_vmi_cmd[new]='Create VM image from running vm'
_vmi-new () {
  __get_root_dir () {
    machinectl --no-legend --no-pager show "$1" | while read -r a; do
      case "$a" in
        RootDirectory=*) echo "${a#*=}"; return;;
      esac
    done
  }
	if [[ $# -lt 2 ]] ; then
    echo "VM id and image name is required" 1>&2
    return 2
  fi
  local vmid="$1" name="$2"
  rootdir="$(__get_root_dir "$1")"
  sudo btrfs subvolume snapshot "$rootdir" "/var/lib/machines/$2"
}

_vmi_cmd[ls]='List vm images'
_vmi-ls () {
  sudo machinectl --no-pager --no-legend list-images |
  while read -r a _; do echo "$a"; done
}

_vmi_cmd[rm]='Remove vm image'
_vmi-rm () {
	if [[ $# -lt 1 ]] ; then
    echo "VM image name is required" 1>&2
    return 2
  else
    sudo btrfs subvolume delete "/var/lib/machines/$1"
	fi
}

_vmi_cmd[help]='Show usage information'
_vmi-help () {
	cat <<-EOF
	Usage: vmi <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_vmi_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_vmi_cmd[${cmd}]}"
	done
	cat <<-EOF

	Any other command will be passed to machinectl.
	EOF
}

readonly _vmi_cmd
_vmi () {
  __get_available_machines () {
    machinectl --no-pager --no-legend list | {
      while read -r a b
      do
        echo $a
      done
    }
  }

  __get_available_images () {
   machinectl --no-pager --no-legend list-images | {
      while read -r a _
      do
        echo $a
      done
    }
  }

 local -a vmi_commands
  for cmd in ${(k)_vmi_cmd[@]} ; do
    vmi_commands=( "${vmi_commands[@]}" "${cmd}:${_vmi_cmd[${cmd}]}" )
  done

  typeset -A opt_args
  local state

  _arguments \
    "1: :{_describe 'command' vmi_commands}" \
    '*:: :->args'

  case ${words[1]} in
    new)
      local -a vmi_list=( $(__get_available_machines) )
      _arguments "1: :{_describe 'vmi' vmi_list}"
      ;;
    rm)
      local -a vmi_list=( $(__get_available_images) )
      _arguments "1: :{_describe 'vmi' vmi_list}"
      ;;
  esac
}

compdef _vmi vmi
