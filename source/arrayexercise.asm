;;
;; arrayexercise.asm
;;
;; Solution to exercise in class notes.
;;
;; by Terry Sergeant
;;
%include "iomacros.asm"

		global	main
		section .data
endl:		db	10,0

		section .bss

a:		resd	50


		section .text
main:
		mov	edi, 1
		mov	rcx, a
loop:		cmp	edi, 50
		jg	exitloop
		mov	[rcx], edi
		inc	edi
		add	rcx, 4
		jmp	loop

exitloop:
		mov	rcx, a
		mov	edi, 1

printloop:
		cmp	edi, 50
		jg	theend
		put_i	[rcx]
		put_str	endl
		add	rcx, 4
		inc	edi
		jmp	printloop

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

