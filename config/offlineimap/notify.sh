#! /bin/sh

maildirnew="$HOME/.mail/*/*/new/"
new="$(find $maildirnew -type f | wc -l)"

[ $new -gt 0 ] && notify-send  -t 5000 'Email' "Received $new new emails"
true
