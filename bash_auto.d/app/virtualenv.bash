# This file is sourced by .bashrc. This script provide a suite
# of virtualenv(1) utilities.

[ -r /usr/local/bin/virtualenvwrapper.sh ] && \
	. /usr/local/bin/virtualenvwrapper.sh

WORKON_HOME="${WORKON_HOME:-${HOME}/env}"
[ -d "${WORKON_HOME}" ] || mkdir -p "${WORKON_HOME}"

