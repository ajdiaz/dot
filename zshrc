# The following lines were added by compinstall
zstyle :compinstall filename '/home/ajdiaz/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=${HISTSIZE}
setopt appendhistory extendedglob
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

# Initialize colors.
autoload -U colors
colors

if [ "$DESKTOP_SESSION" = "i3" ]; then
  export $(gnome-keyring-daemon -s)
fi

if [ ! -f /usr/share/terminfo/${TERM:0:1}/${TERM} ]; then
  export TERM="xterm-256color"
fi

# Bind Ctrl-Left and Ctrl-Right key sequences, and AvPag/RePag for history
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "\e[5~" history-search-backward
bindkey "\e[6~" history-search-forward

# Make AvPag/RePag work in long menu selection lists
zmodload -i zsh/complist
bindkey -M menuselect "\e[5~" backward-word
bindkey -M menuselect "\e[6~" forward-word
bindkey -M menuselect "\e"    send-break

# Bind Delete/Begin/End for Zsh setups that do not include those by default
# (screen, tmux, rxvt...)
bindkey "^[OH"  beginning-of-line
bindkey "^[[H"  beginning-of-line
bindkey "^A"    beginning-of-line
bindkey "[1~" beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[F"  end-of-line
bindkey "^E"    end-of-line
bindkey "[4~" end-of-line
bindkey "^[[3~" delete-char

# Set a bunch of options :-)
setopt prompt_subst pushd_silent auto_param_slash auto_list \
	     list_rows_first hist_reduce_blanks chase_dots \
	     pushd_ignore_dups auto_param_keys hist_ignore_all_dups \
	     mark_dirs complete_in_word cdablevars interactive_comments \
	     print_eight_bit always_last_prompt
unsetopt menu_complete auto_menu list_ambiguous pushd_to_home

# Use completion cache
[[ -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matching %b%d'

# Avoid annoying username completion
zstyle ':completion:*:complete:(cd|pushd|pd):*' tag-order \
	   'local-directories path-directories directory-stack' '*'

# Prevent CVS files from being matched
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*:cd:*' noignore-parents noparent pwd

# Bring up ${LS_COLORS}
if [ -x /usr/bin/dircolors ] ; then
	if [ -r "${HOME}/.dir_colors" ] ; then
		eval $(dircolors -b "${HOME}/.dir_colors")
	elif [ -r /etc/DIRCOLORS ] ; then
		eval $(dircolors -b /etc/DIRCOLORS)
	else
		eval $(dircolors)
	fi
fi

if [ "${LS_COLORS}" ] ; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	unsetopt list_types
else
	zstyle ':completion:*' list-colors ""
	setopt list_types
fi

# Some fine-tuning
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-prompt "%BMatch %m (%p)%b"
zstyle ':completion:*' menu yes=long select=long interactive
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,user,args'
zstyle ':completion:*:processes-names' command 'ps -au$USER -o command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:kill:*' force-list always


FMT_BRANCH="%{$fg[cyan]%}%b%u%c%{$fg[default]%}" # e.g. master¹²
FMT_ACTION="·%{$fg[green]%}%a%{$fg[default]%}"   # e.g. (rebase)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:bzr:prompt:*' use-simple true
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   "%B%{$fg[cyan]%}¹%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' stagedstr     "%B%{$fg[cyan]%}²%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION} "
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH} "
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

case ${TERM} in
	screen | xterm* | gnome-terminal)
		function precmd {
			vcs_info 'prompt'
			print -Pn "\e]0;%n@%m: %~\a"
			[[ ${TERM} = screen* ]] && echo -ne "\ek$(hostname):${PWD##*/}\e\\"
		}
        function preexec () {
            print -Pn "\e]0;$1\a"
        }
	;;
	*)
		function precmd {
			vcs_info 'prompt'
		}
	;;
esac

if [[ ${TERM} = screen* ]] ; then
	preexec () {
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -ne "\ek$CMD\e\\"
	}
fi

PROMPT=$'%{%F{200}%}${LOADENV_ENV_NAME:+$LOADENV_ENV_NAME }%{%b%f%}'
PROMPT+=$'%{%F{180}%}${VIRTUAL_ENV:+${VIRTUAL_ENV##*/} }%{%b%f%}'
PROMPT+=$'%B%{%(!.$fg[red].$fg[green])%}%m%b%f '
PROMPT+=$'${vcs_info_msg_0_}'
PROMPT+=$'%{%F{39}%}%B%1~ %b%f'
PROMPT+=$'%(?.%{%F{39}%}.%B%{$fg[red]%})%# %b%f'

unset FMT_BRANCH FMT_ACTION

# Aliases
alias -- 'pd'=pushd
alias -- '..'='cd ..'

case "$(uname)" in
  Linux)
    alias -- ls='ls --color=auto'
    alias -- ll='ls --color=auto -l'
    alias -- ps='ps axf' ;;
esac

alias -- ag='ack'
alias -- '-'='cd -'
alias -- gdb='gdb -q'
alias -- pager='pager -R'
alias -- sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias -- ipecho='curl ipecho.net/plain; echo'
alias -- list="sudo systemctl list-units"
alias -- status="sudo systemctl status"
alias -- start="sudo systemctl start"
alias -- stop="sudo systemctl stop"
alias -- restart="sudo systemctl restart"
alias -- reload="sudo systemctl reload"

# Local binaries directory
if [ -d "${HOME}/.local/bin" ] ; then
	PATH="${PATH}:${HOME}/.local/bin"
fi

# Optional binaries in PATH (prepend)
for _path in ${HOME}/.gem/ruby/*/bin; do
    [ "${_path//\*/}" = "${_path}" ] && PATH="${_path}:${PATH}"
done

for _path in /opt/*/sbin /opt/*/bin /opt/*/usr/bin /opt/*/usr/sbin /opt/*/usr/local/bin /opt/*/usr/local/sbin; do
	[ "${_path//\*/}" == "${_path}" ] && PATH="${_path}:${PATH}"
done

# Some EDITOR preferences
if [ -x /usr/bin/vim ] ; then
	export EDITOR='/usr/bin/vim'
fi

# Load some local files
for local in "${HOME}/.zsh/local/"*; do
	[ "$local" != "${HOME}/.zsh/local/*" ] && source "$local"
done

# Unset some vars
unset _path local
# Mark exports
export PATH

# Python startup file
if [ -r "${HOME}/.pythonrc.py" ] ; then
	export PYTHONSTARTUP="${HOME}/.pythonrc.py"
fi

# TERMCAP codes
# vb      flash     emit visual bell
# mb      blink     start blink
# md      bold      start bold
# me      sgr0      turn off bold, blink and underline
# so      smso      start standout (reverse video)
# se      rmso      stop standout
# us      smul      start underline
# ue      rmul      stop underline
export LESS_TERMCAP_mb=$'\e[48;5;196m\e[38;5;190m'
export LESS_TERMCAP_md=$'\e[1m\e[38;5;75m'
export LESS_TERMCAP_me=$'\e[0;0m'
export LESS_TERMCAP_so=$'\e[48;5;235m\e[38;5;242m'
export LESS_TERMCAP_se=$'\e[0;0m'
export LESS_TERMCAP_us=$'\e[38;5;71m'
export LESS_TERMCAP_ue=$'\e[0;0m'

# pass configuration
export PASSWORD_STORE_DIR=~/sys/pass

# pidstat colors
export S_COLORS=auto
export S_COLORS_SGR="H=31;1:I=0;37:M=1;35:N=0;1:Z=37;0"
