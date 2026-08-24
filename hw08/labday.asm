;
; labday.asm
;
; Playing around with the stack.
;

%include "../lib/iomacros.asm"
%include "../lib/dumpregs.asm"

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
