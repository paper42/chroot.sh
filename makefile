PREFIX = /usr/local

all: usage

install:
	install -D -m 755 chroot.sh $(DESTDIR)$(PREFIX)/bin/chroot.sh

usage:
	@echo usage: make install

.PHONY: all install usage
