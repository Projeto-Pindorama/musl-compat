// Copyright (C) 2015 - 2022 Void Linux contributors
// Copyright (C) 2023 Pindorama
// 		      Luiz Antônio Rangel 
// SPDX-Licence-Identifier: BSD-2-Clause

#include "error.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// The calling program shall set "program_invocation_name" to the name of the
// executing program itself.
extern char *program_invocation_name;
// Documented at the "error.h" header.
extern unsigned int error_message_count = 0;
extern int error_one_per_line = 0;

extern void error(int status, int errnum, const char* format, ...)
{
	// Should be fflush(stdout), but that's unspecified if stdout has been closed;
	// stick with fflush(NULL) for simplicity (GNU C library checks if the
	// file descriptor is still valid).
	fflush(NULL);

	va_list ap;
	fprintf(stderr, "%s: ", program_invocation_name);
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	if (errnum)
		fprintf(stderr, ": %s", strerror(errnum));
	fprintf(stderr, "\n");
	error_message_count++;
	if (status)
		exit(status);
}


extern void error_at_line(int status, int errnum, const char *filename,
		unsigned int linenum, const char *format, ...)
{
	va_list ap;
	if (error_one_per_line) {
		static const char *old_filename;
		static int old_linenum;
		if (linenum == old_linenum && filename == old_filename)
			return;
		old_filename = filename;
		old_linenum = linenum;
	}
	fprintf(stderr, "%s: %s:%u: ", program_invocation_name, filename, linenum);
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	if (errnum)
		fprintf(stderr, ": %s", strerror(errnum));
	fprintf(stderr, "\n");
	error_message_count++;
	if (status)
		exit(status);
}
