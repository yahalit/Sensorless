;/*
; * PosPrefilter.asm
; *
; *  Created on: Oct 28, 2023
; *      Author: yahal
; */


	.global PosPref

	; acc: y(k) - u(k)
	; xar4:
	; b0
	; a2
	; 0
	; work
	; y(k-1) (L)
	; y(k-1) (H)
	; y(k) (L)
	; y(k) (H)

PosPref:
	spm		0

	addb	sp,#16
	movl	xar5,xar4
	addb	xar5,#8

	; First stage of filter
	movl	*+xar4[6],acc			; // Store input
	subl	acc,*+xar5[6]		; Make error
	movl	xt,*+xar4[0]
	IMPYL 	p,xt,acc
	qMPYL 	acc,xt,acc			; // acc: p are b * eps
	movl	*-sp[4],acc
	movl	*-sp[6],p           ; store
	MOVL acc,*+xar5[4] ; Load ACC with contents of the low
	SUBUL ACC,*+xar5[0]
	MOVL *-sp[10],ACC ; Store low 32-bit result into VarC
	MOVL ACC,*+xar5[6] ; Load ACC with contents of the high
	SUBBL ACC,*+xar5[2] ; Subtract from ACC the contents of
	movl  *-sp[8],acc  ;
	; // This 64 bit number must now be multiplied by a2
	movl	xt,*-sp[8] ; ;// xt = H(deltaY)
	qmpyl	p,xt,*+xar4[2] ;// p = H( H(deltaY) * a2 )
	movl	*-sp[12],p	;// -sp[12] = H( H(deltaY) * a2 )

	impyl	acc,xt,*+xar4[2]	;// acc = L( H(deltaY) * a2 )
	movl	xt,*-sp[10]		;// xt = L(deltaY)
	QMPYUL	p,xt,*+xar4[2]	 ; // acc = H(L(deltaY)*a2)
	addul	acc,p
	movl	*-sp[14],acc
	movl	acc,*-sp[12]
	addcl	acc,*+xar4[4] ; // Add 0 with carry
	movl	*-sp[12],acc  ; // here -sp[12]:-sp[14] is deltaY * a2

	movl	xt,*+xar5[6]  ; // Store old y as y(k-1)
	movl	*+xar5[2],xt
	movl	xt,*+xar5[4]
	movl	*+xar5[0],xt
; at this point we have b * E at -sp[4]:-sp[6] and (y(k)-y(k-1))*a in -sp[12]:-sp[14]
	movl	acc,*-sp[6]
	addul	acc,*-sp[14]
	movl	p,acc
	movl	acc,*-sp[12]
	addcl	acc,*-sp[4]
; yet the coeficients require another shift
	lsl64	acc:p,#1

; Next we have to add the old state
	movl	xt,acc
	movl	acc,p
	addul	acc,*+xar5[0]
	movl	*+xar5[4],acc
	movl	acc,*+xar5[2]
	addcl	acc,xt
	movl	*+xar5[6],acc ; // High state, will serve as input for the next filter stage

	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Next stage
	addb	XAR4,#16
	addb	XAR5,#16

	; First stage of filter
	movl	*+xar4[6],acc			; // Store input
	subl	acc,*+xar5[6]		; Make error
	movl	xt,*+xar4[0]
	IMPYL 	p,xt,acc
	qMPYL 	acc,xt,acc			; // acc: p are b * eps
	movl	*-sp[4],acc
	movl	*-sp[6],p           ; store
	MOVL acc,*+xar5[4] ; Load ACC with contents of the low
	SUBUL ACC,*+xar5[0]
	MOVL *-sp[10],ACC ; Store low 32-bit result into VarC
	MOVL ACC,*+xar5[6] ; Load ACC with contents of the high
	SUBBL ACC,*+xar5[2] ; Subtract from ACC the contents of
	movl  *-sp[8],acc  ;
	; // This 64 bit number must now be multiplied by a2
	movl	xt,*-sp[8] ; ;// xt = H(deltaY)
	qmpyl	p,xt,*+xar4[2] ;// p = H( H(deltaY) * a2 )
	movl	*-sp[12],p	;// -sp[12] = H( H(deltaY) * a2 )

	impyl	acc,xt,*+xar4[2]	;// acc = L( H(deltaY) * a2 )
	movl	xt,*-sp[10]		;// xt = L(deltaY)
	QMPYUL	p,xt,*+xar4[2]	 ; // acc = H(L(deltaY)*a2)
	addul	acc,p
	movl	*-sp[14],acc
	movl	acc,*-sp[12]
	addcl	acc,*+xar4[4] ; // Add 0 with carry
	movl	*-sp[12],acc  ; // here -sp[12]:-sp[14] is deltaY * a2

	movl	xt,*+xar5[6]  ; // Store old y as y(k-1)
	movl	*+xar5[2],xt
	movl	xt,*+xar5[4]
	movl	*+xar5[0],xt
; at this point we have b * E at -sp[4]:-sp[6] and (y(k)-y(k-1))*a in -sp[12]:-sp[14]
	movl	acc,*-sp[6]
	addul	acc,*-sp[14]
	movl	p,acc
	movl	acc,*-sp[12]
	addcl	acc,*-sp[4]

	; The coeficients require another shift
	lsl64	acc:p,#1
	movl	xt,acc
	movl	acc,p
	addul	acc,*+xar5[0]
	movl	*+xar5[4],acc
	movl	acc,*+xar5[2]
	addcl	acc,xt
	movl	*+xar5[6],acc

; // For the last , we need to return the speed as floating point number
	movl	acc,*+xar5[4]
	subul	acc,*+xar5[0]
	movl	p,acc
	MOVL 	ACC,*+xar5[6] ; Load ACC with contents of the high
	SUBBL 	ACC,*+xar5[2] ; Subtract from ACC the contents of

; // Normalize 64bit
	csb		acc
	cmp		t,#31
	bf		T_Is31,eq
	lsl64	acc:p,t
	bf		NormDone,unc

T_Is31:
	; // Leading is made of same color
	asr64	acc:p,#1	; // So that the least bit from acc goes to p, in case the sign change was between acc and p
	movl	acc,p
	csb		acc
	lsll	acc,t
	add		t,#31	    ; // Thats 32 for the loss of leading DWORD, less 1 for the previous right shift that was reflected into T
						; // before the addition

NormDone:
; // Set the mantissa to floating point at r0h
; // then create the exponent as a pure exponent FP number at r1h, and finally multiply
	movl	*-sp[2],acc
	i32tof32	r0h,*-sp[2]
	movb		acc,#127
	sub			al,t
	mov			t,#23
	lsll		acc,t
	movl		*-sp[2],acc
	mov32		r1h,*-sp[2]
	subb		sp,#16
	mpyf32		r0h,r0h,r1h


	lretr




