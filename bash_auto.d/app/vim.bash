# This file is sourced by .bashrc. This script provide a compatibility
# with vim(1) editor.

if ! installed vim
then return 0
fi

export EDITOR="$(which vim)"

if installed vimpager
then
	MANPAGER="vimmanpager"
	PAGER="$(which vimpager)"
	export MANPAGER
	export PAGER
fi

# -- end -- vim:ft=sh:
