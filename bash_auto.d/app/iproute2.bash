# This file is sourced by .bashrc. This script provide a suite
# of iproute2 specified utils.

[ -x /sbin/ip ] || return 0

alias ip="/sbin/ip"
alias ipro="/sbin/ip route"
alias ipru="/sbin/ip rule"
alias ipn="/sbin/ip neigh"

# -- end -- vim:ft=sh:
