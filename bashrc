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
OS="$(uname)"
LINUX="$(cat /etc/*-{release,version} 2>/dev/null)"
HOST="${HOSTNAME}"
USER="${LOGNAME}"
FROM="${SSH_CLIENT%% *}"

shopt -s extglob

# The ``for`` is muted (redirected to ``/dev/null``) to prevent
# unusefull errors if directory does not exists. I consider ugly
# practice to save this messages.
for src in ${auto_dir}/**/*.bash; do echo $src; time mute source $src; done

# We also export ``PS1`` and ``PROMPT_COMMAND`` variables to environment.
# It's very usefull when run a subshell interactively.
export PS1="[no prompt]$ "

# Free all *in*ternal variables at this moment. It's postcondition. At
# this point none variable must be used by bash_auto
unset OS LINUX HOST USER FROM src ${!in_*} ${!options_*}

# -- end --
