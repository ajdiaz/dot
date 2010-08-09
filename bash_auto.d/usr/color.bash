# This file contains a set of color-improved aliases

if ! installed dircolors
then return 0
else
	eval $(dircolors -b)
fi

options_ls="${options_ls} --color=auto"
options_grep="${options_grep} --color=auto"

alias ls="ls ${options_ls}"
alias grep="grep ${options_grep}"

if installed emerge
then
	options_emerge="${options_emerge} --color=y"
	alias emerge="emerge ${options_emerge}"
fi

# vim:ft=sh:
