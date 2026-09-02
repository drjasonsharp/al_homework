;
; integer_division.asm
;
; Demonstrates CQO for sign-extending RAX into RDX.
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
		mov	r8,123456789
		mov	r9,-123456789
		mov	r11,7777

		; calculate r12=r8/r11 (15874)
		mov	rax,r8
		;xor	rdx,rdx		;!!
		cqo
		idiv	r11
		mov	r12,rax

		put_str	msg1
		put_i	r12d
		put_str	endl

		; calculate r12=r9/r11 (-15874)
		mov	rax,r9
		;xor	rdx,rdx		;!!
		;mov	rdx,-1		;!!
		cqo			; convert quadword to octoword by
		idiv	r11		; by sign extending RAX into RDX
		mov	r12,rax

		put_str	msg1
		put_i	r12d
		put_str	endl


		; exit(0)
		mov     eax, 60
		xor     rdi, rdi
		syscall
