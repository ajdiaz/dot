# This file contains a set of human-legible wrappers

options_du="${options_du} -h"
options_ls="${options_ls} -h"
options_df="${options_df} -h"

alias du="du ${options_du}"
alias ls="ls ${options_ls}"
alias df="df ${options_df}"

# vim:ft=sh:
