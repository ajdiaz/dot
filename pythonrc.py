# vim:ft=python
import sys
sys.ps1="[0;1m>>>[0;0m "
sys.ps2="[0;1m...[0;0m "
try:
    import readline
except ImportError:
    sys.stderr.write("Module readline not available.\n")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
