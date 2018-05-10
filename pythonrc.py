# vim:ft=python
# -*- coding: utf-8 -*-

import os
import sys
import pprint

from code import InteractiveConsole
from tempfile import mkstemp

# Color Support
base = '\001\033[%sm\002'
color = {
    "reset": base % "38;5;7",
    "blue": base % "38;5;104",
    "white": base % "38;5;15",
}

sys.ps1 = '%s▸▸▸ %s' % (color["blue"], color["reset"])
sys.ps2 = '%s  ⤷ %s' % (color["white"], color["reset"])


# Fancy display variables
def my_displayhook(value):
    if value is not None:
        try:
            import __builtin__
            __builtin__._ = value
        except ImportError:
            __builtins__._ = value

        pprint.pprint(value)


sys.displayhook = my_displayhook


def info(type, value, tb):
    if type != SyntaxError and hasattr(sys, 'ps1') or not sys.stderr.isatty():
        # we are in interactive mode or we don't have a tty-like
        # device, so we call the default hook
        import traceback
        import pdb
        # we are NOT in interactive mode, print the exception
        traceback.print_exception(type, value, tb)
        print
        # then start the debugger in post-mortem mode.
        # pdb.pm() # deprecated
        pdb.post_mortem(tb)  # more modern
    else:
        sys.__excepthook__(type, value, tb)


sys.excepthook = info

# Historic
try:
    import readline
    import atexit
    import rlcompleter

    historypath = os.path.expanduser("~/.pyhistory")
    readline.parse_and_bind("tab: complete")

    def save_history(historypath=historypath):
        import readline
        readline.write_history_file(historypath)

    if os.path.exists(historypath):
        readline.read_history_file(historypath)

    atexit.register(save_history)

    del atexit, readline, rlcompleter
except BaseException:
    pass

# Fancy inline editor
EDITOR = os.environ.get('EDITOR', 'vi')
EDIT_CMD = '\e'  # noqa
RAW_CMD = '!'
DIR_CMD = '@'
HELP_CMD = '?'


class EditableBufferInteractiveConsole(InteractiveConsole):
    def __init__(self, *args, **kwargs):
        self.last_buffer = []  # This holds the last executed statement
        InteractiveConsole.__init__(self, *args, **kwargs)

    def runsource(self, source, *args):
        self.last_buffer = [source.encode('utf-8')]
        return InteractiveConsole.runsource(self, source, *args)

    def raw_input(self, *args):
        line = InteractiveConsole.raw_input(self, *args)
        if len(line) < 1:
            return line
        if line == EDIT_CMD:
            fd, tmpfl = mkstemp('.py')
            os.write(fd, b'\n'.join(self.last_buffer))
            os.close(fd)
            os.system('%s %s' % (EDITOR, tmpfl))
            line = open(tmpfl).read()
            os.unlink(tmpfl)
            tmpfl = ''
            lines = line.split('\n')
            for i in range(len(lines) - 1):
                self.push(lines[i])
            line = lines[-1]
        elif line[0] == RAW_CMD:
            os.system(line[1:])
            return ""
        elif line[0] == DIR_CMD:
            return str(dir(eval(line[1:])))
        elif line[0] == HELP_CMD:
            help(eval(line[1:]))
            return ""

        return line


if __name__ == "__main__":
    c = EditableBufferInteractiveConsole(locals=locals())
    c.interact(banner='')
    sys.exit(0)
