# This file is sourced by .bashrc. This script provide a suite
# of emerge(1) specified utils.

if ! installed emerge
then return 0
fi

# The options_emerge variable contains a list of arguments which
# will be passed always to any emerge wrapper or emerge in self.
# In this case I want a small information before emerge something
# in my system.
options_emerge="${options_emerge} --ask --verbose"

# The option_eix variable set the options for eix(1) program,
# by default use color support (-F) and summary mode (-x)
options_eix="${options_eix} -F -x"

# Check fot cfg-update(1) wrapper, if found use them, otherwise
# use classical emerge(1).
if installed cfg-update
then
	alias emerge="emerge_with_indexing_for_cfg-update ${options_emerge}"
else
	alias emerge="emerge ${options_emerge}"
fi

# Use eix(1) with color support
if installed eix
then
	alias eix="eix ${options_eix}"
fi

# -- end -- vim:ft=sh:

