#!/bin/ksh
# do_install.ksh - Install a set of files for a package.
# usage: DESTDIR=/custom/directory ./do_install.ksh
# Note: if DESTDIR is not set, it will default to /.

# Copyright (C) 2022: Luiz Antônio Rangel (takusuman).
# SPDX-License-Identifier: BSD-2-Clause

pkg=musl-compat
pkgver=0.5
DESTDIR=${DESTDIR:-/}
sysinclude_sources=(src/cdefs.h src/queue.h src/tree.h)
include_sources=(src/error.h)
sources_licences=(LICENSE.BSD-3-Clause LICENSE.BSD-2-Clause)

test -d ${DESTDIR}/usr/include/sys || mkdir -p ${DESTDIR}/usr/include/sys
test -d ${DESTDIR}/usr/share/doc/${pkg}-${pkgver}/LICENSE || mkdir -p ${DESTDIR}/usr/share/doc/${pkg}-${pkgver}/LICENSE

for ((i=0; i<${#sysinclude_sources}; i++)); do 
	f=${sysinclude_sources[$i]}
	install -m 644 ${f} ${DESTDIR}/usr/include/sys
done
for ((i=0; i<${#include_sources}; i++)); do
	f=${include_sources[$i]}
	install -m 644 ${f} ${DESTDIR}/usr/include
done
	
sed -n '3,32p' < ${sysinclude_sources[1]} > ${sources_licences[0]}
sed -n '2,26p' < ${sysinclude_sources[2]} > ${sources_licences[1]}

for ((i=0; i<${#sources_licences}; i++)); do
	f=${sources_licences[$i]}
	install -m 644 ${f} ${DESTDIR}/usr/share/doc/${pkg}-${pkgver}/LICENSE
done
