// Copyright (C) 2015 - 2022 Void Linux contributors
// Copyright (C) 2023 Pindorama
// 		      Luiz Antônio Rangel 
// SPDX-Licence-Identifier: BSD-2-Clause

#if !defined(_ERROR_H_)
#define _ERROR_H_

#warning usage of non-standard `#include <error.h>' is deprecated

// As it suggests, it counts how many times error() was called, by being
// incremented every call.
static unsigned int error_message_count;

// If this is set non-zero, a sequence of error_at_line(3) calls with the
// same *filename and linenum values as input will result in only one entry
// on the specified file.
static int error_one_per_line;

static inline void error(int status, int errnum, const char* format, ...);
static inline void error_at_line(int status, int errnum, const char *filename,
		unsigned int linenum, const char *format, ...);

#endif	/* _ERROR_H_ */
