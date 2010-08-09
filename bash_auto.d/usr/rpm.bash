# This file contains a set of RPM commodities

if ! installed rpm; then
	return 0
fi

# Add portage-utils smiliar stuff for rpm
alias qlist="rpm -ql"
alias qscripts="rpm -q --scripts"
alias qtriggers="rpm -q --triggers"
alias qlog="rpm -q --changelog"
alias qall="rpm -qa --queryformat '%{installtime:day} - %{name} - %{size}\n'"
alias qfile="rpm -qf"
alias qlast="rpm -qa --last '%{installtime:day} - %{name} - %{size}\n'"

# vim:ft=sh:
