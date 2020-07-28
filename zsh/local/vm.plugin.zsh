#! /bin/zsh
# Helper to run local machines
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

typeset -gA _vm_cmd

_vm_name ()
{
  printf "%04x" "${RANDOM}"
}

vm () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		vm help
		return
	fi

	local cmd=$1 fname="_vm-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
	  sudo machinectl --no-pager "$@"
	fi
}

_vm_cmd[new]='Starting vm'
_vm-new () {
  local image=/
  local bind_home=("--bind" "${HOME}")
  local opts=()

  while [[ "$1" ]] && [[ "${1:0:2}" == "--" ]]; do
    case "$1" in
      --allow-docker)
        opts+=("--bind" "/sys/fs/cgroup")
        opts+=("--capability" "all")
        opts+=("--system-call-filter" "add_key keyctl")
        shift;;
      --no-bind-home)
        bind_home=(); shift;;
      --image*)
          image="/var/lib/machines/${1#*=}";
          if [[ "${1#*=}" == "$1" ]]; then
            image="/var/lib/machines/$2"
            if [[ ! "$image" ]]; then
              echo "--image require argument" 1>&2
              return 2
            fi
            shift
          fi
          shift
          ;;
        *)
          echo "unknown option $1" 1>&2
          return 2
          ;;
      esac
  done

  if ! sudo test -d "${image}"; then
    echo "unknown image ${image}" 1>&2
    return 1
  fi

  local name
	if [[ $# -ne 1 ]] ; then
    name="$(_vm_name)"
  else
    name="$1"
  fi

  sudo systemd-run -E SYSTEMD_NSPAWN_USE_CGNS=0 --unit="vm-$name" \
    systemd-nspawn \
      -M "vm-$name" -n -xb \
      -E VM_NAME="vm-$name" \
      -D "${image}" \
      --bind /var/cache/pacman/pkg/ \
      "${bind_home[@]}" "${opts[@]}"
}

_vm_cmd[ls]='List vms'
_vm-ls () {
  sudo machinectl --no-pager --full --no-legend list |
  while read -r a _; do echo "$a"; done
}

_vm_cmd[rm]='Remove vm'
_vm-rm () {
	if [[ $# -lt 1 ]] ; then
    echo "VM id is required" 1>&2
    return 2
  else
    local vmid="$1"; shift
    sudo machinectl --no-pager stop "$vmid"
	fi
}

_vm_cmd[sh]='Run command inside vm or open a shell'
_vm-sh () {
	if [[ $# -lt 1 ]] ; then
    echo "VM id is required" 1>&2
    return 2
  else
    local vmid="$1"; shift

    if [[ $# -eq 0 ]]; then
      set -- "$SHELL"
    fi

    sudo machinectl --no-pager \
      -E TERM="$TERM" \
      -E VM_NAME="$vmid" \
      shell "$LOGNAME@$vmid" "$@"
	fi
}

_vm_cmd[help]='Show usage information'
_vm-help () {
	cat <<-EOF
	Usage: vm <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_vm_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_vm_cmd[${cmd}]}"
	done
	cat <<-EOF

	Any other command will be passed to machinectl.
	EOF
}

readonly _vm_cmd
_vm () {
  __get_available_machines () {
    machinectl --no-pager --no-legend list | {
      while read -r a b
      do
        echo $a
      done
    }
  }

 local -a vm_commands
  for cmd in ${(k)_vm_cmd[@]} ; do
    vm_commands=( "${vm_commands[@]}" "${cmd}:${_vm_cmd[${cmd}]}" )
  done

  typeset -A opt_args
  local state

  _arguments \
    "1: :{_describe 'command' vm_commands}" \
    '*:: :->args'

  case ${words[1]} in
    new)
      local -a vm_list=( "--image" "--no-bind-home" )
      _arguments "1: :{_describe 'vm' vm_list}"
      ;;
    sh|rm)
      local -a vm_list=( $(__get_available_machines) )
      _arguments "1: :{_describe 'vm' vm_list}"
      ;;
  esac
}

compdef _vm vm
