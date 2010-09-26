# =========================
# ~/.bash_autoload.d/prompt
# =========================
#
# This file is sourced by .bashrc. This script provides a
# pretty prompt
#
# HOW THIS FILE RUN
# -----------------
#
# This file is a special file imported by .bashrc. In this file
# you can set a prompt using ``prompt`` variable, like this::
#
#	prompt='<\u@\h> [\w]\$ '
#
# And you can use a list of conditions, like this::
#
# 	true && prompt='<\u@\h> [\w]\$ '
#
# This line is equivalent to previously example. You can anidate
# more conditions::
#
# 	[ ! -w . ] && [ $UID -eq 0 ] && prompt="rare! "
#
# And, of course, you can specify a couple of conditions. In this
# case, the last condition has more precedence, for example::
#
# 	[ ! -w . ] && prompt='$ '
# 	[ ! -w . ] && prompt='# '
#
# In this example, the prompt will be always ``#``, due to both conditions
# are true always, and the last action take the precedence.
#
# At the begin, prompt variable are empty (this is a true precondition). You
# can use in your prompt settings the previously value of ``prompt``
# variable if it's setted::
#
# 	prompt='$'
# 	[ ! -w . ] && prompt="$prompt (!w) '
#
# Aditionally, you can define hooks for prompt, a hook is a function which
# will be called after this prompt file is evaluated (usually on each prompt
# display) and change the content of the $prompt variable.
#
# To set a hook just create a new function and make some modifications to
# the $prompt variable (be carefull to append the previously content), and
# then set a new var with the name prompt_hook_<id>, where id is
# a alphanumeric identifier for that hook (must be unique).
#
# Example rules
# -------------
#
# Default prompt, using color prompt style *<user@host> [wdir]$*. We asume
# that every terminal has color support, obviously you can set fine this
# using according condition.
#
# Example hook
# ------------
#
# git_set_branch_in_prompt ()
# {
# 	if [[ -x /usr/bin/git ]] ; then
# 	[[ $prompt = *git_get_branch_name* ]] \
#   	|| export prompt="\[\e[0;36m\]\$(git_get_branch_name)\[\e[0;0m\]$prompt"
# 	fi
# }
# prompt_hook_git=git_set_branch_in_prompt

prompt="\[\e[32;1m\]<\u@\h> \[\e[34;1m\][\w]\\$\[\e[0m\] "

# Prompt showed in directories which they are not writeable by current user
# (the working dir must be displayed in lighting red)
prompt_hook_norw () {
	[ ! -w . ] && prompt="\[\e[32;1m\]<\u@\h> \[\e[31;1m\][\w]\\$\[\e[0m\] "
}
prompt_hook_norw=prompt_hook_norw

# Put an admiration sign if current load of the machine is upper to
# one unit.
prompt_hook_loadavg () {
if [ -r /proc/loadavg -a -d /sys/devices/system/cpu/ ] ; then
	local cur_avg="$(cut -d'.' -f1 /proc/loadavg)"
	local max_avg="$(find /sys/devices/system/cpu/ -name "cpu[0-9]*" | wc -l)"
	[ ${cur_avg:-0} -ge ${max_avg:-0} ] && \
	prompt="\[\e[31;1m\]<\u@\h> [\w]\\$\[\e[0m\] "
fi
}
prompt_hook_loadavg=prompt_hook_loadavg

# Prompt when UID is 0, that is we are root. In this case like a gentoo
# prompt style.
prompt_hook_rootuid () {
[ $UID -eq 0 ] && prompt="\[\e[31;1m\]\h\[\e[34;1m\] \W \\$\[\e[0m\] "
}
prompt_hook_rootuid=prompt_hook_rootuid

# Put nice titlebar if supported. We use property of chained
# prompt variable (prompt="something$prompt"), and we like a ssh
# titlebar style (user@host:dir)
prompt_hook_titlebar () {
case "$TERM" in
	xterm*)  prompt="\[\e]2;\u@\h:\w\a\]$prompt" ;;
	screen*) prompt="\ek\u@\h:\w\e\134$prompt" ;;
esac
}
prompt_hook_titlebar=prompt_hook_titlebar

prompt_build ()
{
	# Handle hooks if present.
	prompt="\[\e[32;1m\]<\u@\h> \[\e[34;1m\][\w]\\$\[\e[0m\] "
	for hook in ${!prompt_hook*}; do
		${!hook} 2>/dev/null >/dev/null
	done; true
}

# vim:ft=sh:
