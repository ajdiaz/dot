#! /bin/sh

# system generic xinitrc config
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    # shellcheck disable=SC1090
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# gpg agent
if [ -x /usr/bin/gpg-connect-agent ]; then
  export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
  gpg-connect-agent updatestartuptty /bye
fi
