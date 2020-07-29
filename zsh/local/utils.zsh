#! /bin/zsh
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

if hash task 2>/dev/null; then
  alias -- cal='task calendar'
fi

if hash gdb 2>/dev/null; then
  alias -- gdb='gdb -q'
fi

if hash neomutt 2>/dev/null; then
  alias -- mutt="neomutt"
fi

if hash dig 2>/dev/null; then
  alias -- myip="dig +short myip.opendns.com @resolver1.opendns.com"
fi

if hash curl 2>/dev/null; then
  alias -- sprunge="curl -F 'sprunge=<-' http://sprunge.us"
  alias hcurl="curl -L -v -D - -o /dev/null"
  alias jcurl='curl -H "Accept: application/json" -H a"Content-type: application/json"'
  alias curl-time="curl -o /dev/null -s -w 'total: %{time_total} seconds \nsize: %{size_download} bytes \ndnslookup: %{time_namelookup} seconds \nconnect: %{time_connect} seconds \nappconnect: %{time_appconnect} seconds \nredirect: %{time_redirect} seconds \npretransfer: %{time_pretransfer} seconds \nstarttransfer: %{time_starttransfer} seconds \ndownloadspeed: %{speed_download} byte/sec \nuploadspeed: %{speed_upload} byte/sec \n'"
fi

if hash python 2>/dev/null; then
  # Python startup file
  if [ -r "${HOME}/.pythonrc.py" ] ; then
    export PYTHONSTARTUP="${HOME}/.pythonrc.py"
  fi

  alias serve='python3 -m http.server'
fi

if hash wget 2>/dev/null; then
  function mirror
  {
    local domain="${1#*://}"; domain="${domain%%/*}";

    wget -U'MSIE/5.0' --mirror --max-redirect=0 \
      --recursive --page-requisites \
      --html-extension --convert-links \
      --no-parent --span-hosts \
      --domains="$domain" "$1"
  }
fi

if hash tcpdump 2>/dev/null; then
  alias httpdump="sudo tcpdump -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
  function netdump {
    sudo tcpdump -nnA -s0 "$@" | sed \
      -e "s/\(^[0-9][0-9]:[0-9][0-9]:[0-9][0-9].[^ ]*\)/[38;5;33m\1[0m/g" \
      -e "s/[ ]IP[ ]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\.\([^ ]*\)/ IP [15;1m\1:\2[0m/g" \
      -e "s/[ ]>[ ]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\.\([^:]*\)/ → [15;1m\1:\2[0m/g " \
      -e 's/\(.*\)/[38;5;238m\1[0m/g'
  }

fi

if hash make 2>/dev/null; then
  function make {
    if [[ "${@[(r)-*]}" ]] || [[ -r Makefile ]] || [[ "$PWD" = / ]]; then
      command make "$@"
    else
      ( cd ..; make "$@"; )
    fi
  }
fi

if hash trm 2>/dev/null; then
  alias rm=trm
fi

if hash vimcat 2>/dev/null; then
  alias vcat=vimcat
  alias c=vimcat
fi

if hash ssh 2>/dev/null; then
  alias ssh='TERM=xterm-256color ssh'
fi

if hash ipcalc 2>/dev/null; then
  alias ipcalc='ipcalc -n'
fi

if hash xclip 2>/dev/null; then
  alias xc='xclip -selection clipboard'
fi

if hash buildah 2>/dev/null; then
  alias buildah="sudo -E buildah"
fi

if hash podman 2>/dev/null; then
  alias podman="sudo -E podman"
fi

if hash kubectl 2>/dev/null; then
  alias -- k=kubectl
  alias -- kexit="unset KUBECONFIG K8S_CLUSTER K8S_NAMESPACE"
fi

if hash systemctl 2>/dev/null; then
  alias -- s=systemctl
  alias -- us='systemctl --user'
fi

if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  ZSH_HIGHLIGHT_STYLES[default]=none
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=160,bold
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow,bold
  ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
  ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
  ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
  ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
  ZSH_HIGHLIGHT_STYLES[precommand]=none
  ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=yellow,bold
  ZSH_HIGHLIGHT_STYLES[hashed-command]=none
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[globbing]=none
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=129
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=250
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=250
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=33
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=33
  ZSH_HIGHLIGHT_STYLES[assign]=fg=yellow,bold
  ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]=fg=33

fi
