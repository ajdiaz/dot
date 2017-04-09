#! /bin/zsh
# Helper to open root (or not) shell
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

asu ()
{
  set "${1:-0}"
  case "$1" in
    0*|1*|2*|3*|4*|5*|6*|7*|8*|9*)
      sudo -E -u "#$1" "$SHELL";;
    *)
      sudo -E -u "$1" "$SHELL";;
  esac
}
