#! /bin/sh
# --
# Custom xsession for laptop, load openbox with a number of gnome applets
# and also a ggtraybar using dmon...

cd $HOME
eval `cat $HOME/.fehbg` &
dmon -1 ${HOME}/dev/ggtraybar/ggt 2>&1 >/dev/null
dmon -1 gnome-settings-daemon 2>&1 >/dev/null
dmon -1 gnome-screensaver 2>&1 >/dev/null
dmon -1 gnome-power-manager 2>&1 >/dev/null
dmon -1 bluetooth-applet 2>&1 >/dev/null
dmon -1 conky 2>&1 >/dev/null
dmon -1 nm-applet 2>&1 >/dev/null
exec /usr/bin/openbox --replace 2>&1 >/dev/null

