
;
; * AsmUtil.asm
; *
; *  Created on: May 12, 2023
; *      Author: Gal Lior
; */
	.global MemClr
	.global GetUnalignedFloat
	.global GetUnalignedLong
 	.global CopyMemRpt
 	.global ClearMemRpt

GetUnalignedFloat:
GetUnalignedLong:
	push dp:st1
	setc intm

	mov	 al,*xar4++
	mov  ah,*xar4++
	mov32	r0h,acc

	pop	dp:st1
	lretr


MemClr:
;//	MemClr((short unsigned *)&Recorder,sizeof(struct Recorder)  ) ;
	cmp		al,#0
	bf		MemClrExit,eq
	dec		al
	rpt		al ||
		mov	*xar4++,#0
MemClrExit:
	lretr

CopyMemRpt:
; // CopyMemRpt( dst , src , n )
	cmp	al,#0
	bf CopyMemRptExit,eq
	dec	al
	movl	xar7,xar5
	rpt al || pread *xar4++,*xar7
CopyMemRptExit:
	lretr

ClearMemRpt:
; // Clear a memory block in RPT (very fast, uninterruptible)
	cmp	al,#0
	bf ClearMemRptExit,eq

	dec al
	mov	ah,#0
	rpt al || mov*xar4++,ah
ClearMemRptExit:
	lretr








