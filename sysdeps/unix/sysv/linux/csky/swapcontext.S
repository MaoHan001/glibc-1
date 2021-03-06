/* Copyright (C) 2012 Free Software Foundation, Inc.
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

#include "ucontext_i.h"

/* int swapcontext (ucontext_t *oucp, const ucontext_t *ucp) */

ENTRY(swapcontext)
	/* save params and lr */
	subi	sp, 16
	stw	a0, (sp, 0)
	stw	a1, (sp, 4)
	stw	r15, (sp, 8)
//	cfi_adjust_cfa_offset(16)
//	cfi_rel_offset(a0, 0)
//	cfi_rel_offset(a1, 4)
//	cfi_rel_offset(15, 8)


	/* call getcontext */
#ifdef __PIC__
#ifdef __CSKYABIV2__
	grs	t1, .Lgetpc1
.Lgetpc1:
	lrw	t0, .Lgetpc1@GOTPC
	addu	t1, t1, t0
	lrw	t0, __getcontext@GOT
	ldr.w	t0, (t1, t0 << 0)
	jsr	t0
#else/* __CSKYABIV1 */
	mov	r7, lr
	bsr	.Lgetpc1
.Lgetpc1:	/* do not use gb here, and restore lr before call getcontext*/
	lrw	r6, .Lgetpc1@GOTPC
	addu	r6, r15
	mov	lr, r7		/* restore r15 */
	lrw	r5, __getcontext@GOT
	addu	r5, r6
	ldw	r5, (r5)
	jsr	r5
#endif
#else/* no pic */
	jsri	 __getcontext
#endif

	mov	a3, a0		/* save return value */

	/* restore params and lr */
	ldw	a0, (sp, 0)
	ldw	a1, (sp, 4)
	ldw	r15, (sp, 8)
	addi	sp, 16
//	cfi_adjust_cfa_offset(-16)
//	cfi_restore(a0)
//	cfi_restore(a1)
//	cfi_restore(r15)

	cmpnei	a3, 0
	bt	error_exit

	/* Fix up LR and the PC */
#ifdef	__CSKYABIV2__
	stw	sp, (a0, MCONTEXT_CSKY_SP)
	stw	r15, (a0, MCONTEXT_CSKY_LR)
	stw	r15, (a0, MCONTEXT_CSKY_PC)
#else
	lrw	r4, MCONTEXT_CSKY_SP
	add	r4, a0
	stw	sp, (r4)
	lrw	r4, MCONTEXT_CSKY_LR
	add	r4, a0
	stw	r15, (r4)
	stw	r15, (r4, 8)	/* MCONTEXT_CSKY_PC */
#endif

	/* set setcontext's arg */
	mov	a0, a1

#ifdef __PIC__
#ifdef __CSKYABIV2__
	grs	t1, .Lgetpc2
.Lgetpc2:
	lrw	a3, .Lgetpc2@GOTPC
	addu	t1, t1, a3
	lrw	a3, __setcontext@GOT
	ldr.w	a3, (t1, a3 << 0)
#else/* __CSKYABIV1 */
	mov	r7, r15		/* save r15 */
	bsr	.Lgetpc2
.Lgetpc2:
	lrw	r6, .Lgetpc2@GOTPC
	addu	r6, r15
	lrw	r5, __setcontext@GOT
	addu	r5, r6
	ldw	r5, (r5)
	mov	r15, r7		/* restore r15 */
#endif
#else/* no pic */
	lrw	a3, __setcontext
#endif
	jmp	a3

error_exit:
	jmp	r15
END(swapcontext)
