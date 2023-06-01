# Copyright (c) 2022-2023 Luiz Antônio Rangel <luiz.antonio.rangel@outlook.com.br>
# SPDX-Licence-Identifier: BSD-2-Clause

# Paths
ROOT ?=
DEFUSRBIN ?= /usr/bin/
DEFSBIN ?= /sbin/
MANDIR ?= /usr/share/man/
STATIC_LIBDIR ?= /usr/lib/
SYSINCLUDE_DIR ?= /usr/include/sys/
INCLUDE_DIR ?= /usr/include/

# Programs
CC ?= gcc
LD ?= ld
AR ?= ar
INSTALL ?= /bin/install

all: libegacy-compat test-libegacy-compat \
	src/cdefs.h src/error.h src/queue.h src/tree.h

# Only error() and error_at_line() available for now.
libegacy-compat: error.o
	$(AR) r libegacy-compat.a error.o

error.o: src/error.c src/error.h
	$(CC) -I src/ -c ./src/error.c -o error.o

install: install-sysheaders install-headers install-libegacy-compat

install-sysheaders: src/cdefs.h src/queue.h src/tree.h
	for sys_header in src/cdefs.h src/queue.h src/tree.h; do \
		$(INSTALL) -c -m 644 $$sys_header $(ROOT)$(SYSINCLUDE_DIR) ; \
	done

install-headers: src/error.h
	for header in src/error.h; do \
		$(INSTALL) -c -m 644 $$header $(ROOT)$(INCLUDE_DIR) ; \
	done

install-libegacy-compat: install-headers libegacy-compat
	$(INSTALL) -c -m 664 ./libegacy-compat.a $(ROOT)$(STATIC_LIBDIR)

test-libegacy-compat: libegacy-compat tests/error_at_line_test.c
	$(CC) tests/error_at_line_test.c -Isrc/ -L. -legacy-compat
	./a.out
	@echo 'The '\''error_at_line()'\'' function of libegacy-compat is working.'

clean:
	rm -f a.out *.o *.a *~ 
