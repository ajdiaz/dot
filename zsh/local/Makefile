#
# Makefile
# Andres J. Diaz, 2020-03-25 11:58
#

.SUFFIXES: .zsh .zwc
SOURCES := $(wildcard *.zsh)

all: $(SOURCES:.zsh=.zwc)

%.zwc: %.zsh
	zsh -c 'zcompile $<'

clean:
	rm -f *.zwc

# vim:ft=make
#
