# This file is sourced by .bashrc. This script provide a suite
# of virtualenv(1) utilities.

bin="$(type -P virtualenvwrapper.sh)"

[ "${bin}" -a -r "${bin}" ] && . "${bin}"

WORKON_HOME="${WORKON_HOME:-${HOME}/env}"
[ -d "${WORKON_HOME}" ] || mkdir -p "${WORKON_HOME}"

