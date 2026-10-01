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

		align_stack
main:
;		mov	edi, 1
;		mov	rcx, a
;loop:		cmp	edi, 50
;		jg	exitloop
;		mov	[rcx], edi
;		inc	edi
;		add	rcx, 4
;		jmp	loop

;exitloop:
;		mov	rcx, a
;		mov	edi, 1

;printloop:
;		cmp	edi, 50
;		jg	theend
;		put_i	[rcx]
;		put_str	endl
;		add	rcx, 4
;		inc	edi
;		jmp	printloop

; simple loops using new notation

part2:
	mov edi, 0			; zero based counter
	mov ecx, 1			; counter that starts at 1
loop2:	cmp edi, 50		; compare edi to 50
	jge exitloop2		; jump to exitloop2 if greater than or equal to 50
	mov [a + 4*edi], ecx	; move counter starting at 1 into this memory location
							; skip over what is in edi, first time edi is 0
	inc edi			; increment edi
	inc ecx			; increment ecx
	jmp loop2		; unconditional jump to loop2

exitloop2:
	mov edi,0		; move 0 to edi

printloop2:
	cmp edi, 50		; compare edi to 50
	jge theend		; if edi is greater than or equal to 50 jump to theend
	put_i [a + 4*edi] ; display value at address
	put_str endl	; display blank (new) line
	inc edi			; increment edi
	jmp printloop2	; unconditional jump to printloop2

theend:		mov     eax, 60
			xor     rdi, rdi
			syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits