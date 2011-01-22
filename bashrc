# bash_auto
# ---------
# (c) 2006-2008  Connectical Labs.
# Andrés J. Díaz, Adrián Pérez de Castro
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen!
#
# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain
# from outputting anything in those cases.

# **If you want to specified some personal options, see
# ``.bash-auto.d`` directory**
auto_dir=${BASH_AUTODIR:-~/.bash_auto.d}

# This bash_auto only works with bash >= 3.0
[ "${BASH_VERSION:-0}" '<' "3" ] && return 1

# If not exists the directory autoload, then do nothing.
[ ! -d "$auto_dir" ] && return

# Define some usefull functions
mute () { "$@" 2>/dev/null >/dev/null; }
installed () { type -p "$1" 2>&1 > /dev/null; }
declared () {
	declare -p "$1" >/dev/null 2>/dev/null ||
	declare -f "$1" >/dev/null 2>/dev/null;
}

# Clean ``prompt`` variable. This is a precondition to prompt file
# in bash_auto.d if exists.
prompt=

# Set special variables to autoload plugins. This variables must not be
# exported.
OS="$( uname )"
LINUX="$(  cat /etc/*-release 2>/dev/null )"
HOST="${HOSTNAME}"
USER="${LOGNAME}"
FROM="${SSH_CLIENT%% *}"

shopt -s extglob

# The ``for`` is muted (redirected to ``/dev/null``) to prevent
# unusefull errors if directory does not exists. I consider ugly
# practice to save this messages.
for in_script in $(find "$auto_dir/" -iname "*.bash")
do

	# Mute verbose output in no-interactive shells
	if ${interactive:-false}
	then
		source $in_script
	else
		source $in_script 2>&1 >/dev/null
	fi

	# If exist prompt file, then set according value in PS1 and using
	# ``PROMPT_COMMAND`` to reset value
	if [[ "$in_script" == */prompt.bash ]]
	then
		PS1="$prompt"
#		PROMPT_COMMAND="[ -r $auto_dir/*/prompt.bash ] \
#			&& source $auto_dir/*/prompt.bash \
#			&& PS1=\"\$prompt\""
		PS1="$prompt"
		PROMPT_COMMAND="prompt_build && PS1=\"\$prompt\""
	fi


done


# We also export ``PS1`` and ``PROMPT_COMMAND`` variables to environment.
# It's very usefull when run a subshell interactively.
export PS1="${PS1:-\$}"
export PROMPT_COMMAND

# Free all *in*ternal variables at this moment. It's postcondition. At
# this point none variable must be used by bash_auto
unset prompt
for in_var in ${!in_*} ${!options_*}
do
	unset $in_var
done
unset in_var

[ "${HOME}" ] && cd "${HOME}"

# -- end --
