remote-system-upgrade ()
{
  local session='remote-upgrade'
  local command='yaourt -Suy --aur'
  local i=0

  tmux new-session -s "$session" -d

  for host in "$@"; do
    tmux new-window -t "$session:$i" -n "$host"
    tmux rename-window -t "$session:$i" "$host"
    tmux set-window-option -t "$session:$i" allow-rename off
    tmux select-window -t "$session:$i"
    tmux send-keys "ssh -ttt $host $command" C-m
    ((i++))
  done

  tmux select-window -t "$session":0
  tmux attach-session -t "$session"
}

_remote-system-upgrade ()
{
	export service="ssh"
	_ssh "$@"
}

compdef _remote-system-upgrade remote-system-upgrade

