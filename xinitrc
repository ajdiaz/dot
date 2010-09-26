#! /bin/sh
# --
# Custom xsession for laptop, load openbox with a number of gnome applets
# and anso a ggtraybar.

eval `cat $HOME/.fehbg` &
${HOME}/dev/ggtraybar/ggt 2>&1 >/dev/null &
nm-applet 2>&1 >/dev/null &
gnome-settings-daemon 2>&1 >/dev/null &
gnome-screensaver 2>&1 >/dev/null &
gnome-power-manager 2>&1 >/dev/null &
bluetooth-applet 2>&1 >/dev/null &
conky 2>&1 >/dev/null &
exec /usr/bin/openbox --replace 2>&1 >/dev/null

