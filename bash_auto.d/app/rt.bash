# This file is sourced by .bashrc. This script provide a compatibility
# with rt(1) application

installed rt || return 0

alias rtlist="rt list -l"
alias rtshow="rt show -l"

rthist () {
	rt show -l "$1/history" | ${PAGER:-cat}
}

# -- end -- vim:ft=sh:

