# This file contains a set of DPKG commodities

if ! installed dpkg; then
	return 0
fi

# Add portage-utils smiliar stuff for dpkg
alias qlist="dpkg -l"
alias qfile="dpkg -L"

# vim:ft=sh:
