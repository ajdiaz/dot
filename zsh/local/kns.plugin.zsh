#! /bin/zsh
# Distributed under terms of the GPLv3 license.

[[ "$(type -p kubectl)" ]] || return


typeset -gA _kns_cmd

export KNS_CONTEXT KNS_NAMESPACE

alias k=kubectl

kns () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		kub help
		return
	fi

	local cmd=$1 fname="_kns-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
		echo "The subcommand '${cmd}' is not defined" 1>&2
	fi
}

_kns_cmd[activate]='Activate a kubernetes context namespace'
_kns-activate () {
	if [[ $# -lt 1 ]] ; then
		echo 'No context namespace specified.' 1>&2
		return 1
	fi

	if [[ $# -eq 1 ]] && [[ "$KNS_CONTEXT" ]]; then
	  KNS_NAMESPACE="$1"
	  return 0
	fi

	if [[ ! -r ~/".kube/config-${1}.yaml" ]]; then
	  echo "Context ${1} does not exists." 1>&2
	  return 1
	fi

	KNS_CONTEXT="$1"
	KNS_NAMESPACE="${2:-default}"
}

_kns_cmd[new]='Create new kubernetes config file'
_kns-new () {
	if [[ $# -lt 1 ]] ; then
		echo 'No context name specified.' 1>&2
		return 1
	fi

  if [[ "$2" ]] && [[ -r "$2" ]]; then
    cp "$2" ~/".kube/config-${1}.yaml"
  else
	  ${EDITOR:-vim}  ~/".kube/config-${1}.yaml"
	fi
}

_kns_cmd[deactivate]='Deactivate the current context/namspace'
_kns-deactivate () {
	unset KNS_CONTEXT KNS_NAMESPACE
  _kns_namespaces=()
}

_kns_cmd[rm]='Delete a kubernetes context'
_kns-rm () {
	if [[ $# -lt 1 ]] ; then
		echo 'No contesxt name specified.' 1>&2
		return 1
	fi

	if [[ "$1" = "$KNS_CONTEXT" ]]; then
	  kub deactivate
	fi

	rm -rf  ~/".kube/config-${1}.yaml"
}

_kns_cmd[ls]='List available contexts"'
_kns-ls () {
  [[ ! -d ~/.kube ]] && return 0
  pushd -q ~/.kube
  local var=
  while read -r line; do
    var="${line#config-}"; echo "${var%.yaml}"
  done < <(find . -maxdepth 1 -name "config-*.yaml" \
                   -type f ! -path . -printf "%P\n")
  popd -q
}

_kns_cmd[help]='Show usage information'
_kns-help () {
	cat <<-EOF
	Usage: kub <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_kns_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_kns_cmd[${cmd}]}"
	done
	echo
}

readonly _kns_cmd
precmd_functions+=(_kns-reload)

kubectl () {
  declare -a args=()
  if [[ "${KNS_CONTEXT}" ]]; then
    args+=( "--kubeconfig" "${HOME}/.kube/config-${KNS_CONTEXT}.yaml" )
  fi
  if [[ "${KNS_NAMESPACE}" ]]; then
    args+=( "--namespace" "${KNS_NAMESPACE}" )
  fi

  command kubectl "${args[@]}" "$@"
}
