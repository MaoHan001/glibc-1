/* Optimized memmove implementation for PowerPC64/POWER7.
   Copyright (C) 2014-2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <sysdep.h>

#undef EALIGN
#define EALIGN(name, alignt, words)				\
  .section ".text";						\
  ENTRY_2(__memmove_power7)					\
  .align ALIGNARG(alignt);					\
  EALIGN_W_##words;						\
  BODY_LABEL(__memmove_power7):					\
  cfi_startproc;						\
  LOCALENTRY(__memmove_power7)

#undef END_GEN_TB
#define END_GEN_TB(name, mask)					\
  cfi_endproc;							\
  TRACEBACK_MASK(__memmove_power7,mask)				\
  END_2(__memmove_power7)

#undef libc_hidden_builtin_def
#define libc_hidden_builtin_def(name)

#undef bcopy
#define bcopy __bcopy_power7

#include <sysdeps/powerpc/powerpc64/power7/memmove.S>
