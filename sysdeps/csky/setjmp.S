/* Copyright (C) 1996, 1997, 2000 Free Software Foundation, Inc.
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

ENTRY(__sigsetjmp)
	mov     a2, a0
	/* Save registers */
#ifdef __CSKYABIV2__
	stw     sp, (a2, 0)
	stw     lr, (a2, 4)
	stw     r4, (a2, 8)
	stw     r5, (a2, 12)
	stw     r6, (a2, 16)
	stw     r7, (a2, 20)
	stw     r8, (a2, 24)
	stw     r9, (a2, 28)
	stw     r10, (a2, 32)
	stw     r11, (a2, 36)
	stw     r16, (a2, 40)
	stw     r17, (a2, 44)
	stw     r26, (a2, 48)
	stw     r27, (a2, 52)
	stw     r28, (a2, 56)
	stw     r29, (a2, 60)
	stw     r30, (a2, 64)
	stw     r31, (a2, 68)
	addi    a2, 72
#else
	stw     sp, (a2, 0)
	stw     lr, (a2, 4)
	stw     r8, (a2, 8)
	stw     r9, (a2, 12)
	stw     r10, (a2, 16)
	stw     r11, (a2, 20)
	stw     r12, (a2, 24)
	stw     r13, (a2, 28)
	stw     r14, (a2, 32)
	addi    a2, 32
	addi    a2, 4
#endif

#ifdef __PIC__
#ifdef	__CSKYABIV2__
	grs     t1, .Lgetpc
.Lgetpc:
	lrw     t0, .Lgetpc@GOTPC
	addu    t1, t0
	lrw     a2, __sigjmp_save@PLT
	ldr.w   a2, (t1, a2 << 0)
	jmp     a2
#else
	mov     a3, lr
	bsr     .Lgetpc
.Lgetpc:
	lrw     r7, .Lgetpc@GOTPC
	addu    r7, lr
	lrw     a2, __sigjmp_save@PLT
	addu    r7, a2
	ldw     r7, (r7)
	mov     lr, a3
	jmp     r7
#endif
#else
	jmpi    __sigjmp_save
#endif

END(__sigsetjmp)

hidden_def (__sigsetjmp)
