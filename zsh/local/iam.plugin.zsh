#! /bin/zsh
# Distributed under terms of the GPLv3 license.

IAM_HOME="${IAM_HOME:-${HOME}/.local/share/iam}"
IAM_GPGKEY= # use by default

typeset -gA _iam_cmd

_iam_gpg_e ()
{
  local gpgopts=( "${GPGOPTIONS[@]}" )

  if [[ "$IAM_GPGKEY" ]]; then
    gpgopts+=( "--recipient" "${IAM_GPGKEY}" "--local-user" "${IAM_GPGKEY}" )
  else
    local gpg_key="$(<${IAM_HOME}/${IAM_ID_NAME}.gpg-id)"
    gpgopts+=( 
      "--recipient" "${gpg_key}"
      "--local-user" "${gpg_key}"
    )
  fi

  gpg --batch --no-tty --quiet --no-verbose \
    --encrypt --armor ${gpgopts[@]} -o "$2" "$1"
}

_iam_gpg_d ()
{
  local gpgopts=( "${GPGOPTIONS[@]}" )

  if [[ "$IAM_GPGKEY" ]]; then
    gpgopts+=( "--local-user" "${IAM_GPGKEY}" )
  else
    gpgopts+=( "--local-user" "$(<${IAM_HOME}/${IAM_ID_NAME}.gpg-id)" )
  fi

  gpg --quiet --no-verbose --decrypt ${gpgopts[@]} "$1" > "$2"
}

iam () {
	if [[ $# -eq 0 || $1 = --help || $1 == -h ]] ; then
		iam help
		return
	fi

	local cmd=$1 fname="_iam-$1"
	shift

	if typeset -fz "${fname}" ; then
		"${fname}" "$@"
	else
		echo "The subcommand '${cmd}' is not defined" 1>&2
	fi
}

_iam_cmd[activate]='Activate a virtual id'
_iam-activate () {
	if [[ $# -ne 1 ]] ; then
		echo 'No virtual id specified.' 1>&2
		return 1
	fi

	local iam_path="${IAM_HOME}/$1"
	if [[ ! -d ${iam_path} ]] ; then
		echo "The virtual id '$1' does not exist." 1>&2
		return 2
	fi

	# If a virtual id is in use, deactivate it first
	if [[ -r "${IAM_HOME}/.previous" ]] ; then
		_iam-deactivate
	fi

	IAM_ID_NAME=$1
	IAM_ID=${iam_path}

  _iam-new ".previous"

  local dpath hpath fname
  {
    while read -r fname; do
      hpath="${HOME}${fname#${iam_path}}"
      dpath="${hpath%/*}"

      # save current file to .previous
      if [[ -r "$hpath" ]]; then
        _iam-add ".previous" "$hpath"
      fi

      # replace file for new one
      [[ -d "$dpath" ]] || mkdir -p "$dpath"
      _iam_gpg_d "$fname" "$hpath"
    done < <(find "${iam_path}" -type f)
  }
  echo "${IAM_ID_NAME}" > "${IAM_HOME}/.active"
}

_iam_cmd[add]='Add a file to the specific iam'
_iam-add () {
	if [[ $# -ne 2 ]] ; then
		echo 'No virtual id specified or missing file to add' 1>&2
		return 1
	fi

	local iam_path="${IAM_HOME}/$1"
	if [[ ! -d ${iam_path} ]] ; then
		echo "The virtual id '$1' does not exist." 1>&2
		return 2
	fi

	if [[ -d "$2" ]]; then
	  for item in "$2"/* "$2"/.*; do
	    [[ -e "$item" ]] && _iam-add "$1" "$item"
	  done
    return
  fi

  local p="$(realpath "$2")"
  local p="${iam_path}${p#${HOME}}"

  mkdir -p "${p%/*}"
  IAM_ID_NAME="$1" _iam_gpg_e "$(realpath "$2")" "${p}"
}

_iam_cmd[deactivate]='Deactivate the active virtual id'
_iam-deactivate () {
	if [[ ! -r "${IAM_HOME}/.previous" ]] ; then
		echo 'No virtual id is active.' 1>&2
		return 1
	fi

  local active="${IAM_HOME}/$(<${IAM_HOME}/.active)"
  if [[ ! -r "${active}" ]]; then
    echo 'Active virtual id not found'
    return 2
  fi

  # Remove current file
  local iam_path="${active}"
  local dpath hpath fname
  if [[ ! -d "$iam_path" ]]; then
    echo 'Unable to deactivate. Active IAM does not exist' 1>&2
    return 3
  fi

  while read -r fname; do
    hpath="${HOME}${fname#${iam_path}}"
    dpath="${hpath%/*}"

    rm -f "$hpath"
    if [[ -z "$(ls -A "$dpath")" ]]; then
      rmdir "$dpath"
    fi
  done < <(find "${iam_path}" -type f)


  # Restore previous
  local iam_path="${IAM_HOME}/.previous"
  while read -r fname; do
    hpath="${HOME}${fname#${iam_path}}"
    dpath="${hpath%/*}"

    # replace file for new one
    [[ -d "$dpath" ]] || mkdir -p "$dpath"
    _iam_gpg_d "$fname" "$hpath"
  done < <(find "${iam_path}" -type f)

  rm -rf "$iam_path"
  rm -ff "${IAM_HOME}/.active"

	unset IAM_ID IAM_ID_NAME
}

_iam_cmd[new]='Create a new virtual id'
_iam-new () {
	if [[ $# -lt 1 ]] ; then
		echo 'No virtual id specified.' 1>&2
		return 1
	fi

	local iam_name="$1"
	local iam_path="${IAM_HOME}/${iam_name}"
	mkdir -p "${iam_path}"
  echo "${2:-$(gpgconf --list-options gpg |
               awk -F: '$1 == "default-key" {print $10}' |
               cut -d '"' -f2)}" > "${IAM_HOME}/${iam_name}.gpg-id"

  if [[ "${iam_name:0:1}" != "." ]]; then
    _iam-git add "${iam_name}.gpg-id"
    _iam-git commit -a -m"Add new virtual id: ${iam_name}"
  fi
}

_iam_cmd[rm]='Delete a virtual id'
_iam-rm () {
	if [[ $# -lt 1 ]] ; then
		echo 'No virtual id specified.' 1>&2
		return 1
	fi
	if [[ ${IAM_ID_NAME} = $1 ]] ; then
		echo 'Cannot delete virtual id while in use' 1>&2
		return 2
	fi

	local iam_path="${IAM_HOME}/$1"
	if [[ ! -d ${iam_path} ]] ; then
		echo "The virtual id '$1' does not exist." 1>&2
		return 3
	fi

	rm -rf "${iam_path}"
}

_iam_cmd[ls]='List available virtual ids'
_iam-ls () {
	if [[ -d ${IAM_HOME} ]] ; then
		pushd -q "${IAM_HOME}"
    find . -maxdepth 1 ! -name ".*" -type d ! -path . -printf "%P\n"
		popd -q
	fi
}

_iam_cmd[cd]='Change to the directory of the active virtual id'
iam-cd () {
	if [[ ${IAM_ID:+set} != set ]] ; then
		echo 'No virtualv is active.' 1>&2
		return 1
	fi
	cd "${IAM_ID}"
}

_iam_cmd[git]='Run git commands inside the iam home directory'
_iam-git () {
  ( cd "${IAM_HOME}" && git "$@"; )
}

_iam_cmd[reload]='Reload last state of virtual ids'
_iam-reload ()
{
  if [[ -r "${IAM_HOME}/.previous" ]]; then
    IAM_ID_NAME="$(<"${IAM_HOME}/.active")"
    IAM_ID="${IAM_HOME}/${IAM_ID_NAME}"
  else
    unset IAM_ID_NAME
    unset IAM_ID
  fi
}

_iam_cmd[help]='Show usage information'
_iam-help () {
	cat <<-EOF
	Usage: iam <command> [<args>]

	Available commands:

	EOF
	for cmd in ${(k)_iam_cmd[@]} ; do
		printf "  %-12s %s\n" "${cmd}" "${_iam_cmd[${cmd}]}"
	done
	echo
}

readonly _iam_cmd
precmd_functions+=(_iam-reload)
