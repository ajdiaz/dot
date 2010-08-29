# This file is sourced by .bashrc. This script provide a suite
# of python(1) specified utils. This file was contributed by
# Adrian Perez <aperez at connectical.com>

if ! installed python; then
	return 0
fi

if [[ -r ~/pythonrc.py ]] ; then
	export PYTHONSTARTUP=~/pythonrc.py
fi

