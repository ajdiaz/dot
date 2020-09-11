#! /bin/zsh
# Helper to open root (or not) shell
# (c) 2017 Andrés J. Díaz
# Distributed under terms of the GPLv3 license.

asu ()
{
  local asu_bin=''

  hash "doas" >/dev/null 2>&1 && asu_bin="doas"
  hash "sudo" >/dev/null 2>&1 && asu_bin="sudo"

  if [[ -z "$asu_bin" ]]; then
    echo 'error: no doas or sudo found!' >&2
    return 1
  fi

  set "${1:-root}"
  case "$1" in
    0*|1*|2*|3*|4*|5*|6*|7*|8*|9*)
      if [[ "$asu_bin" == "doas" ]]; then
        echo 'error: doas not allow numeric uid parameter' >&2
        return 2
      fi
      sudo -E -u "#$1" "$SHELL";;
    *)
      case "$asu_bin" in
        sudo) sudo -E -u "$1" "$SHELL";;
        # doas not allow to pass the env, which is a good thing, but
        # annoying sometimes, to workaround this we call the shell again with
        # forced environment variables.
        doas) doas -u "$1" "$SHELL" -c "HOME=$HOME" exec "$SHELL";;
      esac;;
  esac
}
