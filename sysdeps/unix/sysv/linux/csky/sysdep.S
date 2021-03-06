/* Copyright (C) 1995, 1996, 1997, 1998, 2005, 2006
   Free Software Foundation, Inc.
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
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

#include <sysdep.h>
#include <csky_readtp.h>
	.text

/* The syscall stubs jump here when they detect an error.
   The code for Linux is almost identical to the canonical Unix
   code, except that the error number in R0 is negated.  */

#undef CALL_MCOUNT
#define CALL_MCOUNT /* Don't insert the profiling call, it clobbers R0.  */

ENTRY(__syscall_error)
	movi	a1, 0
	rsub	a0, a0, a1 

#if defined (EWOULDBLOCK_sys) && EWOULDBLOCK_sys != EAGAIN
        /* We translate the system's EWOULDBLOCK error into EAGAIN.
           The GNU C library always defines EWOULDBLOCK==EAGAIN.
           EWOULDBLOCK_sys is the original number.  */
        cmpnei  a0, EWOULDBLOCK /* Is it the old EWOULDBLOCK?  */
        bt      1f
        mov     a0, EAGAIN      /* Yes; translate it to EAGAIN.  */
#endif
#ifdef __CSKYABIV2__
1:
#if !IS_IN (rtld)
	mov	a1, a0
        csky_read_tp

        grs     t1, .Lgetpc1
.Lgetpc1:
        lrw     t0, errno@gottpoff
        add     t1, t1, t0
        ldw     t1, (t1)
        add     t1, a0
        stw     a1, (t1)
        bmaski  a0, 0
        rts
#elif RTLD_PRIVATE_ERRNO
#ifdef  __PIC__
        grs     t1, .Lgetpc2
.Lgetpc2:
        lrw     t0, .Lgetpc2@GOTPC
        addu    t1, t1, t0
        lrw     t0, rtld_errno@PLT
        ldr.w   t0, (t1, t0 << 0)
#else
        lrw     t0, rtld_errno
#endif
        stw     a0, (t0)
        bmaski  a0, 0
        rts
#else
#error "Unsupported non-TLS case"
#endif

#undef  __syscall_error
END (__syscall_error)

#else/* abi */

1:
#if !IS_IN (rtld)
        mov     r7, r15
	mov	r1, r2
        csky_read_tp

        bsr     .Lgetpc1
.Lgetpc1:
        lrw     r5, errno@gottpoff
        add     r5, r15
        ldw     r5, (r5)
        add     r5, r2
        stw     r1, (r5)
        bmaski  r2, 0
	mov	r15, r7
        rts
#elif RTLD_PRIVATE_ERRNO
#ifdef __PIC__
        mov     r7, r15
        bsr     .Lgetpc2
.Lgetpc2:
        lrw     r6, .Lgetpc2@GOTPC
        addu    r6, r15
        lrw     r5, rtld_errno@PLT
        addu    r5, r6
        ldw     r5, (r5)
	mov	r15, r7
#else
        lrw     r5, rtld_errno
#endif
        stw     r2, (r5)
        bmaski  r2, 0
        rts
#else
#error "Unsupported non-TLS case"
#endif

END (__syscall_error)

#endif /* abi */

//#define __syscall_error __syscall_error_1
//#include "../../../csky/sysdep.S"
