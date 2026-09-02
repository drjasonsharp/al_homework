;
; addressing_modes.asm
;
; Demonstrates various addressing modes using ADD.
;
; by T.Sergeant
;
;

%include "iomacros.asm"

		global main

		section .data
msg1:		db	"Answer: ",0
format_str:	db	"Enter a number: ",0
myint:		dd	123
endl:		db	10,0

		section .bss
answer:		resd	1


		section .text

main:
		mov	r8d,50
		put_str	msg1
		put_i	r8d
		put_str	endl

		put_str	msg1
		put_i	myint	; !!
		put_str	endl

		put_str	msg1
		put_i	[myint]
		put_str	endl

		put_str	msg1
		put_i	[answer]
		put_str	endl

		add	r8d,10
		put_str	msg1
		put_i	r8d
		put_str	endl

;		add	[answer],10	; !!
;		put_str	msg1
;		put_i	[answer]
;		put_str	endl

		add	dword [answer],10
		put_str	msg1
		put_i	[answer]
		put_str	endl
;
;		add	[answer],r8d
;		put_str	msg1
;		put_i	[answer]
;		put_str	endl
;
;		add	r8d,myint	;!!
;		put_str	msg1
;		put_i	[answer]
;		put_str	endl
;
;		mov	r9,100
;		mov	r8d,50
;		add	r9,r8d		;!!
;		put_str	msg1
;		put_i	r9		;!!
;		put_str	endl


		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall
