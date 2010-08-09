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
# Example rules
# -------------
#
# Default prompt, using color prompt style *<user@host> [wdir]$*. We asume
# that every terminal has color support, obviously you can set fine this
# using according condition.
prompt="\[\e[32;1m\]<\u@\h> \[\e[34;1m\][\w]\\$\[\e[0m\] "

# Prompt showed in directories which they are not writeable by current user
# (the working dir must be displayed in lighting red)
[ ! -w . ] && prompt="\[\e[32;1m\]<\u@\h> \[\e[31;1m\][\w]\\$\[\e[0m\] "

# Put an admiration sign if current load of the machine is upper to
# one unit.
[ -r /proc/loadavg -a "$(cut -d'.' -f1 /proc/loadavg)" -ge 1 ] && \
	prompt="\[\e[31;1m\]<\u@\h> [\w]\\$\[\e[0m\] "

# Prompt when UID is 0, that is we are root. In this case like a gentoo
# prompt style.
[ $UID -eq 0 ] && prompt="\[\e[31;1m\]\h\[\e[34;1m\] \W \\$\[\e[0m\] "

# Prompt where we are a remote user. Display the prompt in light blue
[ "$SSH_CONNECTION" ] && [ $UID -ne 0 ] && \
	prompt="\[\e[34;1m\]<\u@\h> [\w]\\$\[\e[0m\] "

# Prompt when we are a remote user and UID is root. In this case use
# gentoo style prompt in light blue.
[ "$SSH_CONNECTION" ] && [ $UID -eq 0 ] && \
 	prompt="\[\e[34;1m\]\h \W \\$\[\e[0m\] "


# Put nice titlebar if supported. We use property of chained
# prompt variable (prompt="something$prompt"), and we like a ssh
# titlebar style (user@host:dir)

case "$TERM" in
	xterm*)  prompt="\[\e]2;\u@\h:\w\a\]$prompt" ;;
	screen*) prompt="\ek\u@\h:\w\e\134$prompt" ;;
esac

# vim:ft=sh:
