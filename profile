#! /bin/sh

if [ "$0" = "$DESKTOP_SESSION" = "i3" ]; then
  export $(gnome-keyring-daemon -s)
  export $(gpg-connect-agent reloadagent /bye)
fi
