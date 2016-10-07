#! /bin/bash

INTERVAL=180

declare -a unread=( $(notmuch search --output=files tag:unread) )
declare -a new=()

now="$(printf '%(%s)T\n')"

for item in "${unread[@]}"; do
  mtime="$(stat -c '%Y' "$item")"
  [[ $((now-mtime)) -le "$INTERVAL" ]] && new+=( "$item" )
done


[ "${#new[@]}" -gt 0 ] && notify-send -u low -t 10 "Received: ${#new[@]} emails"
true
