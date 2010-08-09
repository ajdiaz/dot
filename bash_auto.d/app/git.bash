# This file is sourced by .bashrc. This script provide a suite
# of git(1) specified utils. This file was contributed by
# Adrian Perez <aperez at connectical.com>

if ! installed git; then
	return 0
fi

git_get_branch_name ()
{
  local branch=$(git symbolic-ref HEAD 2> /dev/null \
    | sed 's#refs\/heads\/\(.*\)#\1#')
  [ "$branch" ] && echo "$branch "
}

if [[ -x /usr/bin/git ]] ; then
[[ $PS1 = *git_get_branch_name* ]] \
  || export PS1="\[\e[0;36m\]\$(git_get_branch_name)\[\e[0;0m\]$PS1"
fi

