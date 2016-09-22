#! /bin/sh

query="tag:unread"
new="$(notmuch search --output=files $query | wc -l)"

[ $new -gt 0 ] && notify-send -u low -t 10 "Received: $new emails"
true
