# The following lines were added by compinstall
zstyle :compinstall filename '/home/ajdiaz/.zshrc'
fpath+=( ~/.zsh/local )
autoload -Uz compinit promptinit; compinit promptinit

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
autoload -U colors; colors

if [ ! -f /usr/share/terminfo/${TERM:0:1}/${TERM} ]; then
  export TERM="xterm-256color"
fi

export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-/run/user/$UID/gnupg/S.gpg-agent.ssh}"

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
  hist_reduce_blanks auto_remove_slash chase_dots \
  pushd_ignore_dups auto_param_keys \
  mark_dirs cdablevars interactive_comments glob_complete \
  print_eight_bit always_to_end glob no_warn_create_global \
  hash_list_all hash_cmds hash_dirs hash_executables_only \
  auto_continue check_jobs complete_in_word rc_quotes

# Correct things, but not too aggressively for certain commands
setopt correct
alias ':'='nocorrect :'
alias mv='nocorrect mv'
alias man='nocorrect man'
alias sudo='nocorrect sudo '
alias exec='nocorrect exec'
alias mkdir='nocorrect mkdir'

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
zstyle ':completion:*' insert-tab pending=1
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' special-dirs ..
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,user,args'
zstyle ':completion:*:processes-names' command 'ps -au$USER -o command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:kill:*' force-list always


FMT_BRANCH="%{$fg[cyan]%}%b%u%c%{$fg[default]%}" # e.g. master¹²
FMT_BRANCH+="%{$fg[yellow]%}%m%{$fg[default]%}"  # e.g. ⤵
FMT_ACTION="·%{$fg[green]%}%a%{$fg[default]%}"   # e.g. (rebase)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:bzr:prompt:*' use-simple true
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   "%B%{$fg[cyan]%}ᴹ%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' stagedstr     "%B%{$fg[cyan]%}ᴬ%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION} "
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH} "
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function +vi-git-st() {
    local ahead behind remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        read -r ahead < <(
          git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null
        )

        read -r behind < <(
          git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null
        )

        local symbol="${behind:+⤵}${ahead:+⤴}"

        hook_com[misc]="${hook_com[misc]}${symbol}"
    fi

    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+="%B%{$fg[cyan]%}ᵀ%{$fg[default]%}%b"
    fi

}

zstyle ':vcs_info:git*+set-message:*' hooks git-st

autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='  # dropped { }

PRECMD_ACTIONS=()

case ${TERM} in
	screen | xterm* | gnome-terminal)
		function precmd {
			vcs_info 'prompt'
			for x in "${PRECMD_ACTIONS[@]}"; do "$x"; done
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
			for x in "${PRECMD_ACTIONS[@]}"; do "$x"; done
		}
	;;
esac

if [[ ${TERM} = screen* ]] ; then
	preexec () {
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -ne "\ek$CMD\e\\"
	}
fi

if [[ "$SSH_CONNECTION" ]]; then
  SHOWHOST=true
fi

PROMPT=$'%{%F{228}%}${VM_NAME:+$VM_NAME }%{%b%f%}'
PROMPT+=$'%{%F{190}%}${IAM_ID_NAME:+$IAM_ID_NAME }%{%b%f%}'
PROMPT+=$'%{%F{176}%}${K8S_CLUSTER:+$K8S_CLUSTER/}${K8S_NAMESPACE:+$K8S_NAMESPACE }%{%b%f%}'
PROMPT+=$'%{%F{180}%}${VIRTUAL_ENV:+${VIRTUAL_ENV##*/} }%{%b%f%}'
PROMPT+=$'%B%{%(!.$fg[red].%{%F{255}%})%}${SHOWHOST:+%m }%b%f'
PROMPT+=$'${vcs_info_msg_0_}'
PROMPT+=$'%{%F{39}%}%B%1~ %b%f'
PROMPT+=$'%(?.%{%F{68}%}.%B%{$fg[red]%})%(!.#.$) %b%f'

unset FMT_BRANCH FMT_ACTION

# Aliases
alias -- 'pd'=pushd
alias -- '..'='cd ..'
alias -- o='xdg-open'
alias -- ag='ack'
alias -- '-'='cd -'
alias -- pager='pager -R'
alias -- history="history -i"
alias -- map="xargs -n1"
alias -- tailf="tail -f"
alias -- inv="tr ' ' '\n--\n' | tac | tr '\n--\n' ' ' | sed -e 's:[ ]$::'"
alias -- typeof="file -b --mime-type"
alias -- pls='sudo $(fc -n -l -1)'
alias -- sortv='sort --short-version'
alias -- psa='ps auxf'
alias -- s=sudo
alias -- vp=vimpager
alias -- rr='source ~/.zshrc'

case "$(uname)" in
  Linux)
    alias -- ls='ls --color=auto'
    alias -- ll='ls --color=auto -l'
    alias -- ps='ps axf' ;;
esac

# Local binaries directory
if [ -d "${HOME}/.local/bin" ] ; then
	PATH="${PATH}:${HOME}/.local/bin"
fi

if [ -d "${HOME}/bin" ] ; then
	PATH="${PATH}:${HOME}/bin"
fi

# Optional binaries in PATH (prepend)
for _path in ${HOME}/.gem/ruby/*/bin ${KREW_ROOT:-$HOME/.krew}/bin:$PATH; do
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
for local in "${HOME}/.zsh/local/"*.zsh; do
	[ "$local" != "${HOME}/.zsh/local/*.zsh" ] && source "$local"
done

# Unset some vars
unset _path local
# Mark exports
export PATH

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
export PASSWORD_STORE_DIR=~/sys/var/vault

# iam configuration
export IAM_HOME=~/sys/iam
iam reload

# pidstat colors
export S_COLORS=auto
export S_COLORS_SGR="H=31;1:I=0;37:M=1;35:N=0;1:Z=37;0"

# go path variables, not happy setting this here
export GOPATH=~/var/go
export PATH="$PATH:$GOPATH/bin"
