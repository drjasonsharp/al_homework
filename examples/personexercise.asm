;
; personexercise.asm
;
; Person exercise.
;
; @author  Jason Sharp
; @version Fall 2026
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
endl	db	10,0
										
		section .bss
x:		resb	40		; reserve 40 bytes for x variable

		section .text
		global 		main
main:
		align_stack

		;; record exercise #1

;		get_str		x,32			;
;		mov			[x+32], eax		; move eax register into value of variable x + 32
									; moves to the end of the "string" and puts length
;		get_i		[x+36]			; get age
;		put_i		x				; beginning address
;		put_str		endl
;		put_str		x				; string value stored at x
;		put_str		endl
;		put_i		eax				; length of string stored in a register	
;		put_str		endl
;		put_i		x+32			; address where
;		put_str		endl
;		put_i		[x+32]
;		put_str		endl
;		put_i		x+36
;		put_str		endl
;		put_i		[x+36]
;		put_ch		10				; places new line at end of chunk or "record"
;		put_str		endl
;		put_str		endl

		;; record exercise #2

		mov			r8, x			; move address of x into r8
		add			r8, 4			; add 4 bytes to r8
		get_str		r8, 32			; add 32 bytes to r8 and get the string, store length in eax
		put_i		eax
		put_str		endl
		mov			[x+36], eax		; move length of string stored in eax to value of x + 36
		get_i		[x]				; prompt for value of age
		put_str		endl
		put_str		r8				; display whatever is stored in r8
		;put_str	endl
		put_i		[x+36]			; display value stored in x + 36
		put_str		endl
		put_i		[x]				; display value stored in x
		;put_str	endl
		put_ch		10				; put newline at end of chunk of data or "record

		; exit
		;mov     eax, 60
		;xor     rdi, rdi
		;syscall

		mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h			; exit


; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits