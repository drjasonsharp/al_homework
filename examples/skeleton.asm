;;
;; skeleton.asm
;;
;; Provides a "skeleton" with necessary components
;; for getting started.
;;
;; @author  Jason Sharp
;; @version Fall 2026
;;
%include "iomacros.asm" ; functions for i/0
%include "dumpregs.asm" ; functions for diplaying register values

		global 		main

		section .data
endl:		db	10,0
prompt1:	db	"Enter 32-bit integer: ",0
prompt2:    db  "Enter 64-bit integer: ",0
msg1:       db  "32-bit integer: ",0
msg2:       db  "64-bit integer: ",0

		section .bss
result:	    resd	1

        section .text

main:
		; If your iomacros.asm macros use printf or scanf,
		; then under the System V AMD64 ABI the stack must be
		; 16-byte aligned before every C library call.

        push rbp
        mov rbp, rsp
        sub rsp, 16          

		; call put_str function to display prompt
		put_str	prompt1
 
        ; call get_i for 32-bit register or memory value
		get_i	r8d ; get_i eax

        ; call put_str to display message
        put_str msg1

        ; call put_i for 32-bit register or memory value
        put_i   r8d ; put_i eax

        ; call put_str function to create new line
        put_str endl

	    ;call put_str function to display prompt
		put_str	prompt2

        ;call get_i64 for 64-bit register or memory value
        get_i64 r8 ; get_i64 rax        

        ; call put_str to display message
        put_str msg2

        ; call put_i for 64-bit register or memory value
        put_i64 r8 ; put_i64 rax

        ; call put_str function to create new line
        put_str endl        

        ; do some processing with mov, add, idiv, imul   

        ; call dump_regs function to show values of 64-bit registers
		dump_regs

		;needed for 16-bit alignment
		add rsp, 16
        pop rbp

        ; exit program
		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits