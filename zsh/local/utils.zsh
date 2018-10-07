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
  alias -- mutt="neomutt && ~/.config/mbsync/mail-notify"
fi

if hash dig 2>/dev/null; then
  alias -- myip="dig +short myip.opendns.com @resolver1.opendns.com"
fi

if hash curl 2>/dev/null; then
  alias -- sprunge="curl -F 'sprunge=<-' http://sprunge.us"
  alias hcurl="curl -L -v -D - -o /dev/null"

  function jcurl
  {
    curl -H "Accept: application/json" \
      -H a"Content-type: application/json" "$@" \
    | jq '.'
  }
fi

if hash python 2>/dev/null; then
  alias serve='python -m SimpleHTTPServer 8000'
fi

if hash wget 2>/dev/null; then
  function mirror
  {
    local url=
    declare -a args=()
    while [[ "$1" ]]; do
      case "$1" in
        -*) args=( "${args[@]}" "$1" );;
        *) url="$1";;
      esac
      shift
    done

    local domain="${url#*://}"; domain="${domain%%/*}";

    wget -U'MSIE/5.0' --mirror --max-redirect=0 \
      --recursive --page-requisites \
      --html-extension --convert-links \
      --no-parent --span-hosts \
      --domains="$domain" "$url"
  }
fi

if hash tcpdump 2>/dev/null; then
  alias httpdump="sudo tcpdump -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
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
