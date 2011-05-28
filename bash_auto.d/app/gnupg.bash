# This file is sourced by .bashrc. This script provide a suite
# of gpg(1) specified utils.

if ! installed gpg; then
	return 0
fi

gpg-update-keys ()
{
	gpg --recv-keys $(gpg --list-key     \
	                  | grep ^pub        \
	                  | awk '{print $2}' \
					  | sed 's,^.*/,,g')
}

