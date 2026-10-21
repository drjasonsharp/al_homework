;
; hw08.asm
;
; Playing around with the stack.
;

%include "iomacros.asm"
%include "dumpregs.asm"

		global main

		section	.data
endl:		db	10,0

		section .text

main:
		dump_regs
		put_str	endl
		push	rax
		dump_regs
		put_str	endl
		push	rdi
		dump_regs
		put_str	endl
		mov	rax,-1
		mov	edi,-1
		dump_regs
		put_str	endl
		pop	rax
		pop	rdi
		dump_regs

		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits
