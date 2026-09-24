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
endl:		db	10,0	; LF (end line), null terminator, i.e., new line

		section .bss

a:		resd	50		; an array of 50 double words (200 bytes, 50 x 4)


		section .text
main:
		
		put_i	a
		put_str endl
		put_i	[a]
		put_str endl
		put_str endl

		put_i64 rcx
		put_str endl
		put_i64 [rcx]
		put_str endl
		put_str endl

		mov	edi, 1	; (destination index) often used as loop counters and array indexes
					; assign 1 to edi register

		mov	rcx, a	; move address (a) into register rcx, has address of array a

		put_i edi
		put_str endl
		put_str endl

		put_i64 rcx
		put_str endl
		put_i64 [rcx]
		put_str endl
		put_str endl

loop:	cmp	edi, 50		; compare edi to 50
		jg	exitloop	; edi greater than 50 jump to exitloop
		mov	[rcx], edi	; move edi (which is 1 first time) to value of rcx

		put_str endl
		put_i64 [rcx]
		put_str endl

		inc	edi			; increment edi by 1

		put_i edi
		put_str endl

		add	rcx, 4		; add 4 bytes to rcx register to move to next element (32-bit integer)

		put_i64	rcx
		put_str endl

		jmp	loop		; unconditional loop to jump back to loop

exitloop:
		mov	rcx, a		; assign address (a) to rcx register
		mov	edi, 1		; assign 1 to edi
		put_str endl
		put_i	a
		put_str endl
		put_i64 rcx
		put_str endl
		put_i	edi
		put_str endl

printloop:
		cmp	edi, 50		; compare edi to 50
		jg	theend		; edi greater than 50 jump the end
		put_i	[rcx]	; display value of rcx
		put_str	endl	; display new line
		add	rcx, 4		; add 4 bytes to rcx to move to the next element
		inc	edi			; increment edi by 1 (counter)
		jmp	printloop	; unconditional loop to jump to printloop

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits