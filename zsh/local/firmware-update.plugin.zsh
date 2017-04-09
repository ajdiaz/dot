#! /bin/zsh
# Use fwupdmgr to update local firmware

firmware-update ()
{
  fwupdmgr get-devices && \
    fwupdmgr refresh && \
    fwupdmgr get-updates

  echo -n "Proceed with FW update? [y/N]: "; read -r yesno
  case "$yesno" in
    y|Y|yes|YES|Yes)
      fwupdmgr update;;
    *)
      echo "Aborted!" >&2
      ;;
  esac
}
