# vim: ft=muttrc

virtual-mailboxes "connectical.com/INBOX" \
  "notmuch://?query=tag:inbox and folder:connectical.com/INBOX"

virtual-mailboxes "connectical.com/Sent" \
  "notmuch://?query=folder:connectical.com/Sent"

virtual-mailboxes "connectical.com/Trash" \
  "notmuch://?query=folder:connectical.com/Trash"

virtual-mailboxes "connectical.com/Flagged" \
  "notmuch://?query=(folder:connectical.com/INBOX and tag:flagged) or folder:connectical.com/Flagged"


set virtual_spoolfile = yes
set postponed   = +connectical.com/Drafts
set trash       = +connectical.com/Trash
set record      = +connectical.com/Sent
set nomove  # this is a gmail based account
set realname    = "Andrés J. Díaz"
set from        = "ajdiaz@connectical.com"
set sendmail    = "/usr/bin/msmtp -a connectical.com"
set pgp_sign_as = 0x77619F2382A850A8

macro index ,s "<change-vfolder>connectical.com/Sent<enter>" 
macro index ,d "<change-vfolder>connectical.com/Trash<enter>"
macro index ,f "<change-vfolder>connectical.com/Flagged<enter>"
