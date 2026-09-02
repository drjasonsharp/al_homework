;
; rflags.asm
;
; Demo the put_rflags register.
;
; @author  Terry Sergeant
; @version Fall 2016
;
; There is a register (rflags) that is not a general purpose register that we
; can use directly. This register is useful, though, because many assembly
; language instructions adjust it value as a side-effect. By looking at the
; register we can sometimes determine results of the previous command. The
; macro "put_rflags" provided in dumpregs.asm shows the current contents of
; rflags (without modifying it).
;
; Instructions:
; 1) Open two windows. In one view this source code, in the other compile and run.
; 2) Write in binary the low order byte of the rflags register.
; 3) Compare the first and second calls to put_rflags (did the move commands modify it?)
; 4) For each of the remaining commands look at the resulting value in rflags,
;    convert the lower order byte to binary and write in words which bits were modified
;    to what. For example:
;    "When cmp large,small: the xxx bit of rflags is set to 1 and the yyy bit of rflags ..."
;
%include "dumpregs.asm"

section .text
		global 		main
main:
		put_rflags	; first call
		mov	r9,10
		put_rflags	; second call
		cmp	r9,0	; comparing numbers first > second
		put_rflags	; third call
		cmp	r9,10   ; comparing numbers first = second
		put_rflags	; fourth call
		cmp	r9,12	; comparing numbers first < second
		put_rflags	; fifth call
		add	r9,1	; adding a number with a result > 0
		put_rflags	; sixth call
		mov	r9,-1
		add	r9,1	; adding a number with a result 0
		put_rflags	; seventh call
		mov	r9,-10
		add	r9,1	; adding a number with a result < 0
		put_rflags	; eight call


alldone: 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h		; exit

