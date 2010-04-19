# vim:ft=python
import sys, os
sys.ps1="[0;1m>>>[0;0m "
sys.ps2="[0;1m...[0;0m "

try:
    import readline, atexit, os, rlcompleter
 
    historypath = os.path.expanduser("~/.pyhistory")
    readline.parse_and_bind("tab: complete")
 
    def save_history(historypath=historypath):
        import readline
        readline.write_history_file(historypath)
 
    if os.path.exists(historypath):
        readline.read_history_file(historypath)
 
    atexit.register(save_history)
 
    del os, atexit, readline, save_history, historypath, rlcompleter

except:
    pass

