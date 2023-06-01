# musl-compat

Legacy compatibility headers for the musl C library.

## Build and install

If you wish to install everything, you can use the following:

```console
gmake && gmake install
```

If you wish to install just the system headers, you can use:

```console
gmake install-sysheaders
```

And, if you wish to just install the ``error.h`` header along with the library
containing its functions, you can go with:

```console
gmake && gmake test-libegacy-compat \
    && gmake install-libegacy-compat
```

That's pretty much about it.

## How can I use the "libegacy-compat"?

In your ``LDFLAGS``, add the value of ``-legacy-compat``.
Yeah, simple as that.

## Licence

``error.h`` and ``error.c``, part of ``libegacy-compat``, are covered by the
[BSD 2-Clause licence](./LICENCE), along with the Makefile itself.
Maybe this library can be updated and more compatibility functions be added
along the time, but there's no guarantee of that for now.

``sys/tree.h`` was copied verbatim from the [NetBSD](https://netbsd.org)
source-tree by the [Void Linux project](https://voidlinux.org), so it's covered
by the BSD 2-Clause licence too;  
``sys/queue.h`` was also copied from NetBSD, but it's covered by the BSD 3-Clause
licence, with its ownership claimed by The Regents of the University of California;  
``sys/cdefs.h`` came from [Alpine Linux](https://alpinelinux.org) at some point
in history, but it hasn't a copyright header --- and, to be honest, it isn't
in fact copyrightable, since it does only provide some aliases to macros
[utilized improperly](https://wiki.musl-libc.org/faq.html#Q:-When-compiling-something-against-musl,-I-get-error-messages-about-%3Ccode%3Esys/cdefs.h%3C/code%3E)
by some folks in programs, since it should be only used internally at the
GNU C Library.

The test of ``error_at_line``(3) was taken from GNU m4 1.4.18 configure
Shell script, so it's covered --- or better, not covered --- by the
[FSF Unlimited License](./tests/LICENCE.FSFUL).
