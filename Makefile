# Copyright (c) 2022-2023 Luiz Antônio Rangel <luiz.antonio.rangel@outlook.com.br>
# SPDX-Licence-Identifier: BSD-2-Clause

# Paths
ROOT ?=
PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man/
STATIC_LIBDIR ?= $(PREFIX)/lib/
SYSINCLUDE_DIR ?= $(PREFIX)/include/sys/
INCLUDE_DIR ?= $(PREFIX)/include/

# Programs
CC ?= gcc
LD ?= ld
AR ?= ar
INSTALL = install

all: libegacy-compat test-libegacy-compat \
	src/cdefs.h src/error.h src/queue.h src/tree.h

# Only error() and error_at_line() available for now.
libegacy-compat: error.o
	$(AR) r libegacy-compat.a error.o

error.o: src/error.c src/error.h
	$(CC) -I src/ -c ./src/error.c -o error.o

install: install-sysheaders install-headers install-libegacy-compat

install-sysheaders: src/cdefs.h src/queue.h src/tree.h
	mkdir -p $(ROOT)$(SYSINCLUDE_DIR) $(ROOT)$(MANDIR)/man3/
	for sys_header in src/cdefs.h src/queue.h src/tree.h; do \
		$(INSTALL) -c -m 644 $$sys_header $(ROOT)$(SYSINCLUDE_DIR) ; \
	done
	for manual in ./man/queue.3 ./man/tree.3; do \
		$(INSTALL) -c -m 644 $$manual  $(ROOT)$(MANDIR)/man3/ ; \
	done

install-headers: src/error.h
	mkdir -p $(ROOT)$(INCLUDE_DIR)
	for header in src/error.h; do \
		$(INSTALL) -c -m 644 $$header $(ROOT)$(INCLUDE_DIR) ; \
	done

install-libegacy-compat: install-headers libegacy-compat
	mkdir -p $(ROOT)$(STATIC_LIBDIR)
	$(INSTALL) -c -m 664 ./libegacy-compat.a $(ROOT)$(STATIC_LIBDIR)

test-libegacy-compat: libegacy-compat tests/error_at_line_test.c
	$(CC) tests/error_at_line_test.c -Isrc/ -L. -legacy-compat
	./a.out
	@echo 'The '\''error_at_line()'\'' function of libegacy-compat is working.'

clean:
	rm -f a.out *.o *.a *~
